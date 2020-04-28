# Using Debian-based image because v8js (php)
# See also https://hub.docker.com/r/gytist/php-fpm-v8js/dockerfile
FROM php:7.3-fpm

# Do not use latest here! See
# see available versions here: https://omahaproxy.appspot.com/
ARG V8_VERSION=7.5.288.30
# path to chromium tools (python scripts etc)
# ENV PATH /tmp/depot_tools:$PATH

# See https://github.com/phpv8/v8js/issues/397 for flags
RUN apt-get update  \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        git subversion make g++ python2.7 curl  wget bzip2 xz-utils pkg-config  \
    && ln -s /usr/bin/python2.7 /usr/bin/python  \
    \
    && git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git /tmp/depot_tools \
    && export PATH="$PATH:/tmp/depot_tools"  \
    \
    && cd /usr/local/src \
    && fetch v8 \
    && cd v8 \
    && git checkout ${V8_VERSION} \
    && gclient sync \
    \
    &&  cd /usr/local/src/v8 \
    && tools/dev/v8gen.py -vv x64.release -- is_component_build=true use_custom_libcxx=false \
    && ninja -C out.gn/x64.release/ && \
    \
    mkdir -p /usr/local/lib && \
    cp out.gn/x64.release/lib*.so out.gn/x64.release/*_blob.bin out.gn/x64.release/icudtl.dat /usr/local/lib && \
    cp -R include/* /usr/local/include/ \
    \
    && git clone https://github.com/phpv8/v8js.git /usr/local/src/v8js \
    && cd /usr/local/src/v8js \
    && phpize \
    && ./configure --with-v8js=/usr/loca/lib/v8 \
    && export NO_INTERACTION=1 \
    && make all -j4 \
    && make test install \
    \
    && echo extension=v8js.so > /usr/local/etc/php/conf.d/v8js.ini \
    \
    && cd /tmp \
    && rm -rf /tmp/depot_tools /usr/local/src/v8 /usr/local/src/v8js \
    && apt-get remove -y git subversion make g++ python2.7 wget bzip2 xz-utils pkg-config \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

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

RUN mv .env.prod .env
RUN php artisan key:generate