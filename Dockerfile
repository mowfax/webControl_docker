FROM ubuntu:16.04

MAINTAINER mowfax

EXPOSE 443/tcp 34290-34299/udp

ENV PORT_PREFIX=3419 \
    ADMINUSER=admin \
    ADMINPASS=password

RUN apt-get update -y && apt-get install -y curl
RUN curl -s https://raw.githubusercontent.com/3RaGaming/Web_Control/master/install.sh > /install.sh
RUN chmod +x /install.sh
RUN /install.sh --silent

RUN apt-get autoremove -y

COPY sudoers /etc/sudoers
RUN adduser www-data sudo

RUN mv /etc/php/7.0/apache2/php.ini /etc/php/7.0/apache2/php_org.ini
RUN sed -e 's:upload_max_filesize = 2M:upload_max_filesize = 100M:' \
        -e 's:post_max_size = 8M:post_max_size = 100M:' /etc/php/7.0/apache2/php_org.ini > /etc/php/7.0/apache2/php.ini

COPY ./docker-entrypoint.sh /

ENTRYPOINT ["/bin/bash"]
CMD ["/docker-entrypoint.sh"]
