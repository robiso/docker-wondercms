FROM php:7.4.9-apache-buster
ENV DEBIAN_FRONTEND noninteractive
ARG WONDERCMS_VERSION=3.4.2
WORKDIR /var/www/html
RUN apt-get update && \
    apt-get -yqu dist-upgrade && \
    apt-get -yq install git zip libzip-dev && \
    apt-get -yq autoremove && \
    apt-get clean && \
    rm -rf /var/lib/{apt,dpkg,cache,log}
RUN git clone --depth 1 https://github.com/WonderCMS/wondercms.git -b $WONDERCMS_VERSION . && \
    mv $PHP_INI_DIR/php.ini-development $PHP_INI_DIR/php.ini && \
    docker-php-ext-configure zip && \
    docker-php-ext-install -j$(nproc) zip && \
    a2enmod rewrite && \
    chown -R www-data.www-data .
EXPOSE 80
