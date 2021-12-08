bin_PROGRAMS = disktool
#test

nodist_disktool_SOURCES = ui_resources.c
dist_noinst_DATA = ui.gresource.xml ui.xml
DISTCLEANFILES = ui_resources.c

ui_resources.c: ui.gresource.xml ui.xml
	$(AM_V_GEN) $(GLIB_COMPILE_RESOURCES) --target=$@ --generate-source $<

disktool_SOURCES = main.cpp MainWindow.cpp DiskTool.cpp
disktool_CPPFLAGS = $(GTKMM_CFLAGS) -DGTKMM_DISABLE_DEPRECATED=1 $(PARTED_CFLAGS)
disktool_LDADD = $(GTKMM_LIBS) $(BLKID_LIBS) $(PARTED_LIBS)

# test_SOURCES = test.cpp MasterMind.cpp
# test_CPPFLAGS = $(GTEST_CFLAGS) $(SICPP_CFLAGS)
# test_LDADD = $(GTEST_LIBS) $(SICPP_LIBS)
