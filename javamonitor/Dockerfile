FROM anapsix/alpine-java:latest

ENV NEXT_ROOT /tmp
RUN mkdir -p /woapps
WORKDIR /woapps
RUN curl -O https://jenkins.wocommunity.org/job/Wonder/lastSuccessfulBuild/artifact/Root/Roots/JavaMonitor.tar.gz
RUN tar xzf JavaMonitor.tar.gz && rm JavaMonitor.tar.gz
# Fix pour java.net.UnknownHostException: 46ffc56f5fcd: 46ffc56f5fcd: Name or service not known
RUN echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf
EXPOSE 56789

CMD /woapps/JavaMonitor.woa/JavaMonitor -WOPort 56789
