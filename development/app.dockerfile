FROM php:7.2-fpm

RUN echo pwd: `pwd` && echo ls: `ls`

COPY composer.lock /var/www/

COPY composer.json /var/www/

COPY database /var/www/database

WORKDIR /var/www

RUN apt-get update && apt-get -y install git && apt-get -y install zip build-essential python libglib2.0-dev

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('sha384', 'composer-setup.php') === 'e0012edf3e80b6978849f5eff0d4b4e4c79ff1609dd1e613307e16318854d24ae64f26d17af3ef0bf7cfb710ca74755a') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"\
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && php composer.phar install --no-dev --no-scripts \
    && rm composer.phar

COPY . /var/www

# Install required dependencies
RUN cd /tmp \
        # Install depot_tools first (needed for source checkout)
        && git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git \
        && export PATH=`pwd`/depot_tools:"$PATH" \
        # Download v8
        && fetch v8 \
        && cd v8 \
        # (optional) If you'd like to build a certain version:
        && git checkout 5.6.326.12 \
        && gclient sync \
        # Setup GN
        && tools/dev/v8gen.py -vv x64.release \
        && echo is_component_build = true >> out.gn/x64.release/args.gn \
        # Build
        && ninja -C out.gn/x64.release/ \
        # Install to /opt/v8/
        && mkdir -p /opt/v8/{lib,include} \
        && cp out.gn/x64.release/lib*.so out.gn/x64.release/*_blob.bin /opt/v8/lib/ \
        && cp -R include/* /opt/v8/include/

RUN  apt-get update -y && cd /tmp \
        && git clone https://github.com/phpv8/v8js.git \
        && cd v8js \
        && phpize \
        && ./configure --with-v8js=/opt/v8 \
        && make && make test && make install \
        && echo 'extension=v8js.so' >> /etc/php/7.2/cli/conf.d/20-v8js.ini  \
        && php -i | grep v8js

RUN  apt-get update -y && apt-get install -y libmcrypt-dev \
        libmagickwand-dev --no-install-recommends \
        && pecl install mcrypt-1.0.2 \
        && docker-php-ext-install pdo_mysql \
        && docker-php-ext-enable mcrypt

RUN mv .env.prod .env
RUN php artisan key:generate