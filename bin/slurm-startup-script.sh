#!/bin/bash

function getMetadata {
	curl -s -H "Metadata-Flavor:Google" "http://metadata.google.internal/computeMetadata/v1/instance/$1"
}

HostName=$(getMetadata MinionID)

if [ ! -d /etc/salt ]
then
	mkdir /etc/salt
	echo "$HostName" > /etc/salt/minion_id

        curl -L https://bootstrap.saltstack.com -o /tmp/install_salt.sh
        sudo sh /tmp/install_salt.sh git 

	sed -i '/^#master:.*$/s//master: salt.cfn.upenn.edu/' /etc/salt/minion
	sed -i '/^#hash_type.*$:/s//hash_type: sha256/' /etc/salt/minion
	getMetadata attributes/minion-pem > /etc/salt/pki/minion/minion.pem
	getMetadata attributes/minion-pub > /etc/salt/pki/minion/minion.pub
	service salt-minion restart

	salt-call state.apply software/files
fi


