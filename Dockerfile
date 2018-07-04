FROM ubuntu:17.10

LABEL maintainer="Daniel Baptista <danielbpdias@gmail.com>"

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Update the apt-get and installs curl
RUN apt-get update \
  && apt-get install -y curl

# Update node version on apt-get
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

# Run simulated install to check latest package versions in repository
#RUN apt-cache policy \
#   python3 \
#   python3-pip \
#   python3-setuptools \
#   nodejs \
#   build-essential \
#   libzmq3-dev && false

# Installs node.js, python, pip and setup tools
RUN apt-get install -y \
    python3=3.6.3-0ubuntu2 \
    python3-pip=9.0.1-2 \
    python3-setuptools=36.2.7-2 \
    nodejs=10.5.0-1nodesource1 \
    build-essential=12.4ubuntu1 \
    libzmq3-dev=4.2.1-4ubuntu1 \
    git=1:2.14.1-1ubuntu4.1 \
    libtinfo-dev=6.0+20160625-1ubuntu1 \
    libcairo2-dev=1.14.10-1ubuntu1 \
    libpango1.0-dev=1.40.12-1 \
    libmagic-dev=1:5.32-1ubuntu0.1 \
    libblas-dev=3.7.1-3ubuntu2 \
    liblapack-dev=3.7.1-3ubuntu2 \ 
    && rm -rf /var/lib/apt/lists/*

# Setup python language
ENV LANG en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8

# Upgrade pip
RUN pip3 install --upgrade pip

# Upgrade npm
RUN npm install npm@latest -g

# Install jupyter notebook
RUN pip3 install \
  jupyter==1.0.0 \
  jupyterlab==0.31.12

# Fix ipython kernel version
RUN ipython3 kernel install

# Install nodejs kernel
RUN npm config set user 0 \
 && npm config set unsafe-perm true \
 && npm install ijavascript -g \
 && npm install itypescript -g

# Install Haskell
ENV PATH=$PATH:/root/.local/bin
RUN apt-get update \
 && curl -sSL https://get.haskellstack.org/ | sh \
 && git clone https://github.com/gibiansky/IHaskell \
 && cd IHaskell \
 && pip3 install -r requirements.txt \
 && stack install gtk2hs-buildtools \
 && stack install --fast \
 && rm -rf /var/lib/apt/lists/*

RUN ijsinstall --hide-undefined --install=global \
  && its --ts-install=global \
  && ihaskell install --stack
