FROM php:7.3.6-fpm

LABEL maintainer="Vincent Letourneau <vincent@nanoninja.com>"

RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y \
    g++ \
    libbz2-dev \
    libc-client-dev \
    libcurl4-gnutls-dev \
    libedit-dev \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libkrb5-dev \
    libldap2-dev \
    libmagickwand-dev \
    libmcrypt-dev \
    libmemcached-dev \
    libpq-dev \
    libsqlite3-dev \
    libssl-dev \
    libreadline-dev \
    libxslt1-dev \
    libzip-dev \
    memcached \
    wget \
    unzip \
    zlib1g-dev \
    && docker-php-ext-configure gd \
    --with-freetype-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ \
    --with-png-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install -j$(nproc) imap \
    && docker-php-ext-configure intl \
    && docker-php-ext-install -j$(nproc) intl \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install ldap \
    && docker-php-ext-install -j$(nproc) \
    bcmath \
    bz2 \
    calendar \
    exif \
    gettext \
    mysqli \
    opcache \
    pdo_mysql \
    pdo_pgsql \
    pgsql \
    soap \
    sockets \
    xmlrpc \
    xsl \
    && docker-php-ext-configure zip --with-libzip \
    && docker-php-ext-install zip \
    && pecl install xdebug && docker-php-ext-enable xdebug \
    && pecl install memcached && docker-php-ext-enable memcached \
    && pecl install mongodb && docker-php-ext-enable mongodb \
    && pecl install redis && docker-php-ext-enable redis \
    && cd `pwd`/opt/screw-plus && phpize && ./configure && make  \
    && /bin/cp `pwd`/opt/screw-plus/modules/php_screw_plus.so `php-config --extension-dir`/screw_plus.so \
    && docker-php-ext-enable screw_plus   \
    && CURDIR=`pwd` && cd ${CURDIR}/opt/libfastcommon/ &&  ./make.sh && ./make.sh install  \
    && cd ${CURDIR}/opt/fastdfs  && ./make.sh && ./make.sh install  \
    && cd ${CURDIR}/opt/fastdfs/php_client/ && phpize && ./configure  && make \
    && /bin/cp `pwd`/opt/fastdfs/php_client/modules/fastdfs_client.so `php-config --extension-dir`/fastdfs.so  \
    && docker-php-ext-enable fastdfs  \
    && yes '' | pecl install imagick && docker-php-ext-enable imagick \
    && docker-php-source delete \
    && apt-get remove -y g++ wget \
    && apt-get autoremove --purge -y && apt-get autoclean -y && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* /var/tmp/*  

