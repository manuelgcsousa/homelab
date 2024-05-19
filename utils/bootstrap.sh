#!/bin/bash

MOUNTING_POINT='/mnt/ssd1'
DRIVE_UUID='...'

current_dir=$(pwd)

# update system
sudo apt-get update && sudo apt-get upgrade

# install utils
sudo apt-get -y install \
  ca-certificates \
  curl \
  dhcpcd \
  git \
  gnupg \
  jq \
  tmux \
  tree \
  vim

# create mounting point for the external drive \
# change owner of the folder \
# add external drive to fstab file \
# mount all filesystems in fstab file
sudo mkdir $MOUNTING_POINT
sudo chown $(id -un):$(id -gn) $MOUNTING_POINT
sudo echo "UUID=$DRIVE_UUID $MOUNTING_POINT exfat defaults,uid=$(id -u),gid=$(id -g),umask=0002 0" > /etc/fstab
sudo mount -a

# setup Docker repo
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# add the repo to apt sources
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# install Docker pkgs
sudo apt-get update && sudo apt-get install \
  docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# add $USER to docker group
sudo groupadd docker 2>/dev/null
sudo usermod -aG docker $USER

# setup static IPv4 address
cat <<EOF >> /etc/dhcpcd.conf
interface eth0
static_routers=$(ip route | grep default | grep eth0 | awk '{print $3}')
static domain_name_server=$(grep 'nameserver' /etc/resolv.conf | awk '{print $2}')
static ip_address=$(ip -4 addr show eth0 | awk '/inet / {print $2}')
EOF

# install pivpn (setup manually)
curl -L https://install.pivpn.io | bash

# manually build arm/v8 version of plex
git clone https://github.com/plexinc/pms-docker.git /tmp/pms-docker
cd /tmp/pms-docker \
  && sudo docker buildx build -t plexinc/pms-docker:latest -f Dockerfile.arm64 --platform linux/arm/v8 . \
  && cd $current_dir

# reboot
sudo reboot
