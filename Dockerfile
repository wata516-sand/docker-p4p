FROM ubuntu:18.04

ENV P4P_MAXCACHEAGEDAYS=30 \
    P4P_MAXCACHESIZE=10GB \
    P4USER=p4admin \
    P4PPORT=localhost:1667 \
    P4PTARGET=localhost:1666 \
    P4PFSIZE=0 \
    P4DEBUG=0 \
    P4PCOMPRESS=TRUE \
    P4TRUST=/p4/config/.p4trust \
    P4TICKETS=/p4/config/.p4tickets

RUN apt-get update
RUN apt-get install -y wget
RUN apt-get install -y gnupg
RUN apt-get install -y openssl

RUN echo deb http://package.perforce.com/apt/ubuntu bionic release> /etc/apt/sources.list.d/perforce.list
RUN wget -qO - https://package.perforce.com/perforce.pubkey | apt-key add -

RUN apt-get update
RUN apt-get install -y helix-proxy
RUN apt-get install -y helix-cli

EXPOSE 1667

RUN mkdir -p /p4/cache && \
    mkdir -p /p4/logs && \
    mkdir -p /p4/ssl && \
    mkdir -p /p4/config

VOLUME [ "/p4/cache", "/p4/logs", "/p4/ssl", "/p4/config" ]

ENV P4PPORT ssl::1667
ENV P4PTARGET ssl:localhost:1666

ADD ./run.sh /
CMD ["/run.sh"]
