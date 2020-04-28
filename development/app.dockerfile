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

RUN apt-get update -y && apt-get install -y build-essential curl git python libglib2.0-dev \
        # && cd /tmp \
        # && git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git \
        # && export PATH=`pwd`/depot_tools:"$PATH" \
        # && fetch v8\
        # && cd v8 \
        # && git checkout 6.4.388.18 \
        # && gclient sync \
        # && tools/dev/v8gen.py -vv x64.release -- is_component_build=true use_custom_libcxx=false \
        # && ln -s /usr/lib/libtinfo.so.6 /usr/lib/libtinfo.so.5 \
        # && ninja -C out.gn/x64.release/ \
        # && mkdir -p /opt/v8/{lib,include} \
        # && cp out.gn/x64.release/lib*.so out.gn/x64.release/*_blob.bin out.gn/x64.release/icudtl.dat /opt/v8/lib/ \
        # && cp -R include/* /opt/v8/include/ \
        # && apt-get install -y patchelf \
        # && for A in /opt/v8/lib/*.so; do sudo patchelf --set-rpath '$ORIGIN' $A; done \
        && pecl install v8js-2.1.1 \
        && docker-php-ext-enable v8js

RUN mv .env.prod .env
RUN php artisan key:generate