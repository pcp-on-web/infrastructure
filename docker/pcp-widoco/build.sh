#!/bin/bash
echo "Generiereung der Dokumentation des Vokabulars des PCP-on-Web-Projektes"
echo "---"

set -e # Stop on error
cd /root/

echo " "
echo "[1] Generate Keys"
if [[ -e "/root/.ssh/id_workbench.pub" ]]; then
		echo "Key exists."    
else
		# SSH Key erzeugen
		ssh-keygen -q -N "" -t ed25519 -C "workbench@pcp-on-web.de" -f ~/.ssh/id_workbench
		echo -e "Host github.com    Hostname github.com\n    IdentityFile=~/.ssh/id_workbench" > ~/.ssh/config
fi
rm ~/.ssh/known_hosts || true
ssh-keyscan github.com >> ~/.ssh/known_hosts
echo " "
echo "--- public key ---"
cat /root/.ssh/id_workbench.pub
echo "--- public key ---"
echo " "

echo " "
echo "[2] Clonen des Repository"
# GIT konfigurieren
git config --global user.name "pcp-on-web workbench"
git config --global user.email "workbench@pcp-on-web.de"

rm -r ontology || true
git clone git@github.com:pcp-on-web/ontology.git

echo " "
echo "[3] Syntax-check"
rapper -i turtle -c ./ontology/index.rdf 

echo " "
echo "[4] Generieren der Doku"
java -jar widoco-1.4.21-jar-with-dependencies_JDK-17.jar -ontFile ontology/index.rdf -outFolder ontology/html/ -getOntologyMetadata -oops -rewriteAll -lang en-de -webVowl 

echo " "
echo "[5] Weitere Anpassungen"
cp ./ontology/html/index-en.html ./ontology/html/index.html 
cp ./ontology/sections/*.html ./ontology/html/sections/
sed -i 's/\&uuml\;berblick/\&Uuml\;berblick/g' ./ontology/html/sections/overview-de.html
echo "<?php shell_exec(\"cd /var/www/data/; git pull;\");header(\"HTTP/1.1 303 See Other\");header(\"Location: .\"); ?>" > ./ontology/html/update.php

echo " "
echo "[6] Commit und Push der Doku"
cd ontology
git add *
git commit -m "generated"
git push
cd ..

echo " "
echo "[Ende]"


