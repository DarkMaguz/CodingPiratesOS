AC_INIT([mastermind], [1.0])

AM_INIT_AUTOMAKE([-Wall -Werror foreign subdir-objects])

AC_PROG_CXX
AC_PROG_CC

PKG_CHECK_MODULES([GTKMM], [gtkmm-3.0 >= 3.24.2])
PKG_CHECK_MODULES([GTEST], [gtest >= 1.10.0])
PKG_CHECK_MODULES([SICPP], [sigc++-2.0 >= 2.10.4])

AC_CONFIG_FILES([
 Makefile
 src/Makefile
])
AC_OUTPUT
