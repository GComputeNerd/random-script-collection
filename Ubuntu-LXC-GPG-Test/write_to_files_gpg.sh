#!/bin/bash

if [ '$1' -eq '1' ]; then
	echo 'export PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin' >> ~/.bashrc
elif [ '$1' -eq '2' ]; then
	echo "use-agent" > ~/.gnupg/gpg.conf
	echo "pinentry-mode loopback" >> ~/.gnupg/gpg.conf
	echo "allow-loopback pinentry" > ~/.gnupg/gpg-agent.conf
	echo RELOADAGENT | gpg-connect-agent
elif [ '$1' -eq '3' ]; then
	echo "write_enable=YES" >> /etc/vsftpd.conf
fi
