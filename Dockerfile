FROM ubuntu
MAINTAINER Nathaniel Talbott <nathaniel@spreedly.com>

RUN echo "debconf debconf/frontend select Teletype" | debconf-set-selections

RUN apt-get update

# Install packages
RUN apt-get install -y \
#   for downloading Riak
    wget

# Download and install Riak
RUN wget -nv http://s3.amazonaws.com/downloads.basho.com/riak/1.2/1.2.1/ubuntu/precise/riak_1.2.1-1_amd64.deb
RUN dpkg -i riak_1.2.1-1_amd64.deb

# Put our custom Riak config in place
ADD app.config-1.2 /etc/riak/app.config
RUN echo "ulimit -n 4096" >> /etc/default/riak
RUN mkdir -p /tmp/riak

# Expose Riak HTTP & Protocol Buffers
EXPOSE 8087 8098

CMD ["/usr/sbin/riak", "console"]
