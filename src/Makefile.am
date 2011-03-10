# Makefile.am

include $(top_builddir)/Common.mk

bin_PROGRAMS  = fixtr fixspec

MY_TARGETS = $(bin_PROGRAMS)

AM_CPPFLAGS = \
	$(XML2INC_DIR) \
	-I$(INC_ROOT) \
	-I.


AM_LDFLAGS = \
	$(XML2LIB_DIR) \
	$(XML2LIBS) \
	-L$(LIB_ROOT) \
	-L.


library_includedir = $(includedir)


library_include_HEADERS = \
	fixcore.h 


fixspec_SOURCES = \
	fixcore.cpp \
	fixspec.cpp 

fixtr_SOURCES = \
	fixcore.cpp \
	fixtr.cpp 


all-local: $(MY_TARGETS)
	for fname in $(bin_PROGRAMS); do \
		rm -rf $(top_builddir)/bin/$$fname; \
		cp $$fname $(top_builddir)/bin; \
	done

clean-local:
	for fname in $(bin_PROGRAMS); do \
		rm -rf $(top_builddir)/bin/$$fname; \
	done

