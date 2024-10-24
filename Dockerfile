ARG VERSION=1.118.0rc1
ARG PYTHON=3.12
ARG UID=3000
ARG GID=3000


### Build Synapse
FROM python:${PYTHON}-alpine AS synapse-builder

ARG VERSION

RUN apk -U upgrade \
    && apk add -u build-base libffi-dev libjpeg-turbo-dev libstdc++ libxslt-dev linux-headers openssl-dev postgresql-dev rustup zlib-dev

COPY --from=ghcr.io/polarix-containers/hardened_malloc:latest /install /usr/local/lib/
ENV LD_PRELOAD="/usr/local/lib/libhardened_malloc.so"
    
RUN rustup-init -y && source $HOME/.cargo/env \
    && pip install --upgrade pip \
    && pip install --prefix="/install" --no-warn-script-location \
    matrix-synapse[all]==${VERSION}


### Get RootFS Files
FROM alpine:latest AS rootfs

ARG VERSION

RUN apk -U upgrade \
    && apk --no-cache add git libstdc++ \
    && rm -rf /var/cache/apk/*

COPY --from=ghcr.io/polarix-containers/hardened_malloc:latest /install /usr/local/lib/
ENV LD_PRELOAD="/usr/local/lib/libhardened_malloc.so"

RUN cd /tmp \
    && git clone --depth 1 --branch v${VERSION} https://github.com/element-hq/synapse


### Build Production

FROM python:${PYTHON}-alpine

LABEL maintainer="Thien Tran contact@tommytran.io"

ARG UID
ARG GID

RUN apk -U upgrade \
    && apk --no-cache add curl git icu-libs libffi libjpeg-turbo libpq libstdc++ libxslt openssl tzdata xmlsec zlib \
    && rm -rf /var/cache/apk/*

COPY --from=ghcr.io/polarix-containers/hardened_malloc:latest /install /usr/local/lib/
ENV LD_PRELOAD="/usr/local/lib/libhardened_malloc.so"

COPY --from=synapse-builder /install /usr/local
COPY --from=rootfs --chown=synapse:synapse /tmp/synapse/docker/start.py /start.py
COPY --from=rootfs --chown=synapse:synapse /tmp/synapse/docker/conf /conf

RUN adduser -u ${UID} -g ${GID} --disabled-password --system synapse
USER synapse

VOLUME /data

EXPOSE 8008/tcp 8009/tcp 8448/tcp

ENTRYPOINT ["python3", "start.py"]

HEALTHCHECK --start-period=5s --interval=15s --timeout=5s \
    CMD curl -fSs http://localhost:8008/health || exit 1
