#!/bin/bash
chown -R www.www /var/web
find /var/web/www -type d -exec chmod 750 {} \;
find /var/web/www -not -type d -exec chmod 640 {} \;

cat > /etc/supervisor/php-fpm.conf << 'EOF'
[program:php-fpm]
command=/usr/local/php7/sbin/php-fpm -y /usr/local/php7/etc/php-fpm.conf
autostart=true
autorestart=false
startsecs=0
redirect_stderr=true
stdout_logfile=/dev/stdout
stdout_logfile_maxbytes=0
EOF

/usr/bin/supervisord -c /etc/supervisord.conf
