#使用方法:
#构建镜像：docker build -t xxxx .
FROM centos:7.6.1810 AS build-env
MAINTAINER huqiang:2018/4/19
ENV PHP_VERSION 7.1.18
ENV NGINX_VERSION 1.13.6.2
ENV PATH /usr/local/php7/bin:$PATH
RUN useradd -M www -s /sbin/nologin \
            && rpm --import /etc/pki/rpm-gpg/RPM* \
            && yum -y install wget epel-release \
            && yum install -y gcc-c++ pcre-devel zlib-devel make perl curl-devel libjpeg-devel libpng-devel freetype-devel libxml2-devel libcurl-devel openssl-devel libmcrypt-devel bison file re2c autoconf ImageMagick-devel \
            && wget -P /tmp/ http://am1.php.net/distributions/php-$PHP_VERSION.tar.gz \
            && tar xzf /tmp/php-$PHP_VERSION.tar.gz -C /tmp/

RUN wget -P /tmp/ https://openresty.org/download/openresty-${NGINX_VERSION}.tar.gz \
	    && tar xzf /tmp/openresty-${NGINX_VERSION}.tar.gz -C /tmp/

RUN cd /tmp/openresty-$NGINX_VERSION && \
	    ./configure --prefix=/usr/local/openresty \
            --error-log-path=/var/log/nginx/error.log  \
            --http-log-path=/var/log/nginx/access.log  \
	    --with-file-aio \
	    --with-threads \
	    --user=www \
	    --group=www \
	    --with-http_stub_status_module \
	    --with-http_gzip_static_module \
	    --with-http_ssl_module \
	    --with-http_realip_module \
	    --with-http_v2_module \
&& make -j`grep processor /proc/cpuinfo | wc -l` && make install

RUN cd /tmp/php-$PHP_VERSION && \
            ./configure \
            --prefix=/usr/local/php7 \
            --with-config-file-path=/usr/local/php7/etc \
            --enable-fpm \
            --with-fpm-user=www \
            --with-fpm-group=www \
            --with-mysqli=mysqlnd \
            --with-pdo-mysql=mysqlnd \
            --with-iconv-dir \
            --with-freetype-dir \
            --with-jpeg-dir \
            --with-png-dir \
            --with-zlib \
            --with-libxml-dir \
            --enable-xml \
            --disable-rpath \
            --enable-bcmath \
            --enable-shmop \
            --enable-sysvsem \
            --enable-inline-optimization \
            --enable-exif \
            --with-curl \
            --enable-mbregex \
            --enable-mbstring \
            --with-mcrypt \
            --with-gd \
            --enable-gd-native-ttf \
            --with-openssl \
            --with-mhash \
            --enable-pcntl \
            --enable-sockets \
            --with-xmlrpc \
            --enable-zip \
            --enable-soap \
            --with-gettext \
            --enable-opcache \
            && make -j`grep processor /proc/cpuinfo | wc -l` && make install \
            && mv php.ini-development /usr/local/php7/etc/php.ini \
            && wget -P /tmp/ https://github.com/longxinH/xhprof/archive/v1.0.tar.gz \
            && tar xzf /tmp/v1.0.tar.gz -C /tmp/ \
            && cd /tmp/xhprof-1.0/extension \
            && /usr/local/php7/bin/phpize \
            && ./configure --with-php-config=/usr/local/php7/bin/php-config --enable-xhprof \
            && make && make install \
            && pecl install redis swoole-1.9.22 imagick mongodb-1.3.1 \
            && echo "extension=redis.so" >> /usr/local/php7/etc/php.ini \
            && echo "extension=mongodb.so" >> /usr/local/php7/etc/php.ini \
            && echo "extension=swoole.so" >> /usr/local/php7/etc/php.ini \
            && echo "extension=imagick.so" >> /usr/local/php7/etc/php.ini \
            && echo "extension=xhprof.so" >> /usr/local/php7/etc/php.ini \
            && echo "zend_extension=opcache.so" >> /usr/local/php7/etc/php.ini \
            && sed -i "s#;date.timezone =#date.timezone = "Asia/Shanghai"#g" /usr/local/php7/etc/php.ini \
            && sed -i "s#memory_limit = 128M#memory_limit = 512M#g" /usr/local/php7/etc/php.ini \
            && sed -i "s#upload_max_filesize = 2M#upload_max_filesize = 100M#g" /usr/local/php7/etc/php.ini \
            && sed -i "s#max_file_uploads = 20#max_file_uploads = 500#g" /usr/local/php7/etc/php.ini \
            && sed -i "s#post_max_size = 8M#post_max_size = 150M#g" /usr/local/php7/etc/php.ini \
            && sed -i "s#;opcache.enable=1#opcache.enable=1#g" /usr/local/php7/etc/php.ini \
            && sed -i "s#;opcache.memory_consumption=128#opcache.memory_consumption=512#g" /usr/local/php7/etc/php.ini \
            && sed -i "s#;opcache.interned_strings_buffer=8#opcache.interned_strings_buffer=8#g" /usr/local/php7/etc/php.ini \
            && sed -i "s#;opcache.max_accelerated_files=10000#opcache.max_accelerated_files=4000#g" /usr/local/php7/etc/php.ini \
            && sed -i "s#;opcache.fast_shutdown=0#opcache.fast_shutdown=1#g" /usr/local/php7/etc/php.ini \
            && sed -i "s#;opcache.huge_code_pages=1#opcache.huge_code_pages=1#g" /usr/local/php7/etc/php.ini \
            && sed -i "s#;opcache.validate_timestamps=1#opcache.validate_timestamps=1#g" /usr/local/php7/etc/php.ini 


FROM centos:7.6.1810
ENV PATH /usr/local/php7/bin:$PATH
ENV PARAMS ""
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN useradd -M www -s /sbin/nologin && mkdir -p /var/web/www && mkdir -p /var/log/nginx && mkdir -p /usr/local/openresty/nginx/conf/vhosts
RUN curl -O https://bootstrap.pypa.io/get-pip.py && python get-pip.py && pip install awscli && rm -rf /root/get-pip.py /root/.cache

COPY --from=build-env  /usr/local/openresty /usr/local/openresty

COPY ./conf/nginx.conf /usr/local/openresty/nginx/conf

COPY --from=build-env  /usr/lib64 /usr/lib64
COPY --from=build-env  /usr/bin /usr/bin
COPY --from=build-env  /usr/include /usr/include
COPY --from=build-env  /usr/local/php7 /usr/local/php7

COPY ./conf/php-fpm.conf /usr/local/php7/etc/php-fpm.conf

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 9000 80 443

