include $(top_builddir)/Common.mk

needed_cpan_packages = @NEED_CWD@ @NEED_GLD@ @NEED_IOFILE@

dist_bin_SCRIPTS = fixdecode

CLEANFILES = $(dist_bin_SCRIPTS)

EXTRA_DIST = fixdecode.pl.in

.PHONY: 	cpan

cpan: 	 	Makefile
	for pkg in $(needed_cpan_packages); do \
	  cpan -i $$pkg; \
	done

do_subs_local = sed \
	-e 's,[@]xmldir[@],$(abspath $(top_builddir)/dicts),g' \
	-e 's,[@]bindir[@],$(abspath $(top_builddir)/bin),g' \
	-e 's,[@]PERL[@],$(PERL),g'


do_subs_install = sed \
	-e 's,[@]xmldir[@],$(abspath $(pkgdatadir)/dicts),g' \
	-e 's,[@]bindir[@],$(abspath $(bindir)),g' \
	-e 's,[@]PERL[@],$(PERL),g'


fixdecode: 	fixdecode.pl.in cpan
	rm -Rf $(top_builddir)/bin/fixdecode fixdecode
	$(do_subs_local) < fixdecode.pl.in > fixdecode
	chmod +x fixdecode
	cd $(BIN_ROOT) && ln -s $$OLDPWD/fixdecode


install-exec-local: 	fixdecode
	$(do_subs_install) < fixdecode.pl.in > $(bindir)/fixdecode
	chmod +x $(bindir)/fixdecode

clean-local: 	
	rm -Rf fixdecode $(top_builddir)/bin/fixdecode



