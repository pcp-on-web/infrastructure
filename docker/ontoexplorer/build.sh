#!/bin/bash
echo "Generiereung der der HTML Seiten für den Ontoexplorer"
echo "---"

set -e # Stop on error

echo " "
echo "[1] Clonen der Anwendung aus dem Repository"
rm -r ontoexplorer || true
git clone https://github.com/pcp-on-web/ontoexplorer.git

echo " "
echo "[2] Bauen der Anwendung"
cd ontoexplorer
npm ci
npm run build
npm run lint

echo " "
echo "[3] Verschieben der Anwendung"
rm -r /data/*
mv dist /data/html

echo " "
echo "[Ende]"


