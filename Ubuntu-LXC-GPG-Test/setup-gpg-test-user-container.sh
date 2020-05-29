#!/bin/bash

read -p "Container-Name : ", choice

if [[ $EUID -ne 0  ]]; then
		echo "PLEASE RUN SCRIPT AS ROOT"
		exit 99
fi

echo "Starting Container..."
lxc-start $choice
echo "Updating bashrc...."
lxc-attach -n $choice -- echo "export PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin" >> ~/.bashrc
echo "Restarting Container...."
lxc-stop -n $choice
lxc-start -n $choice
echo "Installing Requirements"
lxc-attach -n $choice -- apt-get install gpg vsftpd openssh-server
echo "Setting up gpg"
lxc-attach -n $choice -- echo "use-agent\npinentry-mode loopback" > ~/.gnupg/gpg.conf
lxc-attach -n $choice -- echo "allow-loopback pinentry" > ~/.gnupg/gpg-agent.conf
lxc-attach -n $choice -- echo RELOADAGENT | gpg-connect-agent
echo "setting up vsftpd"
lxc-attach -n $choice -- systemctl enable vsftpd
lxc-attach -n $choice -- echo "write_enable=YES" >> /etc/vsftpd.conf
lxc-attach -n $choice -- systemctl restart vsftpd
echo "Done"
