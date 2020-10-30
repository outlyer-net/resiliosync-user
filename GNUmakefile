
DESTDIR=
prefix=/usr/local

all: btsync.user

install:
	install -D -m755 btsync.user $(DESTDIR)$(prefix)/bin/btsync.user
	test -L $(DESTDIR)$(prefix)/bin/rslsync.user \
		|| ln -s btsync.user $(DESTDIR)$(prefix)/bin/rslsync.user

uninstall:
	$(RM) $(DESTDIR)$(prefix)/bin/btsync.user \
			$(DESTDIR)$(prefix)/bin/rslsync.user
	-rmdir -p $(DESTDIR)$(prefix)/bin

