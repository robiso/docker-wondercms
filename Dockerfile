FROM php:8.4.27-apache@sha256:be1326658a7d36dba6be79a71212d6ff9c5f854335b8ba77d714da1852c1b2ea
ARG DEBIAN_FRONTEND=noninteractive
ARG WONDERCMS_VERSION=3.6.0
ARG WONDERCMS_SHA256=2b6640f8ac9f915ff48f206179ec00ed2b04d7e452168ae1711ecaca34cea1ba
WORKDIR /var/www/html
# Build the PHP extensions, then keep only the runtime libraries they link to
RUN set -eux; \
    savedAptMark="$(apt-mark showmanual)"; \
    apt-get update; \
    apt-get -y upgrade; \
    apt-get -y install --no-install-recommends libzip-dev; \
    docker-php-ext-install -j"$(nproc)" zip; \
    apt-mark auto '.*' > /dev/null; \
    apt-mark manual $savedAptMark; \
    ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
        | awk '/=>/ { so = $(NF-1); if (index(so, "/usr/local/") == 1) { next }; gsub("^/(usr/)?", "", so); printf "*%s\n", so }' \
        | sort -u \
        | xargs -r dpkg-query --search \
        | cut -d: -f1 \
        | sort -u \
        | xargs -r apt-mark manual; \
    apt-get -y purge --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    rm -rf /var/lib/apt/lists/*
RUN set -eux; \
    curl -fsSL -o wondercms.tar.gz \
        "https://github.com/WonderCMS/wondercms/archive/refs/tags/${WONDERCMS_VERSION}.tar.gz"; \
    echo "${WONDERCMS_SHA256}  wondercms.tar.gz" | sha256sum -c -; \
    tar xzf wondercms.tar.gz --strip-components=1; \
    rm wondercms.tar.gz; \
    mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"; \
    a2enmod rewrite; \
    chown -R www-data:www-data .
EXPOSE 80
