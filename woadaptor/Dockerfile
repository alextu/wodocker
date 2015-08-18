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
RUN apt-get purge -y --auto-remove $buildDeps