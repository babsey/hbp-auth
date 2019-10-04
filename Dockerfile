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

ENV SERVER_NAME=localhost
ENV OIDC_CLIENT_ID="1234567890"
ENV OIDC_CLIENT_SECRET="1234567890"
ENV OIDC_REDIRECT_URI="http://localhost/redirect_uri"
ENV OIDC_CRYPTO_PASSPHRASE="I should be a random password. Please set me."
ENV BACKEND_URL="http://10.0.0.1"

COPY config/00-hbp-auth.conf /etc/apache2/sites-enabled/
# COPY config/ports.conf /etc/apache2/

EXPOSE 80

RUN mkdir /var/lock/apache2 /var/run/apache2
CMD . /etc/apache2/envvars && apache2 -DFOREGROUND
