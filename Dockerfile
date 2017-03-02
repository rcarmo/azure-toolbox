FROM rcarmo/desktop-chrome:tiger
MAINTAINER rcarmo
ENV DEBIAN_FRONTEND noninteractive

# Runtimes
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y \
      apt-transport-https \
      firefox \
      libssl-dev \
      libnotify4 \
      libffi-dev \
      python-pip \
      unzip \
 && rm -rf /var/lib/apt/lists/*

# Azure CLI 2.0 (Az)
RUN pip install --upgrade pip pycparser \
 && pip install azure-cli \
 && ln -s /usr/local/bin/az.completion.sh /etc/bash_completion.d/az

# Visual Studio Code (and workaround for running inside VNC)
RUN wget https://go.microsoft.com/fwlink/?LinkID=760868 -O /tmp/vscode.deb \
 && dpkg -i /tmp/vscode.deb \
 && mkdir -p /opt/patches/lib \
 && cp /usr/lib/x86_64-linux-gnu/libxcb.so.1 /opt/patches/lib \
 && sed -i 's/BIG-REQUESTS/_IG-REQUESTS/' /opt/patches/lib/libxcb.so.1 \
 && sed -i 's/Exec=/Exec=env LD_LIBRARY_PATH\\=\/opt\/patches\/lib /' /usr/share/applications/code.desktop \
 && rm /tmp/vscode.deb

# Add overlay files 
ADD rootfs /

# For Windows users who don't know how to tunnel in via SSH
EXPOSE 5901

# Labels
ARG VCS_REF
ARG BUILD_DATE
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/rcarmo/azure-toolbox"
