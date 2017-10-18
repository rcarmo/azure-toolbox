FROM rcarmo/desktop-chrome:tiger
MAINTAINER rcarmo
ENV DEBIAN_FRONTEND noninteractive

# Runtimes (& re-patching of Chrome launcher)
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y \
      firefox \
      libssl-dev \
      libnotify4 \
      libffi-dev \
      python-pip \
      unzip \
 && sed -i 's/google-chrome-stable/google-chrome-stable --no-sandbox /g' /usr/share/applications/google-chrome.desktop \
 && rm -rf /var/lib/apt/lists/*

# Azure CLI 2.0 (Az)
RUN pip install --no-cache-dir --upgrade pip pycparser \
 && pip install --no-cache-dir --upgrade azure-cli \
 && ln -s /usr/local/bin/az.completion.sh /etc/bash_completion.d/az

# Visual Studio Code (and workaround for running inside VNC)
RUN wget https://go.microsoft.com/fwlink/?LinkID=760868 -O /tmp/vscode.deb \
 && dpkg -i /tmp/vscode.deb \
 && mkdir -p /opt/patches/lib \
 && cp /usr/lib/x86_64-linux-gnu/libxcb.so.1 /opt/patches/lib \
 && sed -i 's/BIG-REQUESTS/_IG-REQUESTS/' /opt/patches/lib/libxcb.so.1 \
 && sed -i 's/Exec=/Exec=env LD_LIBRARY_PATH\\=\/opt\/patches\/lib /' /usr/share/applications/code.desktop \
 && rm /tmp/vscode.deb

# Docker CLI
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - \
 && add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable" \
 && apt-get update \
 && apt-get install -y docker-ce \
 && usermod -a -G docker user \
 && rm -rf /var/lib/apt/lists/*

# Docker Compose
RUN curl -L "https://github.com/docker/compose/releases/download/1.11.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
  && chmod +x /usr/local/bin/docker-compose \
  && curl -L https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose

# Go 1.8.3
RUN wget -O /tmp/go.tgz https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz \
  && tar -C /usr/local -xzf /tmp/go.tgz \
  && rm -f /tmp/go.tgz

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
