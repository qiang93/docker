#!/bin/bash
ln -sf /dev/stdout /var/log/nginx/access.log
ln -sf /dev/stderr /var/log/nginx/error.log
chown -R www.www /var/web
find /var/web/www -type d -exec chmod 750 {} \;
find /var/web/www -not -type d -exec chmod 640 {} \;
/usr/local/openresty/nginx/sbin/nginx -g "daemon off;"
