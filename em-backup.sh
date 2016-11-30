#!/bin/bash
# Author : ChristopherN - christophercois@me.com
# XenServer emergency backup script

# 1) Looks for SR with label "Snapshot"




for uuid in `xe vm-list |grep uuid |cut -f2 -d :`;do echo "$uuid -- $(xe vm-list |grep -A1 $uuid |grep name-label |cut -f2 -d :)";done

echo
echo "Please enter the UUID of a VM you want backed up...."
read emUUID

serial="$(date +%m%d%Y)"

echo
# Get Backups SR
# Makes things pretier, Like doing a cut -f2 -d :
function xe_param()
{
        PARAM=$1
        while read DATA; do
                LINE=$(echo $DATA | egrep "$PARAM")
                if [ $? -eq 0 ]; then
                        echo "$LINE" | awk 'BEGIN{FS=": "}{print $2}'
                fi
        done

}
backupSR="$(xe sr-list |grep -B1 XE-Storage_Two |grep uuid |xe_param)"
echo "$(date) -- Backup SR set to $backupSR - $(df -h |grep $backupSR |awk '{print $3}') FREE"

## Gets VM Name
vmName="$(xe vm-list |grep -A1 $emUUID|grep name-label |xe_param)"


echo
echo "$(date) -- Creating SNAPSHOT of $emUUID - $vmName"
SNAPSHOT_UUID=$(xe vm-snapshot vm="$vmName" new-name-label="$vmName-EM$serial")
echo
echo "$(date) -- Moving SNAPSHOT $SNAPSHOT_UUID to Backups SR"
xe snapshot-copy uuid=$SNAPSHOT_UUID sr-uuid=$backupSR new-name-description="Emergency Backup on $(date)" new-name-label="$vmName-EM$serial"
echo
echo "$(date) -- Removing Temp Backup of $vmName"
xe snapshot-uninstall uuid=$SNAPSHOT_UUID force=true
