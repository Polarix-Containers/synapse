FROM ghcr.io/polarix-containers/synapse:rc

USER root

RUN pip install --upgrade pip \
    && pip install -e "git+https://github.com/matrix-org/mjolnir.git#egg=mjolnir&subdirectory=synapse_antispam"

USER synapse