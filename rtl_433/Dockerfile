ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base:3.16
FROM $BUILD_FROM as builder

ENV LANG C.UTF-8

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Copied with minor edits from https://github.com/hertzg/rtl_433_docker/blob/master/images/alpine/build-context/Dockerfile
RUN apk add --no-cache --virtual .buildDeps \
    build-base \
    libusb-dev \
    librtlsdr-dev \
    cmake \
    linux-headers \
    py3-pip=23.1.2-r0 \
    python3-dev=3.11.6-r0 \
    git 

WORKDIR /build

RUN git clone https://github.com/catduckgnaf/rtl_433
WORKDIR ./rtl_433

# Build a specific commit or tag.
ARG rtl433GitRevision=master
RUN git checkout ${rtl433GitRevision}
WORKDIR ./build
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

RUN pip3 install websocket-client

WORKDIR /root
COPY --from=builder /build/root/ /


# Run script
COPY run.sh /
RUN chmod a+x /run.sh
CMD [ "/run.sh" ]
