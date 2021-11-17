#!/bin/bash
# You will need information for the databases below.
echo "Stopping zabbix server, proxy and agent"
service zabbix-server stop
service zabbix-agent2 stop
#
#If upgrading Zabbix proxy, stop proxy too.
#service zabbix-proxy stop
#
#Make Backup Directory
echo "Making Backup Directory"
mkdir /opt/zabbix-backup/
#
#Change Directory to Backup directory
echo "Change Directory to Backup directory"
cd /opt/zabbix-backup/
#
# Backing up zabbix database
# We need the zabbixuser, zabbixdatabase and zabbix password.
# We can check the server configuratin file for these
# /etc/zabbix/zabbix_server.conf
DBUser=zabbix
DBName=zabbix
DBPassword=Cgg5p57Zzs
now="$(date +'%d.%m.%Y.%H:%M:%S')"
filename="db-backup_$now".sql
backupfolder="/opt/zabbix-backup/"
fullpathbackupfile="$backupfolder/$filename"
logfile="$backupfolder/"backup_log_"$(date +'%Y_%m')".log
echo "mysqldump started at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
mysqldump --no-tablespaces --user=$DBUser --password=$DBPassword $DBName > $fullpathbackupfile
echo "mysqldump finished at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
echo "remove backup 5 days old" >> "$logfile"
#
echo "Delete files older than 5 days"
#
#find $backupfolder=/* -mtime +5 -exec rm {} \;
echo "complete removing" >> "$logfile"
echo "database backup complete"
#
echo "Starting File Backups"
#
#Backup files
cp -R /etc/zabbix/ /opt/zabbix-backup/etc
cp /etc/apache2/conf-enabled/zabbix.conf /opt/zabbix-backup/
cp -R /usr/share/zabbix/ /opt/zabbix-backup/
cp -R /usr/share/doc/zabbix-* /opt/zabbix-backup/
#
#Update repository configuration package
#
#To proceed with the update your current repository package has to be uninstalled.
rm -Rf /etc/apt/sources.list.d/zabbix.list
#
#Then install the new repository configuration package.
#On Debian 11 run:
#
#
#CHANGE TO THE VERSION YOU ARE UPGRADING!
echo "Upgrading to Zabbix 6.0"
#

#Uncomment for  Zabbix verion 6
cd /root
wget https://repo.zabbix.com/zabbix/5.5/debian/pool/main/z/zabbix-release/zabbix-release_5.5-1+debian11_all.deb
dpkg -i zabbix-release_5.5-1+debian11_all.deb
#
#Comment out if going with Zabbix 6
#echo "Upgrading to Zabbix 5.4"
#wget https://repo.zabbix.com/zabbix/5.4/debian/pool/main/z/zabbix-release/zabbix-release_5.4-1+debian11_all.deb
#dpkg -i zabbix-release_5.4-1+debian11_all.deb
#
#Update  Sources
echo "Running Apt update"
apt-get update
#
Updating zabbix Components
echo "Upgrading Zabbix components"
apt-get install --only-upgrade zabbix-server-mysql zabbix-frontend-php zabbix-agent2
#
# Upgrading Frontend
echo "Upgrading the web frontend with Apache correctly"
apt-get install zabbix-apache-conf
#
#Add database password
#nano /etc/zabbix/zabbix_server.conf
echo "Update almost Finished!"
#Check Version
echo "Checking New Version"
zabbix_server --version
echo "POST INSTALLATION CONFIGURATION"
echo "*******************************"
echo " - Update the new zabbix server file at /etc/zabbix/zabbix_server.conf with the database password"
echo " - Start the updated Zabbix components with:"
echo " - service zabbix-server start"
echo " - service zabbix-agent2 start"

exit 0