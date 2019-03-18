#
# dockerfile for datazoomer
#

FROM ubuntu:16.04

MAINTAINER Herb Lainchbury <herb@dynamic-solutions.com>

# install os packages
RUN apt-get update
RUN apt-get -y install \
    apache2 \
    git \
    vim \
    python-imaging \
    python-mysqldb \
    python-pip \
    libxml2-dev \
    libxslt1-dev \
    libffi-dev \
    libssl-dev \
    python-dev

# configure apache modules
RUN cd /etc/apache2/mods-enabled && ln -s ../mods-available/rewrite.load
RUN cd /etc/apache2/mods-enabled && ln -s ../mods-available/cgi.load

# install mariadb
ADD setup_mariadb.sh /tmp/setup_mariadb.sh
RUN /bin/bash /tmp/setup_mariadb.sh

# upload scripts
ADD setup.sh /tmp/setup.sh
ADD start.sh /tmp/start.sh

# run the final setup
RUN /bin/bash /tmp/setup.sh

# run the server
EXPOSE 80
CMD ["/bin/bash", "/tmp/start.sh"]

