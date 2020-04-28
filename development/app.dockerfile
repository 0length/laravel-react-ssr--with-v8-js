FROM php:7.2-fpm

RUN echo pwd: `pwd` && echo ls: `ls`

COPY composer.lock /var/www/

COPY composer.json /var/www/

COPY database /var/www/database

WORKDIR /var/www

RUN apt-get update && apt-get -y install git && apt-get -y install zip build-essential python libglib2.0-dev libv8-dev g++ cpp

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('sha384', 'composer-setup.php') === 'e0012edf3e80b6978849f5eff0d4b4e4c79ff1609dd1e613307e16318854d24ae64f26d17af3ef0bf7cfb710ca74755a') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"\
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && php composer.phar install --no-dev --no-scripts \
    && rm composer.phar

COPY . /var/www


RUN  apt-get update -y && apt-get install -y libmcrypt-dev \
        libmagickwand-dev --no-install-recommends \
        && pecl install mcrypt-1.0.2 \
        && docker-php-ext-install pdo_mysql \
        && docker-php-ext-enable mcrypt

RUN add-apt-repository -y ppa:pinepain/libv8-6.1 && apt-get install -y libv8-6.1 libv8-6.1-dev \
        && cd /tmp \
        && git clone https://github.com/phpv8/v8js.git \
        && cd v8js \
        && phpize \
        && ./configure --with-v8js=/opt/v8 LDFLAGS="-lstdc++" \
        && make \
        && make test \
        && sudo make install \
        && docker-php-ext-enable v8js

RUN mv .env.prod .env
RUN php artisan key:generate