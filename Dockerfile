FROM cgr.dev/chainguard/wolfi-base

ARG ADMINERNEO_VERSION=4.14

RUN apk add --no-cache \
    php-8.3 \
    php-8.3-curl \
    php-8.3-pdo \
    php-8.3-pdo_mysql \
    php-8.3-pdo_sqlite \
    php-8.3-pdo_pgsql \
    php-8.3-mysqlnd \
    php-8.3-pdo_dblib \
    php-8.3-opcache

COPY rootfs /

RUN	set -x \
    &&	apk add --no-cache git curl \
    &&	curl -fsSL "https://github.com/adminerneo/adminerneo/releases/download/v$ADMINERNEO_VERSION/adminer-$ADMINERNEO_VERSION.php" -o /var/www/html/adminer.php \
    &&	git clone --recurse-submodules=designs --depth 1 --shallow-submodules --branch "v$ADMINERNEO_VERSION" https://github.com/adminerneo/adminerneo.git /tmp/adminer \
    &&	cp -r /tmp/adminer/designs/ /tmp/adminer/plugins/ /var/www/html \
    &&	rm -rf /tmp/adminer/ \
    &&  chown -R nonroot:nonroot /var/www/html \
    &&	apk del git

ENTRYPOINT [ "/entrypoint.sh" ]
USER nonroot
EXPOSE 8080
ENV PHP_CLI_SERVER_WORKERS=4
CMD	[ "php", "-S", "[::]:8080", "-t", "/var/www/html" ]
HEALTHCHECK CMD [ "curl", "-f", "http://localhost:8080" ]
