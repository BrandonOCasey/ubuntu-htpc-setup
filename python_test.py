#! /usr/bin/env python
import sys
import os
import pwd
import grp
from softwareproperties.SoftwareProperties import SoftwareProperties
import apt
import aptsources

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
		"ppa:hunter-kaller/ppa", "ppa:transmissionbt/ppa", "ppa:emulationstation/ppa", 
	]
	programs = [
		"sm-ssc", "qtsixa", "bluez", "openvpn",	"network-manager-openvpn", "network-manager-openvpn-gnome", 
		"vim", "wicd-curses", "openssh-server", "terminator", "dolphin-emu", "retroarch", "libretro*",
		"git", "zenity", "transmision", "wmctrl", "python-setuptools", "python-cheetah", "unrar",
		"transmission-cli", "pcsx2", "transmission-daemon", "jmtpfs", "smartmontools", "unattended-upgrades",
		"apache2", "php5", "transmission-common", "monit", "emulationstation",
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
	


# TODO: Test sourceslist add function
def setup():
	for name, directory in StaticVariables.directories.iteritems():
		createDirectory(directory)
#	for repo in StaticVariables.repos:
#		aptsources.sourceslist.SourcesList().add(repo)
#		aptsources.sourceslist.SourcesList().save()


	cache = apt.cache.Cache()
	cache.update()
	cache.open()

	for program in StaticVariables.programs:
		pkg = cache[program]
		if pkg.is_installed:
			print "{pkg_name} already installed".format(pkg_name=program)
		else:
			pkg.mark_install()

	try:
		cache.commit()
	except Exception, arg:
		print >> sys.stderr, "Sorry, package installation failed [{err}]".format(err=str(arg))




setup()
sys.exit()

"""
# Setup

function install_program() {
        local name="$1"; shift
        local url="$1"; shift
        local two_letters="$1"; shift
        local init="$1"; shift

        local folder="$(echo "$(basename "$url")" | sed -e 's~\.git$~~')"
        folder="$programs/$folder"
        echo "Installing $name in $folder"

        if [ ! -d "$folder" ] && [ ! -d "$folder/.git" ]; then
                (cd "$programs" && git clone $url)
        fi

        sudo echo "# Sym Link This FILE TO /etc/default/$name
        ${two_letters}_HOME=$folder
        ${two_letters}_DATA=$folder
        ${two_letters}_USER=$USER" > "$folder/default"
        sudo chmod +x "$folder/default"

        sudo update-rc.d -f "$name" remove > /dev/null
        if [ -f /etc/default/"$name" ] || [ -L /etc/default/"$name" ]; then
                sudo rm /etc/default/"$name"
        fi
        if [ -f /etc/init.d/"$name" ] || [ -L /etc/init.d/"$name" ]; then
                sudo rm /etc/init.d/"$name"
        fi

        sudo ln -s "$folder/default" /etc/default/"$name"
        sudo ln -s "$folder/$init" /etc/init.d/"$name"
        sudo update-rc.d "$name" defaults > /dev/null

}

echo "Downloading Extra Addons"
cd ~/Downloads
sudo wget http://srp.nu/gotham/all/repository.superrepo.org.gotham.all-latest.zip -q


echo "Adding PPA Repos"
while read -r repo; do
	if [ -n "$repo" ]; then
	       sudo add-apt-repository "$repo" -y
	fi
done <<< "$repos"

sudo wget http://archive.getdeb.net/install_deb/playdeb_0.3-1~getdeb1_all.deb -q
$(sudo dpkg -i playdeb_0.3-1~getdeb1_all.deb)
rm playdeb*

echo "Downloading Private Internet Access"
mkdir ~/.pia
cd ~/.pia
sudo wget https://www.privateinternetaccess.com/openvpn/openvpn.zip
sudo unzip openvpn.zip
sudo rm openvpn.zip


echo "Installing and updating"
sudo apt-get update
sudo apt-get install -y sudo apt-get install -y
sudo apt-get upgrade -y
sudo apt-get autoremove -y

echo "Installing Steam"
sudo wget http://media.steampowered.com/client/installer/steam.deb
sudo dpkg -i steam.deb
rm steam.deb


install_program "sickbeard" "https://github.com/SiCKRAGETV/SickRage" "SB" "init.ubuntu"
cp "$programs"/SickRage/autoProcessTV/autoProcessTV.cfg.sample "$programs/SickRage"/autoProcessTV/autoProcessTV.cfg

install_program "couchpotato" "git://github.com/RuudBurger/CouchPotatoServer.git" "CP" "init/ubuntu"
install_program "headphones" "https://github.com/rembo10/headphones.git" "HP" "init-scripts/init.ubuntu"

echo "Configuring things"
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo ln -s /usr/lib/i386-linux-gnu/mesa/libGL.so.1 /usr/lib

echo "Vim Script to see how to fix retroarch"
#retro_config="$(find ~ -name "retroarch.cfg")"
#sudo sed -i 's~libretro_directory = ""~libretro_directory = "/usr/lib/libretro"~g' "$retro_config"

echo "Starting SSH Access"
sudo restart ssh

echo "Doing Transmission Setup"
/etc/init.d/transmission-daemon stop > /dev/null

echo "Adding dance/joy pad support"
sudo modprobe xpad
sudo modprobe analog
sudo modprobe joydev

echo "
joydev
analog
joydev
" | sudo tee --append /etc/modules > /dev/null
"""
