FROM java:latest
MAINTAINER Caleb Cushing <xenoterracide@gmail.com>
WORKDIR /tmp

ENV VERSION 2.2.0
ENV DIRNAME apache-archiva-$VERSION
ENV FILENAME $DIRNAME-bin.tar.gz
ENV MIRROR_ROOT http://archive.apache.org/dist/archiva/$VERSION/binaries/

ADD $FILENAME /opt
#
# Adjust ownership and Perform the data directory initialization
#
ADD data_dirs.env /data_dirs.env
ADD init.bash /init.bash
ADD jetty_conf /jetty_conf

RUN useradd -d /opt/$DIRNAME/data -m archiva
RUN cd /opt && chown -R archiva:archiva $DIRNAME
RUN cd / && chown -R archiva:archiva /jetty_conf

ADD run.bash /run.bash
RUN chmod 755 /run.bash

RUN ls -l /srv

USER archiva
VOLUME ["/srv"]
EXPOSE 8080/tcp 8443/tcp
ENTRYPOINT ["/run.bash"]
