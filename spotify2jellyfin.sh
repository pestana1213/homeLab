#!/bin/bash

# Usage: ./spotify2jellyfin.sh <spotify-url>

if [ -z "$1" ]; then
  echo "Usage: $0 <spotify-url>"
  exit 1
fi

SPOTIFY_URL="$1"
LOCAL_TMP_DIR="/tmp/spotdl-download"
JELLYFIN_NAMESPACE="playground"
JELLYFIN_LABEL="app=jellyfin" # adjust if different
JELLYFIN_MUSIC_PATH="/music"
JELLYFIN_API_KEY="" # optional, get from Jellyfin dashboard
JELLYFIN_API_URL="http://http://192.168.1.195:30086"

echo "Downloading Spotify URL: $SPOTIFY_URL"

# Clean and create tmp dir
rm -rf "$LOCAL_TMP_DIR"
mkdir -p "$LOCAL_TMP_DIR"

# Download music with spotdl
spotdl "$SPOTIFY_URL" --output "$LOCAL_TMP_DIR"

echo "Download complete. Finding Jellyfin pod..."

# Get Jellyfin pod name
JELLYFIN_POD=$(kubectl get pods -n "$JELLYFIN_NAMESPACE" -l "$JELLYFIN_LABEL" -o jsonpath="{.items[0].metadata.name}")

if [ -z "$JELLYFIN_POD" ]; then
  echo "Error: Jellyfin pod not found in namespace $JELLYFIN_NAMESPACE"
  exit 1
fi

echo "Copying downloaded music to Jellyfin pod $JELLYFIN_POD:$JELLYFIN_MUSIC_PATH ..."

kubectl cp "$LOCAL_TMP_DIR/." "$JELLYFIN_NAMESPACE/$JELLYFIN_POD:$JELLYFIN_MUSIC_PATH"

echo "Copy complete."

# Trigger Jellyfin scan (optional)
if [ -n "$JELLYFIN_API_KEY" ]; then
  echo "Triggering Jellyfin music library scan..."

  # Get music library ID
  LIBRARY_ID=$(curl -s -H "X-Emby-Token: $JELLYFIN_API_KEY" "$JELLYFIN_API_URL/emby/Library/MediaFolders" | jq -r '.MediaFolders[] | select(.Path | contains("music")) | .Id')

  if [ -z "$LIBRARY_ID" ]; then
    echo "Warning: Could not find music library ID"
  else
    curl -X POST -H "X-Emby-Token: $JELLYFIN_API_KEY" "$JELLYFIN_API_URL/emby/Library/Refresh?LibraryId=$LIBRARY_ID"
    echo "Scan triggered."
  fi
else
  echo "No Jellyfin API key set; please rescan library manually in Jellyfin UI."
fi

echo "Done!"
