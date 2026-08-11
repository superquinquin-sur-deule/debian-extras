WGET      ?= wget --directory-prefix=public/deb --no-verbose --no-clobber
SHA256SUM ?= sha256sum --ignore-missing

.PHONY: all download check release

all: download check release

download: public/deb/packages.txt
	$(WGET) --input-file $<

check: public/deb/checksums.txt
	cd public/deb && $(SHA256SUM) --check $(notdir $<)

release:
	cp src/* public
	apt-ftparchive packages public | gzip -c9 > public/Packages.gz
	apt-ftparchive release public > public/Release

public/deb/packages.txt: packages/*.deb.src | public/deb
	cat $^ > $@

public/deb/checksums.txt: packages/*.sha256 | public/deb
	cat $^ > $@

public/deb:
	mkdir -p $@
