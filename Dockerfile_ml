FROM rcarmo/azure-toolbox:java
MAINTAINER rcarmo
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
 && apt-get install -y openmpi-bin \
 && rm -rf /var/lib/apt/lists/*

# Anaconda 4.4.0 (Python 3.6)
USER user
RUN wget -q https://repo.continuum.io/archive/Anaconda3-4.4.0-Linux-x86_64.sh -O /tmp/anaconda.sh \
 && sudo -u user /bin/bash /tmp/anaconda.sh -p /home/user/.anaconda -b \
 && rm /tmp/anaconda.sh

# Enable it
ENV PATH /home/user/.anaconda/bin:$PATH

# Since we're installing a new Python runtime, reinstall azure-cli as well to avoid confusion
RUN pip install --no-cache-dir --ignore-installed --upgrade \
      pip \
      azure-cli \
      notebook \
      nbbrowserpdf \
      tensorflow \
      mxnet \
      https://cntk.ai/PythonWheel/CPU-Only/cntk-2.2-cp36-cp36m-linux_x86_64.whl \
      keras \
 && echo 'export PATH="/home/user/.anaconda/bin:$PATH"' >> /home/user/.bashrc \
 && conda install -y -c conda-forge jupyter_contrib_nbextensions

# Restore UID so that quickstart.sh works properly
USER root

# Labels
ARG VCS_REF
ARG BUILD_DATE
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/rcarmo/azure-toolbox"
