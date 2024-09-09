# Synapse

![Build, scan & push](https://github.com/Polarix-Containers/synapse/actions/workflows/build.yml/badge.svg)

### Features & usage
- Drop-in replacement for the [official image](https://github.com/element-hq/synapse/tree/develop/docker).
- Unprivileged image: you should check your volumes' permissions (eg `/data`), default UID/GID is 3000.
- Based on the latest [Alpine](https://alpinelinux.org/) containers which provide more recent packages while having less attack surface.
- [Mjolnir module](https://github.com/matrix-org/mjolnir/blob/main/docs/synapse_module.md) included in `mjolnir` images.

### Licensing
- Licensed under AGPL 3 to comply with licensing changes by Element.
- Any image built by Polarix Containers is provided under the combination of license terms resulting from the use of individual packages.
