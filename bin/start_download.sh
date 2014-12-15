#! /usr/bin/env bash
echo "Starting at $(date)"
echo "Starting all downloads"
output="$(transmission-remote --torrent all --start)"
echo "Setting download limit to none"
output="$(transmission-remote --downlimit 400 --uplimit 40)"
echo "Making torrents start when added"
output="$(transmission-remote --no-start-paused)"
