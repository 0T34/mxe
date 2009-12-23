# Copyright (C) 2009  Volker Grabsch
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject
# to the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# jpeg
PKG             := jpeg
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6b
$(PKG)_CHECKSUM := 7079f0d6c42fad0cfba382cf6ad322add1ace8f9
$(PKG)_SUBDIR   := jpeg-$($(PKG)_VERSION)
$(PKG)_FILE     := libjpeg6b_$($(PKG)_VERSION).orig.tar.gz
$(PKG)_WEBSITE  := http://www.ijg.org/
$(PKG)_URL      := http://ftp.debian.org/debian/pool/main/libj/libjpeg6b/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://packages.debian.org/unstable/source/libjpeg6b' | \
    $(SED) -n 's,.*libjpeg6b_\([0-9][^>]*\)\.orig\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    # avoid redefinition of INT32
    $(SED) 's,typedef long INT32;,#include <basetsd.h>,' -i '$(1)/jmorecfg.h'
    cd '$(1)' && ./configure \
        CC='$(TARGET)-gcc' RANLIB='$(TARGET)-ranlib' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install-lib
endef
