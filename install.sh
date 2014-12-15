#! /usr/bin/env bash
set -e 

# Setup
programs="$HOME/.programs"
if [ ! -d "$programs" ]; then
        mkdir "$programs"
fi


function add_repo() {
	sudo add-apt-repository "$1" -y
}
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
sudo wget http://srp.nu/gotham/all/repository.superrepo.org.gotham.all-latest.zip


echo "Adding Play Deb Repo"
sudo wget http://archive.getdeb.net/install_deb/playdeb_0.3-1~getdeb1_all.deb
sudo dpkg -i playdeb_0.3-1~getdeb1_all.deb

echo "Downloading Private Internet Access"
mkdir ~/.pia
cd ~/.pia
sudo wget https://www.privateinternetaccess.com/openvpn/openvpn.zip
sudo unzip openvpn.zip
sudo rm openvpn.zip

echo "Installing Repos"
add_repo "ppa:glennric/dolphin-emu"
add_repo "ppa:gregory-hainaut/pcsx2.official.ppa"
add_repo "ppa:falk-t-j/qtsixa"
add_repo "ppa:hunter-kaller/ppa -y"

echo "Installing and updating"
sudo apt-get update
sudo apt-get install -y sm-ssc qtsixa bluez openvpn network-manager-openvpn \
network-manager-openvpn-gnome vim wicd-curses openssh-server terminator dolphin-emu pcsx2 \
retroarch libretro* git zenity transmission wmctrl python-setuptools python-cheetah \
unrar transmission-cli transmission-daemon jmtpfs smartmontools unattended-upgrades \
apache2 php5
sudo apt-get install -y 
sudo apt-get upgrade -y
sudo apt-get autoremove -y

echo "Installing Steam"
sudo wget http://media.steampowered.com/client/installer/steam.deb
sudo dpkg -i steam.deb
rm steam.deb


install_program "sickbeard" "https://github.com/junalmeida/Sick-Beard.git" "SB" "init.ubuntu"
cp "$programs"/Sick-Beard/autoProcessTV/autoProcessTV.cfg.sample "$programs/Sick-Beard"/autoProcessTV/autoProcessTV.cfg

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
sudo sed -i "s/setgid debian-transmission/$USER/g" /etc/init/transmission-daemon.conf
sudo sed -i "s/setuid debian-transmission/$USER/g" /etc/init/transmission-daemon.conf
sudo sed -i "s/USER=.*/USER=$USER/g" /etc/init.d/transmission-daemon
sudo chown -R "$USER":"$USER" /var/lib/transmission-daemon
sudo chown -R "$USER":"$USER" /etc/transmission-daemon
sudo sed -i "s~\"download-dir\":.*~\"download-dir\": \"$HOME/Downloads\",~"  /etc/transmission-daemon/settings.json
sudo sed -i "s~\"rpc-whitelist-enabled\".*~\"rpc-whitelist-enabled\": false,~" /etc/transmission-daemon/settings.json

sudo sed -i "s~\"download-dir\":.*~\"download-dir\": \"$HOME/Downloads\",~"  "$HOME"/.config/transmission-daemon/settings.json
sudo sed -i "s~\"rpc-whitelist-enabled\".*~\"rpc-whitelist-enabled\": false,~" "$HOME"/.config/transmission-daemon/settings.json
/etc/init.d/transmission-daemon start > /dev/null
echo "
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:$PATH

# On weekdays at 5:30pm stop downloads
30 17 * * 1-5 transmission-remote --downlimit 0 --uplimit 0

# Everyday at 1:00am start downloads
00 01 * * * transmission-remote --no-downlimit --no-uplimit

# On weekends at 8:00am stop downloads
00 08 * * 0,6 transmission-remote --downlimit 0 --uplimit 0

# On weekends at 1:00pm start downloads
00 13 * * 0,6 transmission-remote --no-downlimit --no-uplimit

# On weekends at 5:00pm stop downloads
00 17 * * 0,6 transmission-remote --downlimit 0 --uplimit 0
" > /tmp/crontab
sudo mv -f /tmp/crontab /var/spool/cron/crontabs/root
sudo update-rc.d "transmission-daemon" defaults > /dev/null

echo "Adding dance/joy pad support" 
sudo modprobe xpad
sudo modprobe analog
sudo modprobe joydev

echo "
joydev
analog
joydev
" | sudo tee --append /etc/modules > /dev/null

