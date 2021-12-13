bin_PROGRAMS = disktool
#test

EXTRA_CFLAGS = -DGTKMM_DISABLE_DEPRECATED=1 -DGIOMM_DISABLE_DEPRECATED=1 -DSIGPP_DISABLE_DEPRECATED=1 

disktool_SOURCES = main.cpp MainWindow.cpp DriveTool.cpp DriveTreeView.cpp DriveDetailBox.cpp DriveInfo.cpp
disktool_CPPFLAGS = $(GTKMM_CFLAGS) $(GLIBMM_CFLAGS) $(SIGCPP_CFLAGS) $(UDISK2_CFLAGS) $(EXTRA_CFLAGS)
disktool_LDADD = $(GTKMM_LIBS) $(GLIBMM_LIBS) $(SIGCPP_LIBS) $(UDISK2_LIBS)

nodist_disktool_SOURCES = ui_resources.c
dist_noinst_DATA = ui.gresource.xml ui.xml
DISTCLEANFILES = ui_resources.c

ui_resources.c: ui.gresource.xml ui.xml
	$(AM_V_GEN) $(GLIB_COMPILE_RESOURCES) --target=$@ --generate-source $<

# test_SOURCES = test.cpp MasterMind.cpp
# test_CPPFLAGS = $(GTEST_CFLAGS) $(SIGCPP_CFLAGS)
# test_LDADD = $(GTEST_LIBS) $(SIGCPP_LIBS)
