FROM ubuntu:jammy

RUN apt-get update \
&& apt-get install -y git wget \
&& apt-get install -y autoconf autotools-dev gcc g++ libssl-dev libtool make pkg-config libusb-1.0-0-dev \
# Delete all the apt list files since they're big and get stale quickly
&& rm -rf /var/lib/apt/lists/*

WORKDIR /src

RUN git clone https://github.com/libimobiledevice/libplist \
&& git clone https://github.com/libimobiledevice/libimobiledevice-glue \
&& git clone https://github.com/libimobiledevice/libusbmuxd \
&& git clone https://github.com/libimobiledevice/libimobiledevice \
&& git clone https://github.com/libimobiledevice/usbmuxd

WORKDIR /src/libplist
RUN ./autogen.sh --without-cython --prefix=/usr \
&& make \
&& make install \
&& DESTDIR=/out make install

WORKDIR /src/libimobiledevice-glue
RUN ./autogen.sh --without-cython --prefix=/usr \
&& make \
&& make install \
&& DESTDIR=/out make install

WORKDIR /src/libusbmuxd
RUN ./autogen.sh --without-cython --prefix=/usr \
&& make \
&& make install \
&& DESTDIR=/out make install

WORKDIR /src/libimobiledevice
RUN ./autogen.sh --without-cython --prefix=/usr \
&& make \
&& make install \
&& DESTDIR=/out make install

WORKDIR /src/usbmuxd
RUN ./autogen.sh --prefix=/usr \
&& make \
&& make install \
&& DESTDIR=/out make install

FROM ubuntu:jammy

WORKDIR /

RUN apt-get update \
&& apt-get install -y openssl libusb-1.0-0-dev \
# Delete all the apt list files since they're big and get stale quickly
&& rm -rf /var/lib/apt/lists/*

COPY --from=0 /out/usr/ /usr/

# Start the server by default
CMD [ "/usr/sbin/usbmuxd", "-f" ]