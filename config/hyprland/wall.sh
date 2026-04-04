#!/usr/bin/env bash

WALL_DIR="/mnt/Localdisk/folder/wall"

# Check if directory exists
if [ ! -d "$WALL_DIR" ]; then
    echo "Wallpaper directory not found: $WALL_DIR"
    exit 1
fi

# Pick a random image
WALLPAPER=$(find "$WALL_DIR" -type f \( \
    -iname "*.jpg" -o \
    -iname "*.jpeg" -o \
    -iname "*.png" -o \
    -iname "*.webp" \
\) | shuf -n 1)

# Check if an image was found
if [ -z "$WALLPAPER" ]; then
    echo "No images found in $WALL_DIR"
    exit 1
fi

# Set wallpaper with awww
awww img "$WALLPAPER" \
    --transition-type any \
    --transition-step 200

echo "Wallpaper set to: $WALLPAPER"
