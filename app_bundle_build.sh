#!/bin/bash

read -p "$(tput bold)$(tput setaf 3)Did you update the app vesrion & .env cred ?$(tput sgr0)" update

echo "Select platform to build:"
echo "1. Android (App Bundle)"
echo "2. iOS"

read -p "Enter choice (1/2): " choice

flutter clean && flutter pub get
sh generate_env.sh
dart run build_runner build --delete-conflicting-outputs

if [ "$choice" == "1" ]; then
    echo "Building for Android..."
    if flutter build appbundle; then
        echo "$(tput bold)$(tput setaf 2)Android appbundle generated.$(tput sgr0)"
    else
        echo "$(tput bold)$(tput setaf 1)Failed to generate Android appbundle.$(tput sgr0)"
    fi
elif [ "$choice" == "2" ]; then
    echo "Building for iOS..."
    if cd ios && pod deintegrate && pod install && pod update && cd ..; then
        echo "$(tput bold)$(tput setaf 2)Open Project in XCode to deploy your app to AppStore.$(tput sgr0)"
    else
        echo "$(tput bold)$(tput setaf 1)Failed to prepare iOS project. Check the error logs.$(tput sgr0)"
    fi
else
    echo "Invalid choice. Exiting."
fi
