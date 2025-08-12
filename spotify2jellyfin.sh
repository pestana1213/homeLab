#!/bin/bash

# Usage: ./spotify2jellyfin.sh <spotify-url>

if [ -z "$1" ]; then
  echo "Usage: $0 <spotify-url>"
  exit 1
fi

SPOTIFY_URL="$1"
LOCAL_TMP_DIR="/tmp/spotdl-download"
JELLYFIN_NAMESPACE="playground"
JELLYFIN_LABEL="app=jellyfin"  # adjust if different
JELLYFIN_MUSIC_PATH="/music"
TIMEOUT_SECONDS=300  # 5 minutes timeout per track

echo "Preparing to download Spotify URL: $SPOTIFY_URL"

# Clean and create tmp dir
rm -rf "$LOCAL_TMP_DIR"
mkdir -p "$LOCAL_TMP_DIR"

echo "Extracting individual track URLs..."

# Get track URLs (one per line)
TRACK_URLS=$(spotdl --list-tracks "$SPOTIFY_URL")

if [ -z "$TRACK_URLS" ]; then
  echo "Error: Failed to get track list from spotdl."
  exit 1
fi

echo "Found $(echo "$TRACK_URLS" | wc -l) tracks. Starting downloads one by one..."

FAILURES=()

for TRACK_URL in $TRACK_URLS; do
  echo "Downloading track: $TRACK_URL"
  
  # Run spotdl with timeout per track
  if timeout $TIMEOUT_SECONDS spotdl --threads 1 --output "$LOCAL_TMP_DIR" "$TRACK_URL"; then
    echo "Successfully downloaded: $TRACK_URL"
  else
    echo "Failed or timed out downloading: $TRACK_URL"
    FAILURES+=("$TRACK_URL")
  fi
done

echo "All downloads attempted."

if [ ${#FAILURES[@]} -ne 0 ]; then
  echo "Warning: The following tracks failed to download or timed out:"
  for fail in "${FAILURES[@]}"; do
    echo "  - $fail"
  done
fi

echo "Finding Jellyfin pod..."

# Get Jellyfin pod name
JELLYFIN_POD=$(sudo kubectl get pods -n "$JELLYFIN_NAMESPACE" -l "$JELLYFIN_LABEL" -o jsonpath="{.items[0].metadata.name}")

if [ -z "$JELLYFIN_POD" ]; then
  echo "Error: Jellyfin pod not found in namespace $JELLYFIN_NAMESPACE"
  exit 1
fi

echo "Copying downloaded music to Jellyfin pod $JELLYFIN_POD:$JELLYFIN_MUSIC_PATH ..."

if sudo kubectl cp "$LOCAL_TMP_DIR/." "$JELLYFIN_NAMESPACE/$JELLYFIN_POD:$JELLYFIN_MUSIC_PATH"; then
  echo "Copy complete."
else
  echo "Error: Failed to copy files to Jellyfin pod."
  exit 1
fi

echo "Done!"
