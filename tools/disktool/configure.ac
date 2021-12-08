AC_INIT([mastermind], [1.0])

AM_INIT_AUTOMAKE([-Wall -Werror foreign subdir-objects])

AC_PROG_CXX
AC_PROG_CC

PKG_CHECK_MODULES([GTKMM], [gtkmm-3.0 >= 3.24.2])
PKG_CHECK_MODULES([GLIBMM], [glibmm-2.4 >= 2.64.2])
# PKG_CHECK_MODULES([SICPP], [sigc++-2.0 >= 2.10.4])
PKG_CHECK_MODULES([BLKID], [blkid >= 2.36.1])
PKG_CHECK_MODULES([PARTED], [libparted = 3.4])
PKG_CHECK_MODULES([GTEST], [gtest >= 1.10.0])

AC_SUBST(GLIB_COMPILE_RESOURCES, [`$PKG_CONFIG --variable=glib_compile_resources gio-2.0`])

AC_CONFIG_FILES([
 Makefile
 src/Makefile
])
AC_OUTPUT
