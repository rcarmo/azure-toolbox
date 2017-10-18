FROM rcarmo/azure-toolbox
MAINTAINER rcarmo
ENV DEBIAN_FRONTEND noninteractive

# Java 9
RUN apt-get update \
 && apt-get dist-upgrade -y \
 && apt-get install -y openjdk-9-jdk-headless \
 && rm -rf /var/lib/apt/lists/*

# Leiningen
RUN wget -O /usr/local/bin/lein https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein \
 && chmod +x /usr/local/bin/lein

# Labels
ARG VCS_REF
ARG BUILD_DATE
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/rcarmo/azure-toolbox"
