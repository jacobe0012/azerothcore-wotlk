FROM php:8.2-apache

ARG WSR_VERSION=2.0.3

RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
        unzip \
        gettext-base \
        libgmp-dev \
        libpng-dev \
        libjpeg-dev \
        libfreetype6-dev \
        libicu-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j"$(nproc)" pdo_mysql gmp gd intl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

RUN git clone --depth 1 --branch ${WSR_VERSION} \
        https://github.com/masterking32/WoWSimpleRegistration.git /tmp/wsr \
    && cp -r /tmp/wsr/. /var/www/html/ \
    && rm -rf /tmp/wsr \
    && cd /var/www/html/application \
    && composer install --no-dev --optimize-autoloader --no-interaction \
    && chown -R www-data:www-data /var/www/html

COPY config.php.tpl /var/www/html/application/config/config.php.tpl
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 80
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["apache2-foreground"]
