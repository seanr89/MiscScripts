#!/bin/bash

# Script to fetch all release versions for a GitHub repository.
#
# Usage: ./get_github_releases.sh <owner> <repo>
# Example: ./get_github_releases.sh "octocat" "Spoon-Knife"
#
# Dependencies: curl, jq
# - curl: to make HTTP requests to the GitHub API.
# - jq: to parse the JSON response from the API.
#
# You can install these on Debian/Ubuntu using:
# sudo apt-get update && sudo apt-get install curl jq
#
# On macOS using Homebrew:
# brew install curl jq
#
# For other systems, please refer to their respective package managers.

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <owner> <repo>"
    echo "Example: $0 \"octocat\" \"Spoon-Knife\""
    exit 1
fi

OWNER="$1"
REPO="$2"
API_URL="https://api.github.com/repos/${OWNER}/${REPO}/releases"

# Optional: GitHub Personal Access Token for private repos or to avoid rate limiting
# If you have a token, uncomment the line below and set your token.
# GITHUB_TOKEN="your_github_personal_access_token"

echo "Fetching releases for ${OWNER}/${REPO}..."
echo ""

# Construct the curl command
# The -s flag makes curl silent (no progress meter or error messages).
# The -L flag makes curl follow redirects.
CURL_CMD="curl -s -L"

# Add Authorization header if GITHUB_TOKEN is set
if [ -n "${GITHUB_TOKEN}" ]; then
    CURL_CMD="${CURL_CMD} -H \"Authorization: Bearer ${GITHUB_TOKEN}\""
fi

# Add Accept header for the GitHub API
CURL_CMD="${CURL_CMD} -H \"Accept: application/vnd.github.v3+json\""

# Make the API request and parse the response
# We use jq to extract the 'tag_name' from each object in the JSON array.
# The '-r' flag for jq outputs raw strings, not JSON-escaped strings.
# If the API returns an error (e.g., repo not found), jq might fail or output 'null'.
# We also check if the http_code is 200.

HTTP_RESPONSE=$(mktemp)
HTTP_CODE=$(${CURL_CMD} "${API_URL}" -w "%{http_code}" -o "${HTTP_RESPONSE}")

if [ "${HTTP_CODE}" -eq 200 ]; then
    RELEASES=$(jq -r '.[].tag_name' "${HTTP_RESPONSE}")

    if [ -z "$RELEASES" ]; then
        echo "No releases found for ${OWNER}/${REPO}."
        # Check if it's an empty array vs an error in jq parsing or API structure change
        IS_EMPTY_ARRAY=$(jq 'if type == "array" and length == 0 then true else false end' "${HTTP_RESPONSE}")
        if [ "${IS_EMPTY_ARRAY}" != "true" ]; then
             echo "Note: The repository might exist but have no releases, or there was an issue parsing the release data."
        fi
    else
        echo "Release versions:"
        echo "${RELEASES}"
    fi
else
    echo "Error fetching releases from GitHub API."
    echo "HTTP Status Code: ${HTTP_CODE}"
    # Display error message from GitHub API if available and not empty
    if [ -s "${HTTP_RESPONSE}" ]; then
        echo "Response:"
        # Try to pretty-print if it's JSON, otherwise cat
        if jq -e . "${HTTP_RESPONSE}" > /dev/null 2>&1; then
            jq . "${HTTP_RESPONSE}"
        else
            cat "${HTTP_RESPONSE}"
        fi
    fi
    echo ""
    echo "Please check the owner, repository name, and your network connection."
    echo "For private repositories, or to avoid rate limiting, you might need to use a GitHub Personal Access Token."
    echo "See the GITHUB_TOKEN variable in the script."
fi

# Clean up temporary file
rm -f "${HTTP_RESPONSE}"

exit 0
