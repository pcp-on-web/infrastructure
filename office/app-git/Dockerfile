FROM php:7.0-apache
MAINTAINER Thomas Riechert <thomas.riechert@htwk-leipzig.de>

# upgrade
RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install git

# Install ssmtp Mail Transfer Agent
RUN apt-get install -y ssmtp \
    && apt-get clean \
    && sed s/mailhub=mail/mailhub=smtp.server/g -i /etc/ssmtp/ssmtp.conf  \
    && echo "FromLineOverride=YES\n" >> /etc/ssmtp/ssmtp.conf \
    && cat /etc/ssmtp/ssmtp.conf \
    && echo 'sendmail_path = "/usr/sbin/ssmtp -t"' > /usr/local/etc/php/conf.d/mail.ini

RUN rm -rf /var/lib/apt/lists/* 

WORKDIR /var/www/
EXPOSE 80

COPY startup.sh /usr/local/bin/
RUN echo "\napache2-foreground" >> /usr/local/bin/startup.sh
RUN chmod a+x /usr/local/bin/startup.sh

CMD ["startup.sh"]

