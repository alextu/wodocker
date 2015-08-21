FROM httpd:2.4

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
# RUN sed -ri "s#libdir='/usr/lib/apache2/modules'#libdir='/usr/local/apache2/modules'#g" mod_WebObjects.la
# RUN apxs -i -a -n WebObjects mod_WebObjects.la
RUN mv mod_WebObjects.so /usr/local/apache2/modules/.
RUN sed -ri 's#WebObjectsAlias /cgi-bin/WebObjects#WebObjectsAlias /apps/WebObjects#g' apache.conf
RUN echo "<Location /apps/WebObjects> \n\
    Require all granted \n \
</Location>\n \
<Location /WebObjects>\n \
    Require all granted\n \
</Location>" >> apache.conf

RUN mv apache.conf /usr/local/apache2/conf/webobjects.conf
RUN echo "Include /usr/local/apache2/conf/webobjects.conf" >> /usr/local/apache2/conf/httpd.conf
RUN apt-get purge -y --auto-remove $buildDeps

# hack to replace wotaskd hosts by the ones provided 
CMD sed -ri "s#WebObjectsConfig http://localhost:1085 10#WebObjectsConfig $WOTASKD_HOSTS 10#g" /usr/local/apache2/conf/webobjects.conf && httpd-foreground