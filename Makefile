## REL+

# Copyright 2011-2014 Mark Owen; Windows port by Peter Flippant
# http://www.quinapalus.com
# E-mail: qxw@quinapalus.com
# 
# This file is part of Qxw.
# 
# Qxw is free software: you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License
# as published by the Free Software Foundation.
# 
# Qxw is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with Qxw.  If not, see <http://www.gnu.org/licenses/> or
# write to the Free Software Foundation, Inc., 51 Franklin Street,
# Fifth Floor, Boston, MA  02110-1301, USA.


all:: fill

# Headless build (see ../qxw-cli-headless-build.md): filler.c/dicts.c/fill.c have no
# live GTK/glib/cairo/pcre/pthread symbol references (verified by grep), so this build
# drops those deps entirely instead of installing GTK2/PCRE1, which are unavailable on
# modern distros. Only libm (math) and libdl (plug-in dlopen) are actually linked.
CFLAGS := -g -Wall -fstack-protector --param=ssp-buffer-size=4 -Wformat -Wformat-security -Werror=format-security
LFLAGS := -Wl,-Bsymbolic-functions -Wl,-z,relro -lm
ifneq ($(filter deb,$(MAKECMDGOALS)),)
  CFLAGS:= $(CFLAGS) -g
else
  CFLAGS:= $(CFLAGS) -O9
endif

fill: fill.o filler.o dicts.o
	gcc -rdynamic -Wall -ldl fill.o filler.o dicts.o $(LFLAGS) -o fill

filler.o: filler.c filler.h dicts.h common.h Makefile
	gcc $(CFLAGS) -c filler.c -o filler.o

dicts.o: dicts.c dicts.h common.h Makefile
	gcc $(CFLAGS) -fno-strict-aliasing -c dicts.c -o dicts.o

draw.o: draw.c draw.h common.h Makefile
	gcc $(CFLAGS) -c draw.c -o draw.o

.PHONY: clean
clean:
	rm -f dicts.o draw.o filler.o qxw.o qxw

## REL-
