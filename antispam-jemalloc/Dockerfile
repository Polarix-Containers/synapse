FROM ghcr.io/polarix-containers/synapse:antispam

USER root

RUN apk --no-cache add jemalloc \
    && mkdir -p /usr/lib/x86_64-linux-gnu \
    && ln -s /usr/lib/libjemalloc.so.2 /usr/lib/x86_64-linux-gnu/libjemalloc.so.2

# We don't need to remove LD_PRELOAD, as synapse will always use jemalloc if it is available.

USER synapse