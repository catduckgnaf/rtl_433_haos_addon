ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base:3.16
FROM $BUILD_FROM as builder

ENV LANG C.UTF-8

# Copied with minor edits from https://github.com/hertzg/rtl_433_docker/blob/master/images/alpine/build-context/Dockerfile
RUN apk add --no-cache --virtual .buildDeps \
    build-base \
    libusb-dev \
    librtlsdr-dev \
    cmake \
    git

ADD ./rtl_433 ./rtl_433
WORKDIR /build

RUN git clone https://github.com/merbanan/rtl_433
WORKDIR ./rtl_433
WORKDIR ./build
RUN cmake ..
RUN make -j 4

WORKDIR /build/root
WORKDIR /build/rtl_433/build
RUN make DESTDIR=/build/root/ install

FROM $BUILD_FROM

ENV LANG C.UTF-8

RUN apk add --no-cache libusb \
    librtlsdr \ tzdata \ libressl
    sed
WORKDIR /root
COPY --from=builder /build/root/ /

# Run script
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
