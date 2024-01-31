#!/bin/bash

cd /root/
chmod a+rxx /data
mkdir .ssh

echo $REPOSITORY								# URL to the Repository maybe .git or .zip
																# Example: https://github.com/pcp-on-web/ontology.git	
								 								# Example: https://codeload.github.com/pcp-on-web/ontology/zip/refs/heads/master
echo "${REPOTYPE:=git}"					# zip or git
echo "${REPOPATH:=html}"				# Path for $BASEDIR on the Repository
echo "${BASEDIR:=html}"					# Publish on this directory on the webserver
echo "${KEYFILE:=id_workbench}"	# Name of keyfile
echo "$AFTERPULL"								# Bash script that will be run after data action
echo "$AFTERCOPY"								# Bash script that will be run after copy action

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

	if [[ $REPOTYPE == "git" ]]; then
		if [[ -e "/root/repo/" ]]; then
		  cd /root/repo/
			git pull
		else
			echo "HALLO"
		  git clone $REPOSITORY repo
		fi
	fi
	if [[ $REPOTYPE == "zip" ]]; then
    wget -O repo.zip $REPOSITORY
    unzip repo.zip -d repo
	fi
	if [[ $REPOTYPE == "index.php" ]]; then
		mkdir repo
		wget -O repo/index.php $REPOSITORY
	fi

	if [[ -n "$AFTERPULL" ]]; then
		bash -c "$AFTERPULL"
	fi
	if [ $BASEDIR == "repo" ]; then
		rm -r /data/repo/* 
		cp -r ~/repo$REPOPATH/* /data/repo
	else
		if [ $BASEDIR == "html" ]; then
			rm -r /data/html/*	
			cp -r ~/repo$REPOPATH/* /data/html
	
		else
		
			rm -r /data/html/*
			cd /data
			# $BASEDIR mit cut aufteilen
			IFS='/' read -ra parts <<< "$(echo "$BASEDIR" | cut -d'/' -f2-)"

			mkdir html
			cd html

			# Iterieren über die Teile des aufgeteilten Strings
			for ((i=0; i<${#parts[@]}; i++)); do
					current_part="${parts[i]}"
					echo "$current_part"
					# Überprüfe, ob das aktuelle Teil das letzte ist
					if [ $i -eq $(( ${#parts[@]} - 1 )) ]; then
						  cp  -r ~/repo$REPOPATH $current_part
						  echo "<?php header(\"HTTP/1.1 303 See Other\");header(\"Location: $current_part/\"); ?>" > index.php
					else
						  mkdir $current_part
						  echo "<?php header(\"HTTP/1.1 303 See Other\");header(\"Location: $current_part/\"); ?>" > index.php
						  chmod a+rx index.php 
						  cd $current_part
					fi
			done


			
		fi
	fi	
	if [[ -n "$AFTERCOPY" ]]; then
		bash -c "$AFTERCOPY"
	fi
	
fi


