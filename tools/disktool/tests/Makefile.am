noinst_PROGRAMS = test

test_SOURCES = test.cpp ../src/ImageDownloader.cpp
test_CPPFLAGS = $(GTEST_CFLAGS) $(CURLPP_CFLAGS) -I../src/
test_LDADD = $(GTEST_LIBS) $(CURLPP_LIBS)