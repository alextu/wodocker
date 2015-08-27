FROM httpd:2.4
MAINTAINER Alexis Tual

# Compilation and installation of adaptor
ENV buildDeps 'curl unzip gcc make libc6-dev libpcre++-dev apache2-dev'

RUN  set -x \
  && apt-get update \
  && apt-get install -y --no-install-recommends $buildDeps \
  && rm -r /var/lib/apt/lists/*

WORKDIR /tmp
RUN curl -LOk https://github.com/wocommunity/wonder/archive/master.zip
RUN unzip master.zip
WORKDIR /tmp/wonder-master/Utilities/Adaptors
RUN sed -ri 's/ADAPTOR_OS = MACOS/ADAPTOR_OS = LINUX/g' make.config
RUN sed -ri 's/ADAPTORS = CGI Apache2.2/ADAPTORS = Apache2.4/g' make.config
RUN make
WORKDIR /tmp/wonder-master/Utilities/Adaptors/Apache2.4
RUN mv mod_WebObjects.so /usr/local/apache2/modules/.
RUN mkdir /usr/local/apache2/htdocs/WebObjects && \
    sed -ri 's#WebObjectsAlias /cgi-bin/WebObjects#WebObjectsAlias /apps/WebObjects#g' apache.conf && \
    sed -ri 's#WebObjectsDocumentRoot LOCAL_LIBRARY_DIR/WebServer/Documents#WebObjectsDocumentRoot /usr/local/apache2/htdocs/WebObjects#g' apache.conf
RUN echo "<Location /apps/WebObjects> \n\
    Require all granted \n \
</Location>\n \
<Location /WebObjects>\n \
    Require all granted\n \
</Location>" >> apache.conf

RUN mv apache.conf /usr/local/apache2/conf/webobjects.conf
RUN echo "Include /usr/local/apache2/conf/webobjects.conf" >> /usr/local/apache2/conf/httpd.conf
RUN rm /tmp/master.zip && rm -Rf /tmp/wonder-master 

# Installation of java
ENV JAVA_VERSION_MAJOR 8
ENV JAVA_VERSION_MINOR 45
ENV JAVA_VERSION_BUILD 14
ENV JAVA_PACKAGE       jdk

RUN \
    echo "===> add webupd8 repository..."  && \
    echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list  && \
    echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list  && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886  && \
    apt-get update
RUN echo "===> install Java"  && \
    echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections  && \
    echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections  && \
    DEBIAN_FRONTEND=noninteractive  apt-get install -y --force-yes oracle-java8-installer oracle-java8-set-default
RUN echo "===> clean up..."  && \
    rm -rf /var/cache/oracle-jdk8-installer  && \
    apt-get clean  && \
    rm -rf /var/lib/apt/lists/*

# Installation of wotaskd and javamonitor
RUN mkdir -p /woapps
ENV NEXT_ROOT /opt
WORKDIR /woapps
RUN curl -O https://jenkins.wocommunity.org/job/Wonder/lastSuccessfulBuild/artifact/Root/Roots/JavaMonitor.tar.gz
RUN tar xzf JavaMonitor.tar.gz && rm JavaMonitor.tar.gz
RUN curl -O https://jenkins.wocommunity.org/job/Wonder/lastSuccessfulBuild/artifact/Root/Roots/wotaskd.tar.gz
RUN tar xzf wotaskd.tar.gz && rm wotaskd.tar.gz
COPY launchwo.sh /woapps/launchwo.sh
RUN chmod +x /woapps/launchwo.sh

# Cleanup
RUN apt-get purge -y --auto-remove $buildDeps

# Logs
RUN mkdir /var/log/webobjects

# Config
VOLUME ["/var/log/webobjects", "/opt/Local/Library/WebObjects/Configuration", "/woapps", "/usr/local/apache2/htdocs/WebObjects"]

EXPOSE 80 1085 56789

CMD ["/woapps/launchwo.sh"]





