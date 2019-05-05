#!/bin/bash
if [[ "${PARAMS}" == "nginx" ]]; then
	ln -sf /dev/stdout /var/log/nginx/access.log
	ln -sf /dev/stderr /var/log/nginx/error.log
	chown -R www.www /var/web
	find /var/web/www -type d -exec chmod 750 {} \;
	find /var/web/www -not -type d -exec chmod 640 {} \;
	/usr/local/openresty/bin/openresty -g "daemon off;"

fi

if [[ "${PARAMS}" == "php" ]]; then
	chown -R www.www /var/web
	find /var/web/www -type d -exec chmod 750 {} \;
	find /var/web/www -not -type d -exec chmod 640 {} \;
	/usr/local/php7/sbin/php-fpm -y /usr/local/etc/php/php-fpm.conf
fi
exec "$@"
