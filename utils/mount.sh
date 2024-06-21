#!/bin/bash

MOUNT_POINT='/mnt/ssd1/ENTRYPOINT/usr/remote/jottacloud'

if mountpoint -q "$MOUNT_POINT"; then
    echo 'Mount point is already in use.'
else
    echo 'Mounting jottacloud...'
    rclone mount jottacloud-crypt: "$MOUNT_POINT" --daemon
    if [ $? -eq 0 ]; then
        echo 'Mounted successfully.'
    else
        echo 'Failed to mount.'
    fi
fi
