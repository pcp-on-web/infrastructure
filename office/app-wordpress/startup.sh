#!/bin/bash

ZIPREPO=https://wordpress.org/latest.tar.gz

if [ ! $BASEDIR == "html" ]; then
    mkdir html
    cd html
fi

cd $BASEDIR
if [ $? -eq 0 ]; then
   echo "$BASEDIR exists"
else
   wget $ZIPREPO
   tar -xzf latest.tar.gz 
   rm latest.tar.gz 
   mv wordpress $BASEDIR
   cd $BASEDIR
   cp wp-config-sample.php wp-config.php
   sed -i s/\<?php/\<?php\ define\(\'FORCE_SSL_ADMIN\',true\)\;\ if\ \(strpos\(\$_SERVER[\'HTTP_X_FORWARDED_PROTO\'],\ \'https\'\)\ !==\ false\)\ \$_SERVER[\'HTTPS\']=\'on\'\;/g wp-config.php
   sed -i s/\'DB_NAME\',\ \'database_name_here\'/\'DB_NAME\',\ \'$WORDPRESS_DB_NAME\'/g wp-config.php
   sed -i s/\'DB_USER\',\ \'username_here\'/\'DB_USER\',\ \'$WORDPRESS_DB_USER\'/g wp-config.php
   sed -i s/\'DB_PASSWORD\',\ \'password_here\'/\'DB_PASSWORD\',\ \'$WORDPRESS_DB_PASSWORD\'/g wp-config.php
   sed -i s/\'DB_HOST\',\ \'localhost\'/\'DB_HOST\',\ \'$WORDPRESS_DB_HOST\'/g wp-config.php
   echo "define('FS_METHOD', 'direct');" >> wp-config.php
   touch .htaccess
   cd wp-content/plugins
   wget https://downloads.wordpress.org/plugin/easy-wp-smtp.zip
   unzip easy-wp-smtp.zip
   rm easy-wp-smtp.zip
   cd ../../
   chmod a+rw -R wp-content
   chmod a+rw wp-config.php
   chmod a+rw .htaccess
fi


