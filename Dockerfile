FROM node:0.12.7-wheezy

MAINTAINER Patrick Wolleb

# Install node tools
RUN npm install -g grunt-cli && \
    npm install -g bower

# phantomjs
ENV PHANTOM_VERSION=1.9.7
RUN wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-$PHANTOM_VERSION-linux-x86_64.tar.bz2 && \
    tar xfj phantomjs-$PHANTOM_VERSION-linux-x86_64.tar.bz2 && \
    cp phantomjs-$PHANTOM_VERSION-linux-x86_64/bin/phantomjs /usr/local/bin


