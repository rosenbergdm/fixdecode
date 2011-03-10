# Process this file with autoconf to produce a configure script.
AC_INIT([fixdecode], [0.1])
AC_CONFIG_AUX_DIR([configure.d])
AC_CONFIG_MACRO_DIR([m4])
AM_INIT_AUTOMAKE([foreign])
LT_INIT
AC_SUBST([LIBTOOL_DEPS])

AC_PROG_CXX
AC_PROG_CC
AC_PROG_SED
AC_PROG_GREP

PERL="`which perl`"
AC_SUBST([PERL])

has_gld="`perl -MGetopt::Long::Descriptive -e exit 0 >/dev/null 2>&1; echo $?`"
has_iofile="`perl -MIO::File -e exit 0 >/dev/null 2>&1; echo $?`"
has_cwd="`perl -MCwd -e exit 0 > /dev/null 2>&1; echo $?`"

if test "x$has_cwd" = "x1"; then
  NEED_CWD="Getopt::Long::Descriptive"
else
  NEED_CWD=""
fi

if test "x$has_iofile" = "x1"; then
  NEED_IOFILE="Getopt::Long::Descriptive"
else
  NEED_IOFILE=""
fi

if test "x$has_gld" = "x1"; then
  NEED_GLD="Getopt::Long::Descriptive"
else
  NEED_GLD=""
fi

AC_SUBST([NEED_CWD])
AC_SUBST([NEED_IOFILE])
AC_SUBST([NEED_GLD])

#-----------------------------------------------------------------------------
# gcc/flags/libs

SHAREDFLAGS="-Wall -O3 -fno-strict-aliasing"
CFLAGS="$SHAREDFLAGS"
CXXFLAGS="$SHAREDFLAGS"

AC_SUBST([CFLAGS])
AC_SUBST([CXXFLAGS])


# Checks for header files.
AC_CHECK_HEADERS([stdio.h])

#-----------------------------------------------------------------------------
AC_CONFIG_HEADERS([config.h])

AC_CONFIG_FILES([
  Common.mk
  Makefile
  src/Makefile
  dicts/Makefile
  perl/Makefile
])

AC_OUTPUT
