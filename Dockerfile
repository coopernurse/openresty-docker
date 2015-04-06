#
# Openresty docker image
#
# This docker contains openresty (nginx) compiled from source with useful optional modules installed.
#
# http://github.com/tenstartups/openresty-docker
#

FROM debian:jessie

MAINTAINER Marc Lennox <marc.lennox@gmail.com>

# Set environment.
ENV \
  DEBIAN_FRONTEND=noninteractive \
  TERM=xterm-color

# Install packages.
RUN apt-get update && apt-get -y install \
  build-essential \
  curl \
  libreadline-dev \
  libncurses5-dev \
  libpcre3-dev \
  libssl-dev \
  nano \
  perl \
  wget && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Compile openresty from source.
RUN \
  wget http://openresty.org/download/ngx_openresty-1.7.10.1.tar.gz && \
  tar -xzvf ngx_openresty-*.tar.gz && \
  rm -f ngx_openresty-*.tar.gz && \
  cd ngx_openresty-* && \
  ./configure --with-pcre-jit --with-ipv6 && \
  make && \
  make install && \
  make clean && \
  cd .. && \
  rm -rf ngx_openresty-*&& \
  ln -s /usr/local/openresty/nginx/sbin/nginx /usr/local/bin/nginx && \
  ldconfig

# Set the working directory.
WORKDIR /opt/openresty

# Add files to the container.
ADD . /opt/openresty

# Expose volumes.
VOLUME ["/etc/nginx"]

# Set the entrypoint script.
ENTRYPOINT ["./entrypoint"]

# Expose ports
EXPOSE 80 443

# Define the default command.
CMD ["nginx", "-c", "/etc/nginx/nginx.conf"]
