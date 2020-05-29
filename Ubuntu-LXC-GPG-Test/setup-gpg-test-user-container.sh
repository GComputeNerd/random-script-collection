#!/bin/bash

read -p "Container-Name : ", choice

if [[ $EUID -ne 0  ]]; then
		echo "PLEASE RUN SCRIPT AS ROOT"
		exit 99
fi

echo "Starting Container & Temporary PATH fix..."
lxc-start $choice
lxc-attach -n $choice -- apt-get update
lxc-attach -n $choice -- apt-get install -y git

lxc-attach -n $choice -- git clone https://github.com/GComputeNerd/random-script-collection.git

lxc-attach -n $choice -- mv random-script-collection/Ubuntu-LXC-GPG-Test/write_to_files_gpg.sh .
lxc-attach -n $choice -- chmod +x write_to_files_gpg.sh

echo "Restarting Container...."
lxc-stop -n $choice
lxc-start -n $choice

echo "Installing Requirements"
lxc-attach -n $choice -- apt-get install -y gpg vsftpd openssh-server

echo "Setting up gpg"
lxc-attach -n $choice -- ./write_to_files_gpg.sh 2

echo "setting up vsftpd"
lxc-attach -n $choice -- systemctl enable vsftpd
lxc-attach -n $choice -- ./write_to_files_gpg.sh 3
lxc-attach -n $choice -- systemctl restart vsftpd

echo "Done"
