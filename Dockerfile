FROM ubuntu:16.04

MAINTAINER mowfax

EXPOSE 443/tcp 34290-34299/udp

RUN apt-get update -y && apt-get install -y curl
RUN curl -s https://raw.githubusercontent.com/mowfax/Web_Control/patch-1/install.sh > /install.sh
RUN chmod +x /install.sh
RUN /install.sh --silent

RUN apt-get autoremove -y

COPY sudoers /etc/sudoers
RUN adduser www-data sudo

COPY ./docker-entrypoint.sh /

ENTRYPOINT ["/bin/bash"]
CMD ["/docker-entrypoint.sh"]
