# Make file for sample ASCII, unicode character files and font sample files
# $Id: Makefile,v 1.5 2006/01/16 20:43:02 me Exp $
# Brent S. A. Cowgill

PJ=perl/character_samples
PKG=character-samples.tgz 
PKG_LIST=character_samples

UMASK=022
CVSROOT=/cvsroot
DEV_AREA=/home/me/d/s/$(PJ)
PKG_AREA=/home/swlib/_mine
PKG_TMP_AREA=/home/swlib/_tmp
LIVE_PACKAGE=$(PKG_TMP_AREA)/live-$(PKG)

test:
	perl -MTest::Harness -e 'runtests(@ARGV)' *.t

clean:
	rm -rf td/test_run

# Commands to repackage and install
package:
	@cd $(PKG_TMP_AREA);\
	umask $(UMASK);\
	rm -rf s;\
	cvs -d $(CVSROOT) export -kv -r HEAD s/$(PJ);\
	rm -rf s/$(PJ)/data s/$(PJ)/Makefile s/$(PJ)/pj.*;\
	mv s/$(PJ) s;\
	chown -R root:root s;\
	pushd s > /dev/null; tar cvzf $(PKG_AREA)/$(PKG) $(PKG_LIST); chown root:root $(PKG_AREA)/$(PKG); popd >/dev/null;\
	echo Rebuilt package $(PKG_AREA)/$(PKG) for project $(PJ)

#==========================================================================
# Standard commands for installing, getting a live package and diffing live vs package 
#==========================================================================

install:
	@pushd $(HOME)/docs > /dev/null &&  tar xvzf $(PKG_AREA)/$(PKG); popd > /dev/null
	@echo Installed package $(PKG_AREA)/$(PKG) under $(HOME)/docs

rebuild: package install

clean_temp:
	-@rm -rf $(PKG_TMP_AREA)/s

clean_live_pkg: clean_temp
	-@rm $(LIVE_PACKAGE)

# Phony targets so they will always be considered out of date

.PHONY: package

.PHONY: install

.PHONY: clean_temp

