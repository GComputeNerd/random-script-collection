#!/bin/bash

if [[ $1 = '1' ]]; then
	echo 'export PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin' >> ~/.bashrc
elif [[ $1 = '2' ]]; then
	echo "use-agent" > ~/.gnupg/gpg.conf
	echo "pinentry-mode loopback" >> ~/.gnupg/gpg.conf
	echo "allow-loopback pinentry" > ~/.gnupg/gpg-agent.conf
elif [[ $1 = '3' ]]; then
	echo "write_enable=YES" >> /etc/vsftpd.conf
fi
