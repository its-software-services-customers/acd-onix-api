FROM php:7.2-apache

##===== Begin build lib_wis_core_framework
WORKDIR /sources
COPY lib_wis_core_framework lib_wis_core_framework
RUN find .
WORKDIR /sources/lib_wis_core_framework
RUN php -d phar.readonly=0 onix_core_framework_build.php
RUN ls -lrt build
##===== End build lib_wis_core_framework

RUN a2enmod rewrite && a2enmod ssl

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libpq-dev \
        vim \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql pgsql 

RUN useradd apache2
RUN usermod -u 69690 apache2
RUN groupmod -g 69690 apache2

RUN mkdir -p /home/apache2
RUN chown apache2:apache2 /home/apache2

ENV APACHE_RUN_USER apache2
ENV APACHE_RUN_GROUP apache2

RUN echo ': ${PORT:=80}' >> /etc/apache2/envvars
RUN echo 'export PORT' >> /etc/apache2/envvars
COPY ports.conf /etc/apache2

#== Application setup here ===
RUN mkdir -p /wis/system/bin
RUN mkdir -p /wis/windows
RUN chown apache2 /wis/system /wis/system/bin /wis/windows
RUN chgrp apache2 /wis/system /wis/system/bin /wis/windows

#COPY lib_wis_core_framework/build/onix_core_framework.phar /wis/system/bin
#COPY lib_wis_erp_framework/build/onix_erp_framework.phar /wis/system/bin
#COPY app_onix/onix_server/scripts/* /wis/system/bin/

COPY alias.conf /tmp
RUN cat /tmp/alias.conf >> /etc/apache2/apache2.conf

#FROM gcr.io/its-artifact-commons/php-apache:7.2-1

#RUN mkdir -p /wis/system/bin
#RUN mkdir -p /wis/windows
#RUN chown apache2 /wis/system /wis/system/bin /wis/windows
#RUN chgrp apache2 /wis/system /wis/system/bin /wis/windows


 

