#! /usr/bin/env bash
echo "$0 at $(date)"
echo "Starting all downloads"
output="$(transmission-remote --torrent all --start)"
echo "Setting download limit to 200"
output="$(transmission-remote --downlimit 200 --uplimit 10)"
echo "Making torrents start when added"
output="$(transmission-remote --no-start-paused)"
