FROM ubuntu:26.04 AS source

ADD --checksum=sha256:e1a3ea2b8feb8208e901bf014d5455ec19998dfa20b9bbc4fb8fa8bb0a7359cd \
    https://dl.librewolf.net/librewolf/154.0-2/librewolf-154.0-2-linux-x86_64-appimage.AppImage \
    /tmp/LibreWolf.AppImage

RUN chmod 0755 /tmp/LibreWolf.AppImage && \
    /tmp/LibreWolf.AppImage --appimage-extract

FROM ghcr.io/containerpak/gtk3:main

COPY --from=source /squashfs-root /opt/librewolf

RUN printf '#!/bin/sh\nexec /opt/librewolf/AppRun "$@"\n' > /usr/bin/librewolf && \
    chmod 0755 /usr/bin/librewolf && \
    cpak-clean-junk
