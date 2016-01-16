# -----------------------------------------------------------------------------
# docker-wormhole
#
# Base Ubuntu + SoftEther VPN + Wormhole
# (https://wormhole.network).
#
# Authors: Pedro Perez
# Updated: Jan 16th, 2016
# Require: Docker (http://www.docker.io/)
# -----------------------------------------------------------------------------


# Base system is the LTS version of Ubuntu.
FROM   ubuntu:14.04


# Make sure we don't get notifications we can't answer during building.
ENV    DEBIAN_FRONTEND noninteractive

# Let's keep everything tidy
WORKDIR /usr/local/vpnclient

# Download and install the needed tools
RUN apt-get update &&\
        apt-get -y -q install gcc make wget && \
        apt-get clean && \
        rm -rf /var/cache/apt/* /var/lib/apt/lists/* && \
        wget https://whdowns.blob.core.windows.net/whclient/softether-vpnclient-v4.19-9599-beta-2015.10.19-linux-x64-64bit.tar.gz -O /tmp/softether-vpnclient.tar.gz &&\
        tar -xzvf /tmp/softether-vpnclient.tar.gz -C /usr/local/ &&\
        rm /tmp/softether-vpnclient.tar.gz &&\
        make i_read_and_agree_the_license_agreement &&\
        apt-get purge -y -q --auto-remove gcc make wget && \
        apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Move dhclient to /usr/bin to work around a bug that prevents dhclient from running
RUN mv /sbin/dhclient /usr/sbin/dhclient

# Load in all of our config files.
ADD    ./scripts/start /start
ADD    ./linuxconfig /usr/local/vpnclient/linuxconfig
ADD    ./*.vpn /usr/local/vpnclient/

# Fix all permissions
RUN    chmod +x /start

# /data contains static files and database
VOLUME ["/data"]

# /start runs it.
CMD    ["/start"]
