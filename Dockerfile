FROM java:latest
MAINTAINER Caleb Cushing <xenoterracide@gmail.com>

ENV VERSION 2.2.0
ENV DIRNAME apache-archiva-$VERSION
ENV FILENAME $DIRNAME-bin.tar.gz
ENV MIRROR_ROOT http://archive.apache.org/dist/archiva/$VERSION/binaries/
ENV CONF archiva.xml

ADD $FILENAME /opt

RUN useradd -d /srv/archiva archiva
RUN install --owner archiva --group archiva --directory /var/log/archiva
RUN install --owner archiva --group archiva --directory /tmp/archiva --mode 700
RUN install --owner archiva --group archiva --directory /srv/archiva/repositories
RUN install --owner archiva --group archiva --directory /srv/archiva/data

WORKDIR /opt/$DIRNAME
RUN rmdir logs temp
RUN ln -s /var/log/archiva logs
RUN ln -s /tmp/archiva temp
RUN ln -s /srv/archiva/repositories repositories
RUN ln -s /srv/archiva/data data

ADD $CONF conf/
RUN chown archiva. conf/$CONF

USER archiva
VOLUME ["/srv/archiva"]
EXPOSE 8080/tcp 8443/tcp
CMD ["./bin/archiva", "console"]
