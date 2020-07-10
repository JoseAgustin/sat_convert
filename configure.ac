#                                               -*- Autoconf -*-
#
# This is the autoconf configuration file for Sateliteconvert
# Process this file with autoconf to produce a configure script.
#
# To produce files: configure, Makefiles and Scripts
#    $ automake
#    $ autoconf
#
# Eventually, if you receive errors, you need to regenerate
# file aclocal.m4 with the command:
#    $ autoreconf
#  or
#    $ aclocal
#    $ autoconf
#

AC_PREREQ([2.69])
AC_INIT([Sat_conversion], [1.0], [agustin@atmosfera.unam.mx])
AC_CONFIG_AUX_DIR([autoconf])
AM_INIT_AUTOMAKE([1.16.2 foreign])
# Set default prefix (where directory bin is created)
# This is the default top directory of the installation

AC_PREFIX_DEFAULT(`pwd`)
# Checks for programs.

# Set language for configuration checks
AC_LANG(Fortran)
AC_PROG_FC
# Checks for programs.

# Checks for libraries.

# Checks for header files.

# Checks for typedefs, structures, and compiler characteristics.
# Set single precision (default r8)
AC_ARG_WITH([r4],
  [AS_HELP_STRING([--with-r4],[Compile in single precision (R4)])],
  [with_r4=yes],[with_r4=no])
AM_CONDITIONAL([WITH_R4], [test $with_r4 = yes])
# Checks for library functions.

AC_CONFIG_FILES([Makefile])

AC_OUTPUT
# Write configuration on the screen
AC_MSG_NOTICE([---------------------------------------------------------])
AC_MSG_NOTICE([Configuration complete - $PACKAGE_NAME-$PACKAGE_VERSION $MSG_PARALLEL])
AC_MSG_NOTICE([])
#
AC_MSG_NOTICE([Single precision:           --with-r4=$with_r4])
AC_MSG_NOTICE([Fortran compiler:           FC=$FC])
#
AC_MSG_NOTICE([Install prefix:             --prefix=$prefix])
AC_MSG_NOTICE([Executables install prefix: --exec_prefix=$exec_prefix])
AC_MSG_NOTICE([Binary directory:           --bindir=$bindir])
#
AC_MSG_NOTICE([---------------------------------------------------------])
