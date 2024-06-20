

## Copyright 2018-present Network Optix, Inc. Licensed under MPL 2.0: www.mozilla.org/MPL/2.0/

FROM ubuntu:20.04
LABEL maintainer "Network Optix <support@networkoptix.com>"

# VMS Server debian package file or URL.
ARG MEDIASERVER_DEB=metavms-server-5.1.3.38363-linux_x64.deb

# VMS Server user and directory name.
ARG COMPANY="networkoptix-metavms"
# Also export as environment variable to use at entrypoint.
ENV COMPANY=${COMPANY}

# Disable EULA dialogs and confirmation prompts in installers.
ENV DEBIAN_FRONTEND noninteractive


FROM ubuntu:20.04
LABEL maintainer "Network Optix <support@networkoptix.com>"

# VMS Server debian package file or URL.
ARG MEDIASERVER_DEB=metavms-server-5.1.3.38363-linux_x64.deb


# Install packages needed for dpkg and other dependencies
RUN apt-get update && \
    apt-get install -y \
    cifs-utils \
    libcap2-bin \
    libglib2.0-0 \
    net-tools \
    dpkg

# Copy deb file to container
COPY metavms-server-5.1.3.38363-linux_x64.deb /tmp/mediaserver.deb

# Install the deb file
RUN dpkg -i /tmp/mediaserver.deb || apt-get install -f -y

# Clean up temporary file
RUN rm /tmp/mediaserver.deb

RUN chown networkoptix-metavms: /opt/networkoptix-metavms/mediaserver/var/

# Add entrypoint script
ADD entrypoint.sh /opt/mediaserver/entrypoint.sh
USER ${COMPANY}
WORKDIR /home/${COMPANY}
# Runs the media server on container start unless argument(s) specified.
ENTRYPOINT ["/opt/mediaserver/entrypoint.sh"]
