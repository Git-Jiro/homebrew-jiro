class Gridcoin < Formula
  desc "GridCoin OS X client (GUI and CLI)"
  homepage "http://gridcoin.us"
  head "https://github.com/gridcoin/Gridcoin-Research.git", :revision => '733c1078253e4e17'

  option "with-cli", "Also compile the command line client"
  option "without-gui", "Do not compile the graphical client"

  depends_on 'boost'
  depends_on 'berkeley-db4'
  depends_on 'insecure-openssl'
  depends_on 'miniupnpc'
  depends_on 'libzip'
  depends_on 'pkg-config' => :build
  depends_on 'qrencode'
  depends_on 'qt'

  head do
    # patch gridcoinstake.pro, makefile.osx
    patch :DATA
  end

  def install

    if build.with? 'cli'
      chmod 0755, "src/leveldb/build_detect_platform"
      mkdir_p "src/obj/zerocoin"
      system "make", "-C", "src", "-f", "makefile.osx", "USE_UPNP=-"
      bin.install "src/gridcoinresearchd"
    end

    if build.with? 'gui'
      system "qmake", "USE_UPNP=-"
      system "make"
      prefix.install "gridcoinresearch.app"
    end


  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test Gridcoin`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end

__END__
diff --git a/gridcoinstake.pro b/gridcoinstake.pro
index c8f93f7..cce0ec8 100644
--- a/gridcoinstake.pro
+++ b/gridcoinstake.pro
@@ -418,6 +418,8 @@ macx:QMAKE_LFLAGS_THREAD += -pthread
 macx:QMAKE_CXXFLAGS_THREAD += -pthread
 macx:QT -= qaxcontainer axserver widgets
 macx:CONFIG -= qaxcontainer
+macx:CONFIG += link_pkgconfig
+macx:PKGCONFIG += libzip
 
 # Set libraries and includes at end, to use platform-defined defaults if not overridden
 INCLUDEPATH += $$BOOST_INCLUDE_PATH $$BDB_INCLUDE_PATH $$OPENSSL_INCLUDE_PATH $$QRENCODE_INCLUDE_PATH $$CURL_INCLUDE_PATH $$LIBZIP_INCLUDE_PATH
diff --git a/src/makefile.osx b/src/makefile.osx
index ac61a77..8afb2ba 100644
--- a/src/makefile.osx
+++ b/src/makefile.osx
@@ -43,6 +43,7 @@ LIBS += \
  -lboost_thread-mt \
  -lssl \
  -lcrypto \
+ -lcurl \
  -lz
 endif
 
@@ -59,7 +60,7 @@ endif
 
 # ppc doesn't work because we don't support big-endian
 CFLAGS += -Wall -Wextra -Wformat -Wno-ignored-qualifiers -Wformat-security -Wno-unused-parameter \
-    $(DEBUGFLAGS) $(DEFS) $(INCLUDEPATHS)
+    $(DEBUGFLAGS) $(DEFS) $(INCLUDEPATHS) $(shell pkg-config --cflags --libs libzip)
 
 OBJS= \
     obj/alert.o \
@@ -95,7 +96,8 @@ OBJS= \
     obj/scrypt.o \
     obj/scrypt-x86.o \
     obj/scrypt-x86_64.o \
-    obj/cpid.o 
+    obj/cpid.o \
+    obj/upgrader.o 
 
 ifndef USE_UPNP
 	override USE_UPNP = -
