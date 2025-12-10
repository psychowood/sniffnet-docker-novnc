#FROM debian:stable-slim

FROM ghcr.io/gyulyvgc/sniffnet:latest
# Install supervisor, VNC, & X11 packages
RUN set -ex; \
    apt-get update; \
    apt-get install -y \
      bash \
      novnc \
      git \
      net-tools \
      supervisor \
      x11vnc \
      xvfb \
      xdotool \
      libxcursor1 \
      libxkbcommon-x11-0
 
# Setup environment variables
ENV HOME=/root \
    DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=C.UTF-8 \
    DISPLAY=:0.0 \
    WEB_PORT=8088 \
    DISPLAY_WIDTH=1024 \
    DISPLAY_HEIGHT=768 \
    RUST_BACKTRACE=full \
    ICED_BACKEND=tiny-skia

RUN cp /usr/share/novnc/vnc_lite.html /usr/share/novnc/index.html

COPY ./supervisord.conf /app/supervisord.conf

CMD ["supervisord","-c","/app/supervisord.conf"]
ENTRYPOINT []
