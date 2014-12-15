#!/bin/bash
#change the KILL_XBMC_BEFORE_STARTING_PULSEAUDIO= to yes if you want to stop xbmc before starting pulseaudio
#killing xbmc before starting pulseaudio will ensure the steam bpm gui has sound but will reduce the seamlessness of the addon

KILL_XBMC_BEFORE_STARTING_PULSEAUDIO=no

if [[ $KILL_XBMC_BEFORE_STARTING_PULSEAUDIO = yes ]] ; then
  kill -9 $(pidof xbmc.bin)
fi

pulseaudio --start
