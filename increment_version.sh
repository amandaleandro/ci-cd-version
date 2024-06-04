#!/bin/bash

# Check if Git is installed
if ! command -v git &> /dev/null; then
  echo "Git is not installed. Please install Git and try again."
  exit 1
fi

# Navigate to the repository directory
cd "$(dirname "$0")"

# Ensure script is executed in the context of a Git repository
if ! git rev-parse --is-inside-work-tree &> /dev/null; then
  echo "This script must be executed inside a Git repository."
  exit 1
fi

# Ensure script has execution permissions
if [[ ! -x "$0" ]]; then
  echo "Script does not have execute permissions. Grant execute permissions using 'chmod +x $0'."
  exit 1
fi

# Ensure we are on the main branch
current_branch=$(git rev-parse --abbrev-ref HEAD)
if [ "$current_branch" != "main" ]; then
  echo "This script must be executed on the 'main' branch."
  exit 1
fi

# Get the latest tag version or set it to v1.0.0 if no tags exist
latest_tag=$(git describe --tags --abbrev=0 2>/dev/null)
if [ -z "$latest_tag" ]; then
  latest_tag="v1.0.0"
  echo "No previous tags found. Starting with version $latest_tag."
fi

# Extract the version components from the latest tag
version=$(echo "$latest_tag" | cut -d'v' -f2)

# Extract major, minor, and patch versions
IFS='.' read -r major minor patch <<< "$version"

# Check the commits to determine whether to increment major, minor, or patch
commit_messages=$(git log --pretty=format:"%s" ${latest_tag}..HEAD)
echo "Commit messages since latest tag:"
echo "$commit_messages"

if [[ $commit_messages == *"BREAKING CHANGE"* ]]; then
  # If there are commits with the message "BREAKING CHANGE", increment the major version
  major=$((major + 1))
  minor=0
  patch=0
  echo "Breaking change detected. Incrementing major version to $major."
elif [[ $commit_messages == *"feat"* ]]; then
  # If there are commits with the keyword "feat", increment the minor version
  minor=$((minor + 1))
  patch=0
  echo "Feature commits detected. Incrementing minor version to $minor."
else
  # Otherwise, increment the patch version
  patch=$((patch + 1))
  echo "Incrementing patch version to $patch."
fi

# Create the new version
new_version="v$major.$minor.$patch"
echo "New version: $new_version"

# Output the new version to a file
echo "$new_version" > version.txt

# Check if the tag already exists
if git rev-parse "$new_version" >/dev/null 2>&1; then
  echo "Tag $new_version already exists. Exiting without creating a new tag."
  exit 0
fi

# Tag the repository with the new version
git tag "$new_version"
git push origin "$new_version"
