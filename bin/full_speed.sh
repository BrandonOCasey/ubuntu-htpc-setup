#! /usr/bin/env bash
echo "$0 at $(date)"

echo "Starting all downloads"
output="$(transmission-remote --torrent all --start)"
echo "Setting download limit to 400"
output="$(transmission-remote --downlimit 400 --uplimit 40)"
echo "Making torrents start when added"
output="$(transmission-remote --no-start-paused)"
