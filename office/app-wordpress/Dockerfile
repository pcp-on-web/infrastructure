FROM php:7.0-apache
MAINTAINER Thomas Riechert <thomas.riechert@htwk-leipzig.de>

# upgrade
RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install git

# Install GD
RUN apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng12-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd

RUN docker-php-ext-install mbstring mysqli pdo pdo_mysql zip

RUN apt-get install -y wget unzip

RUN rm -rf /var/lib/apt/lists/* 

WORKDIR /var/www/

EXPOSE 80

COPY startup.sh /usr/local/bin/
RUN echo "\napache2-foreground" >> /usr/local/bin/startup.sh
RUN chmod a+x /usr/local/bin/startup.sh

CMD ["startup.sh"]

