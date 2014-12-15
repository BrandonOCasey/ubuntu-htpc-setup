#! /usr/bin/env bash
echo "Stopping at $(date)"

echo "Stopping all"
output="$(transmission-remote --torrent all --stop)"

echo "Download limit to 0"
output="$(transmission-remote --downlimit 0 --uplimit 0)"

echo "Start all torrents paused"
output="$(transmission-remote --start-paused)"
