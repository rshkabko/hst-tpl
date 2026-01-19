#=========================================================================#
# Default Web Domain Template                                             #
# DO NOT MODIFY THIS FILE! CHANGES WILL BE LOST WHEN REBUILDING DOMAINS   #
# https://hestiacp.com/docs/server-administration/web-templates.html      #
#=========================================================================#

# HTTP vhost: do not serve content here — enforce HTTPS and canonical host.
server {
    listen      %ip%:%web_port%;
    server_name %domain_idn% %alias_idn%;

    # For Lets Encrypt
    include %home%/%user%/conf/web/%domain%/nginx.ssl.conf_*;

    # 301 to HTTPS + canonical host (non-www). 
    # If you prefer www — see note below.
    return 301 https://%domain_idn%$request_uri;
}