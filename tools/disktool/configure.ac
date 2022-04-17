AC_INIT([cpos-disktool], [1.0])
AC_CONFIG_MACRO_DIRS([m4])

AM_INIT_AUTOMAKE([-Wall -Werror foreign subdir-objects])

AX_CXX_COMPILE_STDCXX_17
AC_PROG_CXX
AC_PROG_CC

PKG_CHECK_MODULES([GTKMM], [gtkmm-3.0 >= 3.24.2])
PKG_CHECK_MODULES([GLIBMM], [glibmm-2.4 >= 2.64.2])
PKG_CHECK_MODULES([SIGCPP], [sigc++-2.0 >= 2.10.4])
PKG_CHECK_MODULES([UDISK2], [udisks2 >= 2.9.2])
PKG_CHECK_MODULES([GTEST], [gtest >= 1.10.0])
PKG_CHECK_MODULES([CURLPP], [curlpp >= 0.8.1])
PKG_CHECK_MODULES([TINYXML2], [tinyxml2 = 8.0.0])

AC_SUBST(GLIB_COMPILE_RESOURCES, [`$PKG_CONFIG --variable=glib_compile_resources gio-2.0`])

AC_CONFIG_FILES([
 Makefile
 src/Makefile
 tests/Makefile
])
AC_OUTPUT
