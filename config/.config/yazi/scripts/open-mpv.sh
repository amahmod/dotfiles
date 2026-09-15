#!/usr/bin/env bash

# Yazi MPV Opener Wrapper
# -- ensures filenames with special characters or leading dashes are never parsed as mpv flags

if [ $# -eq 0 ]; then
    exit 0
fi

exec mpv -- "$@"
