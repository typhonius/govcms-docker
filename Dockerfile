FROM php:5.6-apache

ENV COMPOSER_PROCESS_TIMEOUT 900

RUN a2enmod rewrite

RUN apt-get update && apt-get install -y \
  libpng12-dev \
  libjpeg-dev \
  libpq-dev \
  libbz2-dev \
  unzip \
  git-core \
  telnet \
  mysql-client \
  && rm -rf /var/lib/apt/lists/* \
  && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
  && docker-php-ext-install bz2 gd mbstring pcntl pdo_mysql zip

RUN git clone https://github.com/govCMS/govCMS.git /var/www/govcms

WORKDIR /var/www/govcms
RUN mkdir -p /var/www/govcms/docroot
ADD ./build.properties build/phing/build.properties
RUN rmdir /var/www/html/ && ln -sfn /var/www/govcms/docroot /var/www/html

RUN bash -c "curl -sS 'https://getcomposer.org/installer' | php -- --install-dir=/usr/local/bin --filename=composer"
RUN chmod a+x /usr/local/bin/composer
RUN /usr/local/bin/composer install --prefer-dist --working-dir=build
RUN build/bin/phing -f build/phing/build.xml make:local

# Allow the settings.php file and files directory to be created.
RUN cp /var/www/govcms/docroot/sites/default/default.settings.php /var/www/govcms/docroot/sites/default/settings.php
RUN chmod -R a+w /var/www/govcms/docroot/sites/default
