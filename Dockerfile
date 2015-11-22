FROM node:0.12.7-wheezy

MAINTAINER Patrick Wolleb



ENV PYTHON_VERSION 2.7.10
ENV PYTHON_PIP_VERSION 7.1.2
ENV PHANTOMJS_VERSION 1.9.7





###########################################################################
### INSTALL Python ## https://github.com/docker-library/python/blob/15798abb6cfb145344462a345db4b572227fb859/2.7/Dockerfile
###########################################################################

# remove several traces of debian python
RUN apt-get purge -y python.*

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

# gpg: key 18ADD4FF: public key "Benjamin Peterson <benjamin@python.org>" imported
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys C01E1CAD5EA2C4F0B8E3571504C367C218ADD4FF

RUN set -x \
  && mkdir -p /usr/src/python \
  && curl -SL "https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz" -o python.tar.xz \
  && curl -SL "https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz.asc" -o python.tar.xz.asc \
  && gpg --verify python.tar.xz.asc \
  && tar -xJC /usr/src/python --strip-components=1 -f python.tar.xz \
  && rm python.tar.xz* \
  && cd /usr/src/python \
  && ./configure --enable-shared --enable-unicode=ucs4 \
  && make -j$(nproc) \
  && make install \
  && ldconfig \
  && curl -SL 'https://bootstrap.pypa.io/get-pip.py' | python2 \
  && pip install --no-cache-dir --upgrade pip==$PYTHON_PIP_VERSION \
  && find /usr/local \
    \( -type d -a -name test -o -name tests \) \
    -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
    -exec rm -rf '{}' + \
  && rm -rf /usr/src/python

###########################################################################
### END INSTALL Python ####################################################
###########################################################################





###########################################################################
### INSTALL PhantomJS ## https://hub.docker.com/r/cmfatih/phantomjs/~/dockerfile/
###########################################################################

# Commands
RUN \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y vim git wget libfreetype6 libfontconfig bzip2 && \
  mkdir -p /srv/var && \
  wget -q --no-check-certificate -O /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 && \
  tar -xjf /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 -C /tmp && \
  rm -f /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 && \
  mv /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64/ /srv/var/phantomjs && \
  ln -s /srv/var/phantomjs/bin/phantomjs /usr/bin/phantomjs && \
  git clone https://github.com/n1k0/casperjs.git /srv/var/casperjs && \
  ln -s /srv/var/casperjs/bin/casperjs /usr/bin/casperjs && \
  apt-get autoremove -y && \
  apt-get clean all
ENV PHANTOMJS_BIN=/usr/bin/phantomjs

###########################################################################
### END INSTALL PhantomJS #################################################
###########################################################################






# Install node tools
RUN npm install -g grunt-cli && \
    npm install -g bower

# phantomjs
# ENV PHANTOM_VERSION=1.9.7
# RUN wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-$PHANTOM_VERSION-linux-x86_64.tar.bz2 && \
#     tar xfj phantomjs-$PHANTOM_VERSION-linux-x86_64.tar.bz2 && \
#     cp phantomjs-$PHANTOM_VERSION-linux-x86_64/bin/phantomjs /usr/local/bin && \
#     export PHANTOMJS_BIN=which phantomjs

# AWS EBS CLI
RUN pip install awsebcli





