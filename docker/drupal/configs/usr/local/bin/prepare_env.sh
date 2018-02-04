#!/usr/bin/env bash
# stop on any error
set -e

apt-get update
apt-get install -yq --no-install-recommends \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libpq-dev \
    libicu-dev \
    libtidy-dev \
    mysql-client \
    freetype*

# PHP extensions
pecl install redis
pecl install igbinary
docker-php-ext-enable redis igbinary
docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr --with-png-dir=/usr
docker-php-ext-install -j$(nproc) gd iconv json intl opcache pdo pdo_mysql mbstring tidy zip

# composer
curl -o installer.php https://getcomposer.org/installer
php installer.php --filename=composer
mv composer /usr/local/bin/composer

# Create wwwadmin user
adduser --disabled-password --gecos "Deployment" --uid 2000 wwwadmin
adduser wwwadmin www-data
adduser www-data wwwadmin

# fake sendmail
mkdir -p /home/wwwadmin/sendmail
chmod 777 /home/wwwadmin/sendmail
ln -s /usr/local/bin/sendmail.sh /usr/sbin/sendmail

# cleanup
apt-mark manual libjpeg62-turbo libpq5 libtidy-0.99-0 libicu52
apt-get purge -y --auto-remove man libfreetype6-dev libjpeg62-turbo-dev libmcrypt-dev libpng-dev libicu-dev libtidy-dev libpq-dev
rm -rf /var/lib/apt/lists/* /var/lib/cache/*
