#!/bin/bash

read -p "Container-Name : ", choice

if [[ $EUID -ne 0  ]]; then
		echo "PLEASE RUN SCRIPT AS ROOT"
		exit 99
fi

echo "Starting Container & Temporary PATH fix..."
lxc-start $choice
export PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin
apt-get install -y curl

curl https://raw.githubusercontent.com/GComputeNerd/gist-collection-private/master/Ubuntu-LXC-GPG-Test/write_to_files_gpg.sh?token=AHFBBH4UPL7SK5BDQRRORJ262CQEQ > write_to_files_gpg.sh
chmod +x write_to_files_gpg.sh

echo "Updating bashrc...."
lxc-attach -n $choice -- ./write_to_files_gpg.sh 1

echo "Restarting Container...."
lxc-stop -n $choice
lxc-start -n $choice

echo "Installing Requirements"
lxc-attach -n $choice -- apt-get install gpg vsftpd openssh-server

echo "Setting up gpg"
lxc-attach -n $choice -- ./write_to_files_gpg.sh 2

echo "setting up vsftpd"
lxc-attach -n $choice -- systemctl enable vsftpd
lxc-attach -n $choice -- ./write_to_files_gpg.sh 3
lxc-attach -n $choice -- systemctl restart vsftpd

echo "Done"
