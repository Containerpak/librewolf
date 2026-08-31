FROM ubuntu:26.04 AS source

ADD --checksum=sha256:23fdcd8cebc0da744f8c129df8b9ae77685bbe90dd3390e7c698fcdd39c48561 \
    https://dl.librewolf.net/librewolf/154.0.1-3/librewolf-154.0.1-3-linux-x86_64-appimage.AppImage \
    /tmp/LibreWolf.AppImage

RUN chmod 0755 /tmp/LibreWolf.AppImage && \
    /tmp/LibreWolf.AppImage --appimage-extract

FROM ghcr.io/containerpak/gtk3:main

COPY --from=source /squashfs-root /opt/librewolf

RUN printf '#!/bin/sh\nexec /opt/librewolf/AppRun "$@"\n' > /usr/bin/librewolf && \
    chmod 0755 /usr/bin/librewolf && \
    cpak-clean-junk
