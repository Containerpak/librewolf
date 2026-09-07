FROM ubuntu:26.04 AS source

ADD --checksum=sha256:f30b4eb32ea73e9fed5edc4649e157dad05d20619c14db20b1fce6ce2f4ba31c \
    https://dl.librewolf.net/librewolf/155.0.1-1/librewolf-155.0.1-1-linux-x86_64-appimage.AppImage \
    /tmp/LibreWolf.AppImage

RUN chmod 0755 /tmp/LibreWolf.AppImage && \
    /tmp/LibreWolf.AppImage --appimage-extract

FROM ghcr.io/containerpak/gtk3:main

COPY --from=source /squashfs-root /opt/librewolf

RUN printf '#!/bin/sh\nexec /opt/librewolf/AppRun "$@"\n' > /usr/bin/librewolf && \
    chmod 0755 /usr/bin/librewolf && \
    cpak-clean-junk
