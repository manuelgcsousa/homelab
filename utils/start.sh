#!/bin/bash

# cronjob
# @reboot sleep 30 && sh /home/pi/homelab/utils/start.sh >> /home/pi/.mylogs/cronlogs 2>&1

MOUNT_POINT='/mnt/ssd1/ENTRYPOINT/usr/remote/jottacloud'
COMPOSE_FILE="$HOME/homelab/src/docker-compose.yml"

echo "[$(date '+%Y-%m-%d %H:%M:%S')]"

echo 'Mounting jottacloud...'
if mountpoint -q "$MOUNT_POINT"; then
  echo 'Mount point is already in use.'
else
  rclone mount jottacloud-crypt: "$MOUNT_POINT" --daemon
  if [ $? -eq 0 ]; then
    echo 'Mounted successfully.'
  else
    echo 'Failed to mount.'
    exit 1
  fi
fi

echo "Starting containers..."
docker compose --file $COMPOSE_FILE up --detach
