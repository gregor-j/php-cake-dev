ARG PHP_VERSION
FROM php:${PHP_VERSION}-fpm

ARG XDEBUG_VERSION=3.3.2

RUN set -ex; \
    apt-get update; \
    apt-get install -y \
      libicu-dev; \
    docker-php-ext-install -j$(nproc) \
      intl \
      pdo_mysql; \
    pecl channel-update pecl.php.net; \
    pecl install xdebug-${XDEBUG_VERSION}; \
    docker-php-ext-enable xdebug;

ADD xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
COPY entrypoint.sh /usr/local/bin/petition-entrypoint.sh

RUN chmod +x /usr/local/bin/petition-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/petition-entrypoint.sh"]
CMD ["php-fpm"]
