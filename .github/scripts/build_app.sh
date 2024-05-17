#!/bin/bash

set -eo pipefail

if [ "$1" = "simple" ]
then
	xcodebuild -workspace AKSideMenuExamples/Simple/AKSideMenuSimple.xcworkspace \
	            -scheme AKSideMenuSimple \
	            -destination platform=iOS\ Simulator,OS=17.2,name=iPhone\ 15 \
	            clean build | xcpretty
elif [ "$2" = "storyboard" ]
then
	xcodebuild -workspace AKSideMenuExamples/Storyboard/AKSideMenuStoryboard.xcworkspace \
	            -scheme AKSideMenuStoryboard \
	            -destination platform=iOS\ Simulator,OS=17.2,name=iPhone\ 15 \
	            clean build | xcpretty 
fi           
