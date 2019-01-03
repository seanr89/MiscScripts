#!/bin/bash

NodeVersion=`node -v`

echo Current version of node: $NodeVersion

NPMVersion=`npm -v`

echo Current version of npm: $NPMVersion

#Current Version of brew
BrewVersion=`brew -v`
echo Current version of brew: $BrewVersion

#current version of git
GitVersion=`git --version`
echo Current version of git: $GitVersion

#Current version of yeoman
YeomanVersion=`yo --version`
echo Current version of Yeoman: $YeomanVersion

#what else?

# Useful brew command
echo brew list
