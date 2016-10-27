FROM armv7/armhf-ubuntu:xenial

ENV DEBIAN_FRONTEND=noninteractive

RUN export build_deps="gcc make libc6-dev wget" \
	&& apt-get update \
	&& apt-get -y install --no-install-recommends tor ca-certificates $build_deps \
	&& wget -nv -O - https://github.com/Yelp/dumb-init/archive/v1.2.0.tar.gz | tar xvzC /tmp/ \
	&& cd /tmp/dumb-init-1.2.0 && make && cp dumb-init /usr/local/bin && cd /tmp && rm -r dumb-init-1.2.0 \
	&& wget -nv -O /usr/local/bin/gosu https://github.com/tianon/gosu/releases/download/1.10/gosu-armhf && chmod +x /usr/local/bin/gosu \
	&& apt-get -y purge --auto-remove $build_deps && apt-get clean && rm -rf /var/lib/apt/lists/* \
	&& echo "SOCKSPort 0.0.0.0:9050" >>/etc/tor/torrc

EXPOSE 9050

ENTRYPOINT ["dumb-init", "--", "gosu", "debian-tor", "tor"]
