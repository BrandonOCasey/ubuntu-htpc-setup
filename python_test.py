#! /usr/bin/env python
import sys
import os
import pwd
import grp

#cache = apt.cache.Cache()



"""
All of the static variables & configuration for our program
"""

class StaticVariables:
	user = "blondebeard"
	group = "blondebeard"
	user_id = pwd.getpwnam(user).pw_uid
	group_id = grp.getgrnam(group).gr_gid
	repos = [
		"ppa:glennric/dolphin-emu", "ppa:gregory-hainaut/pcsx2.official.ppa", "ppa:falk-t-j/qtsixa",
		"ppa:hunter-kaller/ppa", "ppa:transmissionbt/ppa", "ppa:emulationstation/ppa", "ppa:vidplace7/bluez5"
	]
	programs = [
		"sm-ssc", "qtsixa", "bluez", "openvpn",	"network-manager-openvpn", "network-manager-openvpn-gnome", 
		"vim", "wicd-curses", "openssh-server", "terminator", "dolphin-emu", "retroarch", "libretro*",
		"git", "zenity", "transmision", "wmctrl", "python-setuptools", "python-cheetah", "unrar",
		"transmission-cli", "pcsx2", "transmission-daemon", "jmtpfs", "smartmontools", "unattended-upgrades",
		"apache2", "php5", "transmission-common", "monit", "emulationstation", "steam", "bluez-tools"
	]
	
	directories = {
		"binaries": os.path.expanduser("~") + "/Binaries",
		"programs": "/opt/HtpcPrograms",
		"games":  os.path.expanduser("~") + "/Games",
	}
	

def createDirectory(directory):
	if not os.path.exists(directory):
		os.makedirs(directory)
	os.chown(directory, StaticVariables.user_id, StaticVariables.group_id)

	


def setup():
	for name, directory in StaticVariables.directories.iteritems():
		createDirectory(directory)

	for repo in StaticVariables.repos:
 		os.system("sudo add-apt-repository " + repo + " -y")
		
	os.system("sudo apt-get update -y");
	os.system("sudo apt-get upgrade -y");
	os.system("sudo apt-get install -y " + " ".join(StaticVariables.programs))
	os.system("sudo apt-get autoremove -y");



setup()
