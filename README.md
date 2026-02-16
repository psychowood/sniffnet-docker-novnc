# Sniffnet on noVNC Display Container
```
This image is intended as an experiment to run [Sniffnet](https://github.com/GyulyVGC/sniffnet) on a docker host to analyze traffic for all the configured networks and containers.

Since my host OS is running [burmilla OS](https://github.com/burmilla/os) I don't have x11 available the standard sniffnet docker image couldn't run, so I needed a standalone way to do it.

# Warning

The container is running as root, on the host network (that's why it does not need a mapped port), with NET_ADMIN and NET_RAW privileges.
I won't publish a ready to use image because of that, since you shouldn't trust a stranger on the internet :)

## Image Contents

* [sniffnet](https://github.com/GyulyVGC/sniffnet) - Application to comfortably monitor your Internet traffic

* [Xvfb](http://www.x.org/releases/X11R7.6/doc/man/man1/Xvfb.1.xhtml) - X11 in a virtual framebuffer
* [x11vnc](http://www.karlrunge.com/x11vnc/) - A VNC server that scrapes the above X11 server
* [noNVC](https://kanaka.github.io/noVNC/) - A HTML5 canvas vnc viewer
* [xdotool](https://github.com/jordansissel/xdotool) - to maximize the sniffnet window, since it is running without a window manager
* [supervisord](http://supervisord.org) - to keep it all running

## Usage

### Running

Clone, build, run
```bash
# Clone the repo
$ git clone https://github.com/psychowood/sniffnet-docker-novnc
$ cd sniffnet-docker-novnc
# Build the image. Be patient, it will take a while since x11 has a lot of dependencies
$ docker build -t sniffnet-docker-novnc .
# Run in background
$ docker compose up -d 
# Check the logs (Ctrl+c to exit)
$ docker compose logs -f
sniffnet-docker-novnc  | 2025-12-10 22:43:58,535 CRIT Supervisor is running as root.  Privileges were not dropped because no user is specified in the config file.  If you intend to run as root, you can set user=root in the config file to avoid this message.
sniffnet-docker-novnc  | 2025-12-10 22:43:58,538 INFO supervisord started with pid 1
sniffnet-docker-novnc  | 2025-12-10 22:43:59,541 INFO spawned: 'x11vnc' with pid 7
sniffnet-docker-novnc  | 2025-12-10 22:43:59,543 INFO spawned: 'xvfb' with pid 8
sniffnet-docker-novnc  | 2025-12-10 22:43:59,545 INFO spawned: 'websockify' with pid 9
sniffnet-docker-novnc  | 2025-12-10 22:43:59,546 INFO spawned: 'sniffnet' with pid 10
sniffnet-docker-novnc  | 
sniffnet-docker-novnc  | ╭────────────────────────────────────────────────────────────────────╮
sniffnet-docker-novnc  | │                                                                    │
sniffnet-docker-novnc  | │                           Sniffnet 1.4.2                           │
sniffnet-docker-novnc  | │                                                                    │
sniffnet-docker-novnc  | │           → Website: https://sniffnet.net                          │
sniffnet-docker-novnc  | │           → GitHub:  https://github.com/GyulyVGC/sniffnet          │
sniffnet-docker-novnc  | │                                                                    │
sniffnet-docker-novnc  | ╰────────────────────────────────────────────────────────────────────╯
sniffnet-docker-novnc  | 
sniffnet-docker-novnc  | Defaulting to search window name, class, and classname
sniffnet-docker-novnc  | 2025-12-10 22:44:00,552 INFO success: x11vnc entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
sniffnet-docker-novnc  | 2025-12-10 22:44:00,552 INFO success: xvfb entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
sniffnet-docker-novnc  | 2025-12-10 22:44:00,552 INFO success: websockify entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
sniffnet-docker-novnc  | 2025-12-10 22:44:00,552 INFO success: sniffnet entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
```

Open a browser at `http://<server>:8088/` (or the port you configured) and enjoy Sniffnet in your browser.

### Variables

You can specify the following variables:
* `DISPLAY_WIDTH=<width>` (1600)
* `DISPLAY_HEIGHT=<height>` (1200)
* `WEB_PORT=8088`

* The screen size is adjustable to suit your preferences via environment variables
* The only exposed port `WEB_PORT` is for HTTP browser connections

```
services:
  sniffnet-docker-novnc: 
    # build with `docker build -t psychowood/sniffnet-docker-novnc .`
    image: psychowood/sniffnet-docker-novnc:latest
    container_name: sniffnet-docker-novnc
    network_mode: host
    environment:
      - WEB_PORT=8088
      # Adjust if you want
      - DISPLAY_WIDTH=1600
      - DISPLAY_HEIGHT=1200
    #If you want to save dumps somewhere persistent, uncomment this and adjust the path
#    volumes:
#      - /tmp:/tmp
    cap_add:
      - NET_ADMIN
      - NET_RAW


```


# Thanks
___
Based on the container by theasp: https://github.com/theasp/docker-novnc and the official Sniffnet docker image
