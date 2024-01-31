FROM docker.io/php:8.3-apache
MAINTAINER Thomas Riechert <thomas.riechert@htwk-leipzig.de>

# upgrade
RUN apt-get update && apt-get -y upgrade

# Install GD
RUN apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev libonig-dev libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd


RUN docker-php-ext-install mysqli pdo pdo_mysql zip 
RUN php -i

RUN apt-get install -y libimage-exiftool-perl raptor2-utils tree vim

RUN rm -rf /var/lib/apt/lists/* 

# PHP-Konfiguration ändern
RUN echo "upload_max_filesize = 100M" > /usr/local/etc/php/conf.d/uploads.ini \
    && echo "post_max_size = 100M" >> /usr/local/etc/php/conf.d/uploads.ini
    
RUN a2enmod rewrite

WORKDIR /var/www/

EXPOSE 80:443

CMD ["apache2-foreground"]

