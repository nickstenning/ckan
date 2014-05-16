FROM phusion/baseimage:0.9.10
MAINTAINER Open Knowledge Foundation

# Disable SSH
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

ENV HOME /root
ENV CKANHOME /usr/lib/ckan/default

# Install required packages
RUN apt-get -q -y update
RUN DEBIAN_FRONTEND=noninteractive apt-get -q -y install \
        python-minimal \
        python-dev \
        python-virtualenv \
        libpq-dev \
        libxml2-dev \
        libxslt1-dev \
        build-essential \
        git

# Install CKAN
RUN virtualenv $CKANHOME
ADD requirements.txt $CKANHOME/src/ckan/
ADD dev-requirements.txt $CKANHOME/src/ckan/
RUN $CKANHOME/bin/pip install -r $CKANHOME/src/ckan/requirements.txt
RUN $CKANHOME/bin/pip install -r $CKANHOME/src/ckan/dev-requirements.txt
ADD . $CKANHOME/src/ckan/
RUN $CKANHOME/bin/pip install -e $CKANHOME/src/ckan/
RUN mkdir -p /etc/ckan/default
RUN ln -s $CKANHOME/src/ckan/who.ini /etc/ckan/default/who.ini

# Configure runit
ADD ./ckan/config/svc /etc/service
CMD ["/sbin/my_init"]

VOLUME ["/data"]
EXPOSE 5000

RUN apt-get purge -q -y build-essential git
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
