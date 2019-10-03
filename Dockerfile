FROM ubuntu:18.04
LABEL maintainer="Sebastian Spreizer <spreizer@web.de>"

RUN apt-get update && apt-get install -y \
    apache2 \
    libapache2-mod-auth-openidc && \
    rm -rf /var/lib/apt/lists/*

# enable needed modules
RUN a2enmod auth_openidc && \
    a2enmod ssl && \
    a2enmod rewrite && \
    a2enmod proxy && \
    a2enmod proxy_http && \
    a2enmod proxy_wstunnel

# disable default virtual host
RUN a2dissite 000-default

# send logs to stderr and stdout
# see : https://serverfault.com/questions/711168/writing-apache2-logs-to-stdout-stderr
#
RUN ln -sf /proc/self/fd/1 /var/log/apache2/other_vhosts_access.log && \
    ln -sf /proc/self/fd/2 /var/log/apache2/error.log

COPY 00-hbp-auth.conf /etc/apache2/sites-enabled/
COPY OIDC_vars.sh .

RUN . ./OIDC_vars.sh

EXPOSE 80

RUN mkdir /var/lock/apache2 /var/run/apache2
CMD . /OIDC_vars.sh && . /etc/apache2/envvars && apache2 -DFOREGROUND
