SRC_NAME=dnsmasq-2.89
SRC_URL=https://thekelleys.org.uk/dnsmasq/$(SRC_NAME).tar.xz

COPTS := -DHAVE_BROKEN_RTC -DNO_INOTIFY -DNO_AUTH -DNO_LOOP -DNO_DUMPFILE
ifndef CONFIG_IPV6
COPTS += -DNO_IPV6
endif
ifndef CONFIG_USB_SUPPORT
COPTS += -DNO_TFTP
endif
ifneq ($(CONFIG_FIRMWARE_INCLUDE_IPSET),y)
COPTS += -DNO_IPSET
endif

all: download_test extract_test
	$(MAKE) -j$(HOST_NCPU) -C $(SRC_NAME) COPTS="$(COPTS)"

download_test:
	( if [ ! -f $(SRC_NAME).tar.xz ]; then \
		wget -t5 --timeout=20 --no-check-certificate -O $(SRC_NAME).tar.xz $(SRC_URL); \
	fi )

extract_test:
	( if [ ! -d $(SRC_NAME) ]; then \
		tar xJf $(SRC_NAME).tar.xz; \
		patch -d $(SRC_NAME) -p1 -i ../dnsmasq-orig.patch; \
	fi )

clean:
	$(MAKE) -C $(SRC_NAME) clean
	rm -f dnsmasq

romfs:
	cp $(SRC_NAME)/src/dnsmasq .
	$(STRIP) dnsmasq
	$(ROMFSINST) /usr/sbin/dnsmasq
