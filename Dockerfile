FROM raiproject/zipkin-cpp
FROM nvidia/cuda

COPY --from=0 /usr/local/lib/ /usr/local/lib/
COPY --from=0 /usr/local/include /usr/local/include

ENV THRIFT_VERSION 0.10.0

RUN buildDeps=" \
		automake \
		bison \
		curl \
		flex \
		g++ \
		libboost-dev \
		libboost-filesystem-dev \
		libboost-program-options-dev \
		libboost-system-dev \
		libboost-test-dev \
		libevent-dev \
		libssl-dev \
		libtool \
		make \
		pkg-config \
	"; \
	apt-get update && apt-get install -y --no-install-recommends $buildDeps && rm -rf /var/lib/apt/lists/* \
    && curl -sSL "http://apache.mirrors.spacedump.net/thrift/$THRIFT_VERSION/thrift-$THRIFT_VERSION.tar.gz" -o thrift.tar.gz \
	&& mkdir -p /usr/src/thrift \
	&& tar zxf thrift.tar.gz -C /usr/src/thrift --strip-components=1 \
	&& rm thrift.tar.gz \
	&& cd /usr/src/thrift \
	&& ./configure  --without-python --with-cpp \
	&& make \
	&& make install

ENV TRACEPP_SRC=/src/tracepp
ENV TRACEPP_BUILD=/opt/tracepp

RUN apt-get update && apt-get install -y --no-install-recommends git \
        cppcheck libcurl4-openssl-dev libdouble-conversion-dev \
        libgoogle-glog-dev

RUN git config --global http.sslVerify false && \
    git clone https://github.com/rai-project/tracepp.git $TRACEPP_SRC && cd $TRACEPP_SRC && git fetch --all

WORKDIR $TRACEPP_SRC
RUN make
