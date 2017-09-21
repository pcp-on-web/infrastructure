#!/bin/bash

#GITREPO=https://github.com/pcp-on-web/project-website.git
#BASEDIR=html

if [ ! $BASEDIR == "html" ]; then
    mkdir html
    cd html
fi

git clone $GITREPO $BASEDIR
if [ $? -eq 0 ]; then
   # to allow git pull
   chmod a+rw -R $BASEDIR
   cd $BASEDIR
else
   echo "$BASEDIR exists"
   chmod a+rw -R $BASEDIR
   cd $BASEDIR
   git pull
fi

