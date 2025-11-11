FROM ghcr.io/polarix-containers/synapse:antispam-rc

USER root

RUN apk --no-cache add jemalloc

# We don't need to remove LD_PRELOAD, as synapse will always use jemalloc if it is available.

USER synapse