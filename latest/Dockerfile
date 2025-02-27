ARG VERSION=1.125.0
ARG PYTHON=3.13
ARG UID=200002
ARG GID=200002

FROM python:${PYTHON}-alpine AS builder

ARG VERSION

RUN apk -U upgrade \
    && apk add -u build-base libffi-dev libjpeg-turbo-dev libstdc++ libxslt-dev linux-headers openssl-dev postgresql-dev rustup zlib-dev

COPY --from=ghcr.io/polarix-containers/hardened_malloc:latest /install /usr/local/lib/
ENV LD_PRELOAD="/usr/local/lib/libhardened_malloc.so"
    
RUN rustup-init -y && source $HOME/.cargo/env \
    && pip install --upgrade pip \
    && pip install --prefix="/install" --no-warn-script-location \
    matrix-synapse[all]==${VERSION}

# ======================================= #

FROM python:${PYTHON}-alpine

LABEL maintainer="Thien Tran contact@tommytran.io"

ARG VERSION
ARG UID
ARG GID

RUN apk -U upgrade \
    && apk --no-cache add curl git icu-libs libffi libjpeg-turbo libpq libstdc++ libxslt openssl tzdata xmlsec zlib \
    && rm -rf /var/cache/apk/*

COPY --from=ghcr.io/polarix-containers/hardened_malloc:latest /install /usr/local/lib/
ENV LD_PRELOAD="/usr/local/lib/libhardened_malloc.so"

RUN --network=none \
    addgroup -g ${GID} synapse \
    && adduser -u ${UID} --ingroup synapse --disabled-password --system synapse

COPY --from=builder /install /usr/local
ADD --chown=synapse:synapse --chmod=755 https://raw.githubusercontent.com/element-hq/synapse/refs/tags/v${VERSION}/docker/start.py /start.py
ADD --chown=synapse:synapse https://github.com/element-hq/synapse.git#v${VERSION}:docker/conf /conf

USER synapse

VOLUME /data

EXPOSE 8008/tcp 8009/tcp 8448/tcp

ENTRYPOINT ["python3", "start.py"]

HEALTHCHECK --start-period=5s --interval=15s --timeout=5s \
    CMD curl -fSs http://localhost:8008/health || exit 1
