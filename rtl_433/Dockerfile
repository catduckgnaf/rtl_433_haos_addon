ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base:3.18
FROM $BUILD_FROM as builder

ENV LANG C.UTF-8

# Copied with minor edits from https://github.com/hertzg/rtl_433_docker/blob/master/images/alpine/build-context/Dockerfile
RUN apk add --no-cache --virtual .buildDeps \
    build-base \
    libusb-dev \
    librtlsdr-dev \
    cmake \
    git

WORKDIR /build

RUN git clone https://github.com/catduckgnaf/rtl_433
WORKDIR /build/rtl_433/build
RUN cmake ..

# Build a specific commit or tag.
ARG rtl433GitRevision=master
RUN git checkout ${rtl433GitRevision}
WORKDIR /build/rtl_433/build
RUN cmake ..
RUN make -j 4

WORKDIR /build/root
WORKDIR /build/rtl_433/build
RUN make DESTDIR=/build/root/ install

FROM $BUILD_FROM

ENV LANG C.UTF-8

RUN apk add --no-cache libusb \
    librtlsdr \
    sed
WORKDIR /root
COPY --from=builder /build/root/ /

# Run script
COPY run.sh /

RUN \
    apk add --no-cache \
        python3 \
        py3-pip \
    \
    && pip install \
        --no-cache-dir \
        --prefer-binary \
        paho-mqtt \
        websockets 

CMD [ "/run.sh" ]