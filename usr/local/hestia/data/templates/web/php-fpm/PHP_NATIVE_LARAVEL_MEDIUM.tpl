; origin-src: deb/php-fpm/multiphp.tpl
;#=========================================================================#
;# Default Web Domain Template                                             #
;# DO NOT MODIFY THIS FILE! CHANGES WILL BE LOST WHEN REBUILDING DOMAINS   #
;# https://hestiacp.com/docs/server-administration/web-templates.html      #
;#=========================================================================#

[%domain%]
listen = /run/php/php%backend_version%-fpm-%domain%.sock
listen.owner = %user%
listen.group = www-data
listen.mode = 0660

user = %user%
group = %user%

pm = dynamic
pm.max_children = 192        ; ~19–23 ГБ під PHP (≈100–120MB/воркер), решта ОС/БД/кеш
pm.start_servers = 16
pm.min_spare_servers = 16
pm.max_spare_servers = 64
pm.max_requests = 5000
pm.process_idle_timeout = 10s
pm.status_path = /status
request_slowlog_timeout = 5s
slowlog = /home/%user%/web/%domain%/logs/php-slow.log

php_admin_value[upload_tmp_dir] = /home/%user%/tmp
php_admin_value[session.save_path] = /home/%user%/tmp
php_admin_value[sendmail_path] = /usr/sbin/sendmail -t -i -f admin@%domain%
php_admin_value[upload_max_filesize] = 128M
php_admin_value[post_max_size] = 128M
php_admin_value[memory_limit] = 256M
php_admin_value[max_execution_time] = 60
php_admin_value[max_input_vars] = 10000
php_admin_value[opcache.memory_consumption] = 256
php_admin_value[opcache.interned_strings_buffer] = 32
php_admin_value[opcache.max_accelerated_files] = 150000
php_admin_value[opcache.revalidate_freq] = 60

env[PATH] = /usr/local/bin:/usr/bin:/bin
env[TMP] = /home/%user%/tmp
env[TMPDIR] = /home/%user%/tmp
env[TEMP] = /home/%user%/tmp
