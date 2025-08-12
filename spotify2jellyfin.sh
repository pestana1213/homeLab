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

echo "Downloading Spotify URL: $SPOTIFY_URL"

# Clean and create tmp dir
rm -rf "$LOCAL_TMP_DIR"
mkdir -p "$LOCAL_TMP_DIR"

# Download music with spotdl
spotdl --threads 2 "$SPOTIFY_URL" --output "$LOCAL_TMP_DIR"

echo "Download complete. Finding Jellyfin pod..."

# Get Jellyfin pod name
JELLYFIN_POD=$(sudo kubectl get pods -n "$JELLYFIN_NAMESPACE" -l "$JELLYFIN_LABEL" -o jsonpath="{.items[0].metadata.name}")

if [ -z "$JELLYFIN_POD" ]; then
  echo "Error: Jellyfin pod not found in namespace $JELLYFIN_NAMESPACE"
  exit 1
fi

echo "Copying downloaded music to Jellyfin pod $JELLYFIN_POD:$JELLYFIN_MUSIC_PATH ..."

sudo kubectl cp "$LOCAL_TMP_DIR/." "$JELLYFIN_NAMESPACE/$JELLYFIN_POD:$JELLYFIN_MUSIC_PATH"

echo "Copy complete."

echo "Done!"
