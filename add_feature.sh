#!/bin/bash

# Ask for the name of the feature
read -p "Enter the name of the feature: " feature_name

# Define the root folder path
root_folder="lib/src/features"

# Create the feature folder
feature_folder="$root_folder/$feature_name"
mkdir -p "$feature_folder"

# Create subfolders and files
# 1. providers folder
mkdir -p "$feature_folder/providers"
touch "$feature_folder/providers/provider.dart"
touch "$feature_folder/providers/state.dart"

# 2. views folder
mkdir -p "$feature_folder/views"
touch "$feature_folder/views/$feature_name.dart"

# Output success message
echo "Folder structure created under $feature_folder:"
echo "- providers/provider.dart"
echo "- providers/state.dart"
echo "- views/$feature_name.dart"
