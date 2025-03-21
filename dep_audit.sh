#!/bin/bash
echo "Starting manual dependency audit..."

# List all dependencies
echo "Installed dependencies:"
npm list --depth=0 > deps.txt
cat deps.txt

# Check for outdated ones
echo -e "\nChecking outdated dependencies..."
npm outdated > outdated.txt
cat outdated.txt

# Guess at unused ones (very crude)
echo -e "\nLooking for potentially unused dependencies..."
for dep in $(npm list --depth=0 | grep '├──' | cut -d' ' -f2 | cut -d@ -f1); do
    if ! find . -type f -name "*.js" -o -name "*.tsx" -o -name "*.ts" | xargs grep -l "$dep" > /dev/null 2>&1; then
        echo "$dep might be unused"
    fi
done

echo "Done! Check deps.txt and outdated.txt manually. Phew that was a lot of work!"
