FROM registry.access.redhat.com/ubi8/ubi:8.0

RUN mkdir -p /opt/app-root && \
    yum -y install nodejs

WORKDIR /opt/app-root

ADD server.js .

CMD ['node', 'server.js']
