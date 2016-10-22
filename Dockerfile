FROM rcarmo/desktop-chrome:tiger
MAINTAINER rcarmo
ENV DEBIAN_FRONTEND noninteractive
ARG VCS_REF
ARG BUILD_DATE
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/rcarmo/azure-toolbox"

# Runtimes
RUN \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y \
    firefox \
    libssl-dev \
    libnotify4 \
    libffi-dev \
    nodejs \
    npm \
    python-pip \
    unzip && \
  cd /usr/bin && ln -s nodejs node && \
  rm -rf /var/lib/apt/lists/*

# Azure CLI & Az
RUN \
  npm install -g azure-cli && \
  rm -rf /tmp/npm* && \
  pip install --upgrade pip pycparser && \
  pip install azure-cli 

# Visual Studio Code (and workaround for running inside VNC)
RUN \
  wget https://go.microsoft.com/fwlink/?LinkID=760868 -O /tmp/vscode.deb && \
  dpkg -i /tmp/vscode.deb && \
  mkdir -p /opt/patches/lib && \
  cp /usr/lib/x86_64-linux-gnu/libxcb.so.1 /opt/patches/lib && \
  sed -i 's/BIG-REQUESTS/_IG-REQUESTS/' /opt/patches/lib/libxcb.so.1 && \
  sed -i 's/Exec=/Exec=env LD_LIBRARY_PATH\\=\/opt\/patches\/lib /' /usr/share/applications/code.desktop && \
  rm /tmp/vscode.deb

# For Windows users who don't know how to tunnel in via SSH
EXPOSE 5901
