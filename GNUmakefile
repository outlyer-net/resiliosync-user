
DESTDIR=
prefix=/usr/local

all: btsync.user.sh btsync.gui.bash

install:
	install -D -m755 btsync.user.sh $(DESTDIR)$(prefix)/bin/btsync.user
	test -L $(DESTDIR)$(prefix)/bin/rslsync.user \
		|| ln -s btsync.user $(DESTDIR)$(prefix)/bin/rslsync.user

	install -D -m755 btsync.gui.bash $(DESTDIR)$(prefix)/bin/btsync.gui
	test -L $(DESTDIR)$(prefix)/bin/btsync.gui \
		|| ln -s btsync.gui $(DESTDIR)$(prefix)/bin/rslsync.gui

uninstall:
	$(RM) $(DESTDIR)$(prefix)/bin/btsync.user \
			$(DESTDIR)$(prefix)/bin/rslsync.user \
			\
			$(DESTDIR)$(prefix)/bin/btsync.gui \
			$(DESTDIR)$(prefix)/bin/rslsync.gui \
	-rmdir -p $(DESTDIR)$(prefix)/bin

