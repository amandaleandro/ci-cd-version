#!/bin/bash

# Check if Git is installed
if ! command -v git &> /dev/null; then
    echo "Git is not installed. Please install Git and try again."
    exit 1
fi

# Get the latest tag version
latest_tag=$(git describe --tags --abbrev=0 2>/dev/null)

# Check if the latest tag exists
if [ -z "$latest_tag" ]; then
  # If there are no tags, start with version 1.0.0
  new_version="1.0.0"
else
  # Extract the version components
  major=$(echo "$latest_tag" | cut -d. -f1)
  minor=$(echo "$latest_tag" | cut -d. -f2)
  patch=$(echo "$latest_tag" | cut -d. -f3)

  # Increment the version according to semantic versioning
  if [ "$major" -eq "0" ]; then
    # If the major version is 0, increment the minor version
    minor=$((minor + 1))
  else
    # Otherwise, check the commits to determine whether to increment major, minor, or patch
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
  fi

  # Create the new version
  new_version="$major.$minor.$patch"
fi

echo "New version: $new_version"