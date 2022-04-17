bin_PROGRAMS = disktool

EXTRA_CFLAGS = -DGTKMM_DISABLE_DEPRECATED=1 -DGIOMM_DISABLE_DEPRECATED=1 -DSIGPP_DISABLE_DEPRECATED=1 -Wdeprecated-declarations

disktool_SOURCES = main.cpp MainWindow.cpp DriveTool.cpp DriveTreeView.cpp DriveDetailBox.cpp DriveInfo.cpp DriveAssistant.cpp AssistantPage.cpp AssistantSourcePage.cpp WebWorker.cpp AssistantConfigPage.cpp AssistantProgressPage.cpp AssistantConfirmPage.cpp AssistantSummaryPage.cpp ImageDownloader.cpp
disktool_CPPFLAGS = $(GTKMM_CFLAGS) $(GLIBMM_CFLAGS) $(SIGCPP_CFLAGS) $(UDISK2_CFLAGS) $(CURLPP_CFLAGS) $(TINYXML2_CFLAGS) $(EXTRA_CFLAGS)
disktool_LDADD = $(GTKMM_LIBS) $(GLIBMM_LIBS) $(SIGCPP_LIBS) $(UDISK2_LIBS) $(CURLPP_LIBS) $(TINYXML2_LIBS) -lpthread

#noinst_PROGRAMS = test
#test_SOURCES = test.cpp ImageDownloader.cpp
#test_CPPFLAGS = $(GTEST_CFLAGS) $(CURLPP_CFLAGS)
#test_LDADD = $(GTEST_LIBS) $(CURLPP_LIBS)

#noinst_LTLIBRARIES = libid.la
#libid_la_SOURCES = ImageDownloader.cpp
#libid_la_CPPFLAGS = $(CURLPP_CFLAGS)
#libid_la_LIBADD = -lpthread

gsettings_SCHEMAS = org.cpos.disktool.gschema.xml

#@GSETTINGS_RULES@

GLADE_FILES = ui/Toolbar.glade ui/DriveDetailBox.glade ui/AssistPageSource.glade ui/AssistPageConfig.glade ui/AssistPageConfirm.glade ui/AssistPageProgress.glade ui/AssistPageSummary.glade

nodist_disktool_SOURCES = ui_resources.c
dist_noinst_DATA = ui.gresource.xml $(GLADE_FILES)
DISTCLEANFILES = ui_resources.c

ui_resources.c: ui.gresource.xml $(GLADE_FILES)
	$(AM_V_GEN) $(GLIB_COMPILE_RESOURCES) --target=$@ --generate-source $<
