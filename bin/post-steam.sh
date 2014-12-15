#!/bin/bash
#change the ALWAYS_KILL_PULSEAUDIO_BEFORE_STARTING_XBMC= to yes if you want to stop pulseaudio before starting xbmc
#killing pulseaudio before starting xbmc will ensure that xbmc always uses alsa, but steam may not like having pulseaudio stopped while steam is still running (via 'exit to desktop')

ALWAYS_KILL_PULSEAUDIO_BEFORE_STARTING_XBMC=no

if [[ $ALWAYS_KILL_PULSEAUDIO_BEFORE_STARTING_XBMC = yes ]] ; then
  pulseaudio -k
fi

#change the KILL_PULSEAUDIO_ONLY_WHEN_COMPLETELY_EXITING_STEAM= to no if you dont want to stop pulseaudio only when completely exiting steam
#if yes xbmc will use pulseaudio when steam is running (via 'exit to desktop')
#change the SECONDS_TO_WAIT= to alter the time to wait after closing BPM to check if steam is still running, 2 seconds is good for my system although this could vary from system to system. This will cause xbmc to take 2 seconds longer to restart.

KILL_PULSEAUDIO_ONLY_WHEN_COMPLETELY_EXITING_STEAM=yes
SECONDS_TO_WAIT=2

if [[ $KILL_PULSEAUDIO_ONLY_WHEN_COMPLETELY_EXITING_STEAM = yes ]] ; then
  sleep $SECONDS_TO_WAIT
  if [[ ! $(pidof steam) ]] ; then
    pulseaudio -k
  fi
fi
