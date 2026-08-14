FROM ubuntu:26.04 AS source

ADD --checksum=sha256:8b909052e9f860a4eeccc8d205d4d1fd3ba6d20497bff10308be7531a6e0bdf0 \
    https://gitlab.com/api/v4/projects/24386000/packages/generic/librewolf/latest/LibreWolf.x86_64.AppImage \
    /tmp/LibreWolf.AppImage

RUN chmod 0755 /tmp/LibreWolf.AppImage && \
    /tmp/LibreWolf.AppImage --appimage-extract

FROM ghcr.io/containerpak/gtk3:main

COPY --from=source /squashfs-root /opt/librewolf

RUN printf '#!/bin/sh\nexec /opt/librewolf/AppRun "$@"\n' > /usr/bin/librewolf && \
    chmod 0755 /usr/bin/librewolf && \
    cpak-clean-junk
