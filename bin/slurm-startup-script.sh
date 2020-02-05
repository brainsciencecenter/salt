#!/bin/bash

function getMetadata {
	curl -s -H "Metadata-Flavor:Google" "http://metadata.google.internal/computeMetadata/v1/instance/$1"
}


if [ ! -d /etc/salt ]
then
	mkdir /etc/salt
	MinionID=$(getMetadata attributes/MinionID)

	echo "$MinionID" > /etc/salt/minion_id

	curl -L https://bootstrap.saltstack.com | sudo sh -s -- git develop

	sed -i '/^#master:.*$/s//master: salt.cfn.upenn.edu/' /etc/salt/minion
	sed -i '/^#hash_type.*$:/s//hash_type: sha256/' /etc/salt/minion
	getMetadata attributes/minion-pem > /etc/salt/pki/minion/minion.pem
	getMetadata attributes/minion-pub > /etc/salt/pki/minion/minion.pub
	service salt-minion restart

	salt-call state.apply software/files
fi


