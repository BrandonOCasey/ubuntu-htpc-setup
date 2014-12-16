SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/home/blondebeard/Binaries
log=/tmp/transmission.log

# On weekdays at 7:30am set alternate download speed
30 07 * * 1-5 alternate_download_speed.sh 2>&1 >> "$log"

# On Weekdays at 8:30am start downloads
30 08 * * 1-5 start_download.sh.sh 2>&1 >> "$log"

# On weekdays at 5:30pm set alternate download speed
30 17 * * 1-5 alternate_download_speed.sh 2>&1 >> "$log"

# Everyday at 1:00am start downloads
00 01 * * *   start_download.sh.sh 2>&1 >> "$log"

# On weekends at 8:30am set alternate download speed downloads
30 08 * * 0,6 alternate_download_speed.sh 2>&1 >> "$log"

# On weekends at 1:00pm start downloads
00 13 * * 0,6 start_download.sh.sh 2>&1 >> "$log"

# On weekends at 5:00pm set alternate download speed downloads
00 17 * * 0,6 alternate_download_speed.sh 2>&1 >> "$log"


# Clear Finished downloads on the hour
00 * * * * clear_transmission_downloads.sh 2>&1 >> "$log"
