#!/bin/bash

cd /root/
mkdir data/git/
chmod a+rwx /data
mkdir .ssh

echo $REPOSITORY								# URL to the Repository maybe .git or .zip
																# Example: https://github.com/pcp-on-web/ontology.git	
								 								# Example: https://codeload.github.com/pcp-on-web/ontology/zip/refs/heads/master
echo "${KEYFILE:=id_workbench}"	# Name of keyfile

if [[ -e "/root/.ssh/$KEYFILE.pub" ]]; then
		echo "Key exists."    
else
		# SSH Key erzeugen
		ssh-keygen -q -N "" -t ed25519 -C "workbench@pcp-on-web.de" -f ~/.ssh/$KEYFILE
		echo -e "Host github.com\n    Hostname github.com\n    IdentityFile=~/.ssh/$KEYFILE" > ~/.ssh/config
fi

rm ~/.ssh/known_hosts
ssh-keyscan github.com >> ~/.ssh/known_hosts
echo " "
echo "--- public key ---"
cat "/root/.ssh/$KEYFILE.pub"
echo "--- public key ---"
echo " "


# GIT konfigurieren
git config --global user.name "pcp-on-web workbench"
git config --global user.email "workbench@pcp-on-web.de"


if [[ -n "$REPOSITORY" ]]; then

	if [ -z "$(ls -A /data/git/)" ]; then
	  cd /data/git/
	  git clone $REPOSITORY repo
	else
		cd /data/git/repo
		git pull
	fi
fi
chmod a+rwx /data

