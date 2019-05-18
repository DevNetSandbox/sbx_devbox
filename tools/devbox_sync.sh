#! /bin/bash

# This bash script is downloaded and ran on the DevNet DevBox automatially
# whenever a terminal starts up.  It's purpose is to all the DevBox to get
# updates and changes to maintain the latest requirements and tools.

# The "SYNC_VERSION" is used to determine whether any pod updates are needed
SYNC_VERSION=8

# Step 1. Check to see if script needs to run.  If not, exit.
CURRENT_VERSION=$(<~/sync_version)
echo "Current SYNC_VERSION ${CURRENT_VERSION}"

if [ "$CURRENT_VERSION" -eq "$SYNC_VERSION" ];
  then
    echo "Pod up to date."
    exit
fi

echo "Pod configuration needs updates."

# Step 2. Run Updates
# Enter needed update commands below

# Update virlutils to latest (stable) version
sudo pip install virlutils==0.8.8

# somebody will still want telnet
sudo yum install -y telnet

# install docker-compose
sudo pip install docker-compose

# disable firewalld
sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo systemctl restart docker

mkdir -p ~/.ssh
cat > ~/.ssh/config <<EOF
Host 172.20.*.*
  StrictHostKeyChecking no
  UserKnownHostsFile=/dev/null
Host 10.10.20.*
   StrictHostKeyChecking no
   UserKnownHostsFile=/dev/null
Host 172.16.30.*
   StrictHostKeyChecking no
   UserKnownHostsFile=/dev/null
EOF

# Step 3. Update Pod Version
echo "Updating SYNC_VERSION to ${SYNC_VERSION}"
echo ${SYNC_VERSION} > ~/sync_version
