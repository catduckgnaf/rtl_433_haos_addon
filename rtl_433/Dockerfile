ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base:3.16
FROM $BUILD_FROM as builder

ENV LANG C.UTF-8

# Copied with https://github.com/hertzg/rtl_433_docker/blob/master/images/debian/build-context/Dockerfile
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    libusb-1.0-0-dev \
    libsoapysdr-dev \
    libssl-dev \
    librtlsdr-dev \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /build

RUN git clone https://github.com/merbanan/rtl_433
WORKDIR ./rtl_433

# Build a specific commit or tag.
ARG rtl433GitRevision=master
RUN git checkout ${rtl433GitRevision}
WORKDIR ./build
RUN cmake -DENABLE_OPENSSL=ON ..
RUN make
RUN cat Makefile
WORKDIR /build/root
WORKDIR /build/rtl_433/build
RUN make DESTDIR=/build/root/ install
RUN ls -lah /build/root


FROM $BUILD_FROM


RUN apt-get update && apt-get install -y \
    libusb-1.0-0 \
    librtlsdr0 \
    '^libsoapysdr0\.[6-8]$' \
    '^libssl(1\.1|3)$' \
    '^soapysdr0\.[6-8]-module-all$' \
 && rm -rf /var/lib/apt/lists/*WORKDIR /root

WORKDIR /root
COPY --from=builder /build/root/ /

# Run script
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
