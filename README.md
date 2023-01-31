# A Docker container to multiplex connections from and to iOS devices.

This repository contains scripts to build a Docker image which contains
the latest version of [usbmuxd](https://github.com/libimobiledevice/usbmuxd).

To build usbmuxd:

```
docker build -t usbmuxd .
```

To run usbmuxd:

```
docker run --privileged -v /dev/bus/usb:/dev/bus/usb -v /var/lib/lockdown:/var/lib/lockdown -v /var/run:/var/run --restart always --detach --name usbmuxd usbmuxd
```

To view the logs:

```
docker logs usbmuxd
```