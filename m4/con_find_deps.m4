# con_find_deps.m4 -- m4 macros for locating lib, include, and bin directories
#                     in a project, regardless of whether a subproject is the 
#                     'top' target or a only a dependency.

#serial 4 

# CON_FIND_DEP_BASE
# -----------------
# Find and substitute the base libdir bindir and include dir values into the 
# output variables CON_LIB_DIR CON_BIN_DIR and CON_INC_DIR, respectively.
AC_DEFUN([CON_FIND_DEP_BASE],[
  AC_REQUIRE([AC_PROG_SED])
  AC_REQUIRE([AC_PROG_GREP])
  AS_IF([test "`cd .. && basename $PWD && cd $OLDPWD`" = "deps"],
        [_con_cv_lib_inc_root="`ls -d ../../*/lib/../include/../ | head -n 1`"
         con_cv_lib_inc_root="`cd $_con_cv_lib_inc_root && pwd && cd $OLDPWD`"
         con_cv_build_root="`cd ../build && pwd && cd $OLDPWD`"],
        [con_cv_lib_inc_root="`pwd`"
         con_cv_build_root="`cd ../deps/build && pwd && cd $OLDPWD`"])
  CON_LIB_DIR="$con_cv_lib_inc_root/lib"
  CON_INC_DIR="$con_cv_lib_inc_root/include"
  CON_BUILD_DIR="$con_cv_build_root"
  AC_SUBST([CON_LIB_DIR])
  AC_SUBST([CON_INC_DIR])
  AC_SUBST([CON_BUILD_DIR])
  ])

# CON_FIND_DEP_DIRS(LIB-BASENAME, [OUTPUT-LIB-VAR], [OUTPUT-INC-VAR], [OUTPUT_LIBS-VAR])
# -------------------------------------------------------------------
# Find the absolute path to the 'installed' libdir and include dir of a
# specified dependent program within the Connamara Build Structure.  LIB-BASENAME
# sould be the 'base' name of the library.  If not set specified, the output shell
# variables $1_LIB_DIR and $1_INC_DIR are set to the absolute path of the library's
# libdir and includedir, repspectively.  As an example, 
# CON_FIND_DEP_DIRS([json])
# would set the shell variables JSON_LIB_DIR and JSON_INC_DIR to the  directories 
# /path/to/the/library/lib/jsoncpp-0.5.0 and /path/to/headers/include/jsoncpp-0.5.0.
# Note that this macro does not do final output var substitution.  You will neet to
# still want to call AC_SUBST([JSON_LIB_DIR]) and AC_SUBST([JSON_INC_DIR]) to do
# Makefile substitutions.
AC_DEFUN([CON_FIND_DEP_DIRS], [
  AC_REQUIRE([CON_FIND_DEP_BASE])
  AS_CASE($1,
          [apr*],
          [config_script="`ls $CON_BUILD_DIR/*/bin/* | grep $1 | head -n 1`"],
          [active*],
          [config_script="`ls $CON_BUILD_DIR/*/bin/* | grep $1 | grep config | head -n 1`"],
          [config_script=""])
  AC_MSG_CHECKING([for $1 library directories])
  con_found_lib_dir="`ls $CON_LIB_DIR | grep $1 | head -n 1`"
  AS_IF([test "x$con_found_lib_dir" = "x" ],
        [AC_MSG_FAILURE([could not locate libdir for $1])],
        [AC_MSG_RESULT([$con_found_lib_dir])
         AS_IF([test "x$config_script" = "x"],
               [AS_IF([test "x$2" = "x" ],
                      [_con_outlib="`echo $1 | tr a-z A-Z | sed 's/$/_LIB_DIR/'`";
                       AS_VAR_SET([$_con_outlib], [-L$CON_LIB_DIR/$con_found_lib_dir])],
                      [AS_VAR_SET([$2], [-L$CON_LIB_DIR/$con_found_lib_dir])])],
               [AS_IF([test "x$2" = "x" ],
                      [_con_outlib="`echo $1 | tr a-z A-Z | sed 's/$/_LIB_DIR/'`";
                       AS_VAR_SET([$_con_outlib], [-L$CON_LIB_DIR/$con_found_lib_dir])],
                      [AS_VAR_SET([$2], [-L$CON_LIB_DIR/$con_found_lib_dir])])])])
  AC_MSG_CHECKING([for $1 include directories])
  con_found_inc_dir="`ls $CON_INC_DIR | grep $1 | head -n 1`"
  AS_IF([test "x$con_found_inc_dir" = "x" ],
        [AC_MSG_FAILURE([could not locate includedir for $1])],
        [AC_MSG_RESULT([$con_found_inc_dir])
         AS_IF([test "x$config_script" = "x"],
               [AS_IF([test "x$3" = "x" ],
                      [_con_outlib="`echo $1 | tr a-z A-Z | sed 's/$/_INC_DIR/'`";
                       AS_VAR_SET([$_con_outlib], [-I$CON_INC_DIR/$con_found_inc_dir])],
                      [AS_VAR_SET([$3], [-I$CON_INC_DIR/$con_found_inc_dir])])],
               [AS_IF([test "x$3" = "x" ],
                      [_con_outlib="`echo $1 | tr a-z A-Z | sed 's/$/_INC_DIR/'`";
                       AS_VAR_SET([$_con_outlib], ["`$config_script --includes --cflags 2>/dev/null || $config_script --includes`"])],
                      [AS_VAR_SET([$3], ["`config_script --includes --cflags 2>/dev/null || $config_script --includes`"])])])])
  AC_MSG_CHECKING([for $1 libs])
  con_found_lib_dir="`ls $CON_LIB_DIR | grep $1 | head -n 1`"
  AS_IF([test "x$con_found_lib_dir" = "x" ],
        [AC_MSG_FAILURE([could not locate libs for $1])],
        [AS_IF([test "x$config_script" = "x"],
               [AS_IF([test "x$4" = "x" ],
                      [_con_outlib="`echo $1 | tr a-z A-Z | sed 's/$/_LIBS/'`";
                       con_temp_libs="";0
                       for fname in `ls $CON_LIB_DIR/$con_found_lib_dir/*.a`; do
                         con_temp_linkflag=`basename $fname | sed 's/^lib/-l/' | sed 's/\.a//'`;
                         con_temp_libs="$con_temp_libs $con_temp_linkflag";
                       done
                       AS_VAR_SET([$_con_outlib], ["$con_temp_libs"])],
                      [con_temp_libs="";
                       for fname in `ls $CON_LIB_DIR/$con_found_lib_dir/*.a`; do
                         con_temp_linkflag=`basename $fname | sed 's/^lib/-l/' | sed 's/\.a//'`;
                         con_temp_libs="$con_temp_libs $con_temp_linkflag";
                       done
                       AS_VAR_SET([$4], ["$con_temp_libs"])])],
               [AS_IF([test "x$4" = "x" ],
                      [_con_outlib="`echo $1 | tr a-z A-Z | sed 's/$/_LIBS/'`";
                       AS_VAR_SET([$_con_outlib], ["`$config_script --link-libtool --libs 2>/dev/null || $config_script --libs`"])],
                      [AS_VAR_SET([$4], ["`$config_script --link-libtool --libs 2>/dev/null || $config_script --libs`"])])])])
  ])

AC_DEFUN([CON_PROJ_DEP], [
  AC_REQUIRE([CON_FIND_DEP_BASE])
  AC_REQUIRE([AC_PROG_SED])
  AC_REQUIRE([AC_PROG_GREP])
  pushdef([UP], patsubst(patsubst(translit([$1], [a-z], [A-Z]),-,_),\.,_))dnl
  pushdef([DOWN], patsubst(patsubst(translit([$1], [A-Z], [a-z]),-,_),\.,_))dnl
  AC_ARG_WITH(DOWN[]-libdir,
              [AS_HELP_STRING([--with-]DOWN[-libdir=DIR],
                              [directory where $1 is installed])],
              DOWN[]_libdir="$withval",
              DOWN[]_libdir="")
  AC_ARG_WITH(DOWN-includedir,
              [AS_HELP_STRING([--with-]DOWN[-includedir=DIR],
                              [directory to the headers for $1])],
              DOWN[]_includedir="$withval",
              DOWN[]_includedir="")
  AC_ARG_WITH(DOWN-libs,
              [AS_HELP_STRING([--with-]DOWN[-libs=DIR],
                              [library link flags for $1])],
              DOWN[]_libs="$withval",
              DOWN[]_libs="")
  AC_ARG_VAR(UP[]_LIB_DIR, [Library directory for $1])
  AC_ARG_VAR(UP[]_INC_DIR, [include directory for $1])
  AC_ARG_VAR(UP[]_LIBS, [Library flags for $1])
  CON_FIND_DEP_DIRS([$1], UP[]_TEMP_LIB_DIR, UP[]_TEMP_INC_DIR, UP[]_TEMP_LIBS)
  AS_IF([test x$DOWN[]_libdir = x],
        [AS_VAR_COPY(UP[]_LIB_DIR, UP[]_TEMP_LIB_DIR)],
        [AS_VAR_SET(UP[]_LIB_DIR, $DOWN[]_libdir)])
  AC_SUBST(UP[]_LIB_DIR)
  AS_IF([test x$DOWN[]_libs = x],
        [AS_VAR_COPY(UP[]_LIBS, UP[]_TEMP_LIBS)],
        [AS_VAR_SET(UP[]_LIBS, $DOWN[]_libs)])
  AC_SUBST(UP[]_LIBS)
  AS_IF([test x$DOWN[]_includedir = x],
        [AS_VAR_COPY(UP[]_INC_DIR, UP[]_TEMP_INC_DIR)],
        [AS_VAR_SET(UP[]_INC_DIR, $DOWN[]_includedir)])
  AC_SUBST(UP[]_INC_DIR)
])

AC_DEFUN([CON_PROJ_DEPLIST], [
  m4_foreach_w([dep], [$1], [CON_PROJ_DEP(dep)])])



