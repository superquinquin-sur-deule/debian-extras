DEPLOY=public
WGET?=wget --directory-prefix=$(DEPLOY) --no-verbose --no-clobber
SHA256SUM?=sha256sum --ignore-missing

all: download check release

download: $(DEPLOY)/packages.txt
	$(WGET) --input-file $^

$(DEPLOY):
	mkdir -p $@

$(DEPLOY)/packages.txt: packages/*.deb.src | $(DEPLOY)
	cat $^ > $@

check: $(DEPLOY)/checksums.txt
	cd $(DEPLOY) && $(SHA256SUM) --check ./checksums.txt

$(DEPLOY)/checksums.txt: packages/*.sha256 | $(DEPLOY)
	cat $^ > $@

release: $(DEPLOY)/Release

$(DEPLOY)/Packages.gz: $(PKG)
	apt-ftparchive packages $(dir $@) | gzip -c9 > $@

$(DEPLOY)/Release: $(DEPLOY)/Packages.gz
	apt-ftparchive release $(dir $@) > $@
