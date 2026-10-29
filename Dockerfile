FROM php:8.4.27-apache@sha256:be1326658a7d36dba6be79a71212d6ff9c5f854335b8ba77d714da1852c1b2ea
ARG DEBIAN_FRONTEND=noninteractive
ARG WONDERCMS_VERSION=3.7.0
ARG WONDERCMS_SHA256=f1c61e7dbaaf927e33b4b1aa8c14a7cf9b513a231ad6d65b82a44e8190f74785
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
# WONDERCMS_VERSION is a tag (checked against WONDERCMS_SHA256) or, with
# WONDERCMS_SHA256 set empty, a branch; a branch archive moves, so it has no checksum
RUN set -eux; \
    archive="https://github.com/WonderCMS/wondercms/archive/refs"; \
    if curl -fsSL -o wondercms.tar.gz "${archive}/tags/${WONDERCMS_VERSION}.tar.gz"; then \
        echo "${WONDERCMS_SHA256}  wondercms.tar.gz" | sha256sum -c -; \
    elif [ -z "${WONDERCMS_SHA256}" ]; then \
        curl -fsSL -o wondercms.tar.gz "${archive}/heads/${WONDERCMS_VERSION}.tar.gz"; \
    else \
        echo "WonderCMS tag ${WONDERCMS_VERSION} not found; set WONDERCMS_SHA256 empty to build a branch" >&2; \
        exit 1; \
    fi; \
    tar xzf wondercms.tar.gz --strip-components=1; \
    rm wondercms.tar.gz; \
    mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"; \
    a2enmod rewrite; \
    chown -R www-data:www-data .
EXPOSE 80
