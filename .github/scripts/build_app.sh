#!/usr/bin/env bash

set -eo pipefail

# Configuration
IOS_VERSION="26.2"
SIMULATOR_NAME="iPhone 17 Pro"

# Function to print usage
usage() {
	echo "Usage: $0 <example>"
	echo "  simple      - Build the Simple example"
	echo "  storyboard  - Build the Storyboard example"
	exit 1
}

# Validate arguments
if [ $# -eq 0 ]; then
	usage
fi

# Build function
build_example() {
	local example=$1
	local workspace="AKSideMenuExamples/${example^}/AKSideMenu${example^}.xcworkspace"
	local scheme="AKSideMenu${example^}"
	
	echo "Building $example example..."
	xcodebuild -workspace "$workspace" \
	           -scheme "$scheme" \
	           -destination "platform=iOS Simulator,OS=$IOS_VERSION,name=$SIMULATOR_NAME" \
	           clean build | xcpretty
}

# Process arguments
case "$1" in
	simple|storyboard)
		build_example "$1"
		;;
	*)
		echo "Error: Unknown example '$1'"
		usage
		;;
esac           
