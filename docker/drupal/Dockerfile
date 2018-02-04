# build image (composer image)
FROM php:7.1-apache as build

MAINTAINER Karl Fritsche <github@attrib.org>

RUN apt-get update && \
    apt-get install -yq --no-install-recommends git zlib1g-dev openssh-client && \
    docker-php-ext-install -j$(nproc) zip && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    curl -o installer.php https://getcomposer.org/installer && \
    php installer.php --filename=composer && \
    mv composer /usr/local/bin/composer && \
    useradd -ms /bin/bash php --uid 2000 && \
    chown 2000:2000 /var/www/html

ADD --chown=2000:2000 ./data/.ssh/id_rsa* /home/php/.ssh/

USER 2000:2000
RUN echo "Host *\n\tStrictHostKeyChecking no\n" > ~/.ssh/config

# Only re-run composer update if something changed
ADD --chown=2000:2000 ./data/drupal/composer.* /var/www/html/

WORKDIR /var/www/html

ARG composer_arg
RUN composer install --no-progress --ignore-platform-reqs --optimize-autoloader $composer_arg

ADD --chown=2000:2000 data/drupal /var/www/html

# real image (step 1/image)
FROM php:7.1-apache

# all configs should be copied to the container (config has correct path structure)
COPY ./docker/drupal/configs /

# Prepare envoirment
RUN bash /usr/local/bin/prepare_env.sh

# this is overridden, the parent image just starts "apache-foreground"
ENTRYPOINT ["docker-entrypoint.sh"]

WORKDIR /var/www/html

COPY --from=build /var/www/html /var/www/html
