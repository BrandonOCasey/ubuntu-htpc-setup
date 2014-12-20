SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/home/blondebeard/Binaries
MAILTO=""

# Source configuration file

# Set default log level 
if [ -z "$cron_log_level" ]; then
	cron_log_level=4
fi

# all output to STDOUT
exec 2>&1

# On weekdays at 7:30am set alternate download speed
30 07 * * 1-5 half_speed.sh | logger -p "${cron_log_level}.info" -t 'half_speed'

# On Weekdays at 8:30am start downloads
30 08 * * 1-5 full_speed.sh | logger -p "${cron_log_level}.info" -t 'full_speed' 

# On weekdays at 5:30pm set alternate download speed
30 17 * * 1-5 half_speed.sh | logger -p "${cron_log_level}.info" -t 'half_speed'

# Everyday at 1:00am start downloads
00 01 * * *   full_speed.sh | logger -p "${cron_log_level}.info" -t 'full_speed'

# On weekends at 8:30am set alternate download speed downloads
30 08 * * 0,6 half_speed.sh | logger -p "${cron_log_level}.info" -t 'half_speed'

# On weekends at 1:00pm start downloads
00 13 * * 0,6 full_speed.sh | logger -p "${cron_log_level}.info" -t 'full_speed'

# On weekends at 5:00pm set alternate download speed downloads
00 17 * * 0,6 half_speed.sh | logger -p "${cron_log_level}.info" -t 'half_speed'

# Clear Finished downloads on the hour
00 * * * *    swab_decks.sh | logger -p "${cron_log_level}.info" -t 'swab_decks'
