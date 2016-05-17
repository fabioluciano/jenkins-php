FROM alpine:latest

MAINTAINER Fábio Luciano <fabio.goisl@ctis.com.br>

ENV JENKINS_HOME /opt/jenkins/

RUN apk add --update openjdk8 ttf-dejavu \
    php-common php-iconv php-json php-gd php-curl php-xml php-pgsql \
    php-imap php-cgi fcgi php-pdo php-pdo_pgsql php-soap php-xmlrpc \
    php-posix php-mcrypt php-gettext php-ldap php-ctype php-dom \
    php-phar php-openssl php-xsl
RUN rm -rf /var/cache/apk/*

# PHP Related
COPY config/pecl /usr/bin/pecl
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer global require phpmetrics/phpmetrics
RUN composer global require squizlabs/php_codesniffer
RUN composer global require phpunit/phpunit
RUN composer global require sebastian/phpcpd
RUN composer global require sebastian/phpdcd
RUN composer global require pdepend/pdepend
RUN composer global require phploc/phploc
RUN composer global require sebastian/hhvm-wrapper
RUN composer global require theseer/phpdox
RUN composer global require producer/producer

COPY config/definepath.sh /etc/profile.d/definepath.sh

RUN mkdir -p $JENKINS_HOME
RUN adduser -D -H -s /bin/sh jenkins
RUN chown -R jenkins:jenkins $JENKINS_HOME

ADD http://mirrors.jenkins-ci.org/war/latest/jenkins.war $JENKINS_HOME/jenkins.war
RUN chmod 644 $JENKINS_HOME/jenkins.war

RUN mkdir -p /opt/oracle/instantclient

WORKDIR /opt/oracle/instantclient
COPY packages/instantclient-basic-linux.x64-12.1.0.2.0.zip .
COPY packages/instantclient-sdk-linux.x64-12.1.0.2.0.zip .
RUN unzip packages/instantclient-basic-linux.x64-12.1.0.2.0.zip
RUN unzip packages/instantclient-sdk-linux.x64-12.1.0.2.0.zip

EXPOSE 8080
