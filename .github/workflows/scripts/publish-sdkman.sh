#!/usr/bin/env bash
set -eu

# latest stable dotty version 
DOTTY_VERSION=$(curl -s https://api.github.com/repos/lampepfl/dotty/releases/latest  | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
DOTTY_URL="https://github.com/lampepfl/dotty/releases/download/$DOTTY_VERSION/scala3-$DOTTY_VERSION.zip"

# checking if dotty version is available 
if ! curl --output /dev/null --silent --head --fail "$DOTTY_URL"; then
  echo "URL not exists: $DOTTY_URL"
  exit 1
fi

# Release a new Candidate Version
curl -X POST \
          -H "Consumer-Key: $SDKMAN_KEY" \
          -H "Consumer-Token: $SDKMAN_TOKEN" \
          -H "Content-Type: application/json" \
          -H "Accept: application/json" \
          -d '{"candidate": "scala", "version": "'"$DOTTY_VERSION"'", "url": "'"$DOTTY_URL"'"}' \
          https://vendors.sdkman.io/release

# Set DOTTY_VERSION as Default for Candidate
curl -X PUT \
    -H "Consumer-Key: $SDKMAN_KEY" \
    -H "Consumer-Token: $SDKMAN_TOKEN" \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -d '{"candidate": "scala", "version": "'"$DOTTY_VERSION"'"}' \
    https://vendors.sdkman.io/default
