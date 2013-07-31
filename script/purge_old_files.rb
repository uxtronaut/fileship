# This script is invoked via cron. It deletes all files that are older than the number of days set
# in app.yml. For example if days_until_purge is set to 7, then all files older than 7 days will be
# obliterated when this script is run. 

UserFile.purge_old_files
UserFile.purge_old_logs