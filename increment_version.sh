#!/bin/bash

# Check if Git is installed
if ! command -v git &> /dev/null; then
    echo "Git is not installed. Please install Git and try again."
    exit 1
fi

# Get the latest tag version
latest_tag=$(git describe --tags --abbrev=0 2>/dev/null)

# Check if it's the first commit
if [ -z "$latest_tag" ]; then
  # If it's the first commit, start with version 1.0.0
  new_version="1.0.0"
else
  # Extract the version components from the latest tag
  major=$(echo "$latest_tag" | cut -d. -f1)
  minor=$(echo "$latest_tag" | cut -d. -f2)
  patch=$(echo "$latest_tag" | cut -d. -f3)

  # Check the commits to determine whether to increment major, minor, or patch
  commit_messages=$(git log --pretty=format:"%s" ${latest_tag}..HEAD)
  if [[ $commit_messages == *"BREAKING CHANGE"* ]]; then
    # If there are commits with the message "BREAKING CHANGE", increment the major version
    major=$((major + 1))
    minor=0
    patch=0
  elif [[ $commit_messages == *"feat"* ]]; then
    # If there are commits with the keyword "feat", increment the minor version
    minor=$((minor + 1))
    patch=0
  else
    # Otherwise, increment the patch version
    patch=$((patch + 1))
  fi

  # Reset patch to zero if major or minor changed
  if [[ "$major" -ne $(echo "$latest_tag" | cut -d. -f1) || "$minor" -ne $(echo "$latest_tag" | cut -d. -f2) ]]; then
    patch=0
  fi

  # Create the new version
  new_version="$major.$minor.$patch"
fi

# Output the new version to a file
echo "$new_version" > version.txt
