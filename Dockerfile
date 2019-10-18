FROM alpine:3.7

MAINTAINER darron1217 <darron1217@gmail.com>

ENV php_conf /etc/php7/php.ini

RUN echo @v3.8 http://nl.alpinelinux.org/alpine/v3.8/community >> /etc/apk/repositories && \
    echo @v3.8 http://nl.alpinelinux.org/alpine/v3.8/main >> /etc/apk/repositories && \
    apk update && \
    apk add --no-cache bash \
    openssh-client \
    wget \
    supervisor \
    curl \
    tzdata \
    php7-pdo \
    php7-pdo_mysql \
    php7-mysqlnd \
    php7-mysqli \
    php7-mcrypt \
    php7-mbstring \
    php7-ctype \
    php7-zlib \
    php7-gd \
    php7-exif \
    php7-intl \
    php7-sqlite3 \
    php7-pdo_pgsql \
    php7-pgsql \
    php7-xml \
    php7-xmlwriter \
    php7-xsl \
    php7-curl \
    php7-openssl \
    php7-iconv \
    php7-json \
    php7-phar \
    php7-soap \
    php7-dom \
    php7-zip \
    php7-session \
    php7-fileinfo \
    php7-tokenizer \
    php7-simplexml \
    php7-imagick \
    openssl-dev \
    ca-certificates \
    dialog \
    nodejs \
    nodejs-npm \
    ttf-droid \
    ttf-droid-nonlatin \
    imagemagick \
    chromium@v3.8 && \
    mkdir -p /var/www/app && \
    mkdir -p /var/log/supervisor

# Skip downloading Chromium when installing puppeteer. We'll use the installed package.
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true

ADD conf/supervisord.conf /etc/supervisord.conf

# nginx site conf
RUN rm -Rf /var/www/* && \
mkdir /var/www/html/

# tweak php config
RUN sed -i \
        -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" \
        -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" \
        -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" \
        -e "s/variables_order = \"GPCS\"/variables_order = \"EGPCS\"/g" \
        ${php_conf} && \
    ln -s /etc/php7/php.ini /etc/php7/conf.d/php.ini && \
    find /etc/php7/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \;

# Add Scripts
ADD scripts/start.sh /start.sh

# Add user nginx
RUN addgroup -S nginx && \
    adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx

CMD ["/start.sh"]
