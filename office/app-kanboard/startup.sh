#!/bin/bash

GITREPO=https://github.com/kanboard/kanboard.git
BASEDIR=kanboard

if [ ! $BASEDIR == "html" ]; then
    mkdir html
    cd html
fi

git clone $GITREPO $BASEDIR
if [ $? -eq 0 ]; then
   cd $BASEDIR
   composer install --no-dev
   cp config.default.php config.php
   sed -i s/__DIR__.DIRECTORY_SEPARATOR/DIRECTORY_SEPARATOR/g config.php
   sed -i s/\'DB_DRIVER\',\ \'sqlite\'/\'DB_DRIVER\',\ \'mysql\'/g config.php
   sed -i s/\'DB_USERNAME\',\ \'root\'/\'DB_USERNAME\',\ \'$MYSQL_USER\'/g config.php
   sed -i s/\'DB_PASSWORD\',\ \'\'/\'DB_PASSWORD\',\ \'$MYSQL_PASSWORD\'/g config.php
   sed -i s/\'DB_HOSTNAME\',\ \'localhost\'/\'DB_HOSTNAME\',\ \'$MYSQL_LINK\'/g config.php
   sed -i s/\'DB_NAME\',\ \'kanboard\'/\'DB_NAME\',\ \'$MYSQL_DATABASE\'/g config.php
   chmod a+rw -R plugins
   chmod a+rw -R /data
else
   echo "$BASEDIR exists"
   cd $BASEDIR
   #git pull
fi

