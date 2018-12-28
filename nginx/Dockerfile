FROM centos:7.6.1810 AS build-env
MAINTAINER huqiang:2018/4/18
ENV NGINX_VERSION 1.13.6.2
RUN useradd -M www -s /sbin/nologin \
	    && rpm --import /etc/pki/rpm-gpg/RPM* \
	    && yum -y install wget \
	    && mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup \
	    && wget -P /etc/yum.repos.d/ http://mirrors.163.com/.help/CentOS7-Base-163.repo \
	    && yum clean all \
	    && yum makecache \
	    && yum -y install openssl-devel pcre-devel zlib-devel gcc-c++ make perl \
	    && wget -P /tmp/ https://openresty.org/download/openresty-${NGINX_VERSION}.tar.gz \
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

FROM centos:7.6.1810
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN useradd -M www -s /sbin/nologin && mkdir -p /var/web/www && mkdir -p /var/log/nginx && mkdir -p /usr/local/openresty/nginx/conf/vhosts

COPY --from=build-env  /usr/local/openresty /usr/local/openresty

COPY ./conf/nginx.conf /usr/local/openresty/nginx/conf

WORKDIR /usr/local/openresty/nginx

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 80 443
