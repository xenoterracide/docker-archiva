FROM java:latest
MAINTAINER Caleb Cushing <xenoterracide@gmail.com>

ENV VERSION 2.2.0
ENV DIRNAME apache-archiva-$VERSION
ENV FILENAME $DIRNAME-bin.tar.gz
ENV MIRROR_ROOT http://archive.apache.org/dist/archiva/$VERSION/binaries/
ENV CONF archiva.xml

WORKDIR /tmp

RUN wget --no-verbose $MIRROR_ROOT/$FILENAME && tar -xvf $FILENAME && rm $FILENAME && mv $DIRNAME /opt

RUN useradd -d /srv/archiva archiva
RUN install --owner archiva --group archiva --directory /var/log/archiva
RUN install --owner archiva --group archiva --directory --mode 700 /tmp/archiva

WORKDIR /opt/$DIRNAME
RUN rmdir logs temp
RUN ln -s /var/log/archiva logs
RUN ln -s /tmp/archiva temp
RUN ln -s /srv/archiva/repositories repositories
RUN ln -s /srv/archiva/data data
RUN chown archiva. conf/$CONF

USER archiva
VOLUME ["/srv/archiva/data", "/srv/archiva/repositories", "/var/log/archiva"]
EXPOSE 8080/tcp 8443/tcp
CMD ["./bin/archiva", "console"]
