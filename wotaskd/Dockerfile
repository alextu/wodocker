FROM anapsix/alpine-java:latest

ENV NEXT_ROOT /tmp
RUN mkdir -p /woapps
WORKDIR /woapps
RUN curl -O https://jenkins.wocommunity.org/job/Wonder/lastSuccessfulBuild/artifact/Root/Roots/wotaskd.tar.gz
RUN tar xzf wotaskd.tar.gz && rm wotaskd.tar.gz
# Fix pour java.net.UnknownHostException: 46ffc56f5fcd: 46ffc56f5fcd: Name or service not known
RUN echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf

EXPOSE 1085

CMD /woapps/wotaskd.woa/wotaskd
