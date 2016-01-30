class Gridcoin < Formula
  desc "GridCoin OS X client (GUI and CLI)"
  homepage "http://gridcoin.us"
  head "https://github.com/gridcoin/Gridcoin-Research.git", :revision => 'd2e1e15b3ec6e'

  option "with-cli", "Also compile the command line client"
  option "without-gui", "Do not compile the graphical client"

  depends_on 'boost'
  depends_on 'berkeley-db4'
  depends_on 'insecure-openssl'
  depends_on 'miniupnpc'
  depends_on 'libzip'
  depends_on 'pkg-config' => :build
  depends_on 'qrencode'
  depends_on 'nossl-qt'

  head do
    # patch gridcoinresearch.pro
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
diff --git a/gridcoinresearch.pro b/gridcoinresearch.pro
index 2e32a31..aeeb803 100644
--- a/gridcoinresearch.pro
+++ b/gridcoinresearch.pro
@@ -421,6 +421,8 @@ macx:QMAKE_LFLAGS_THREAD += -pthread
 macx:QMAKE_CXXFLAGS_THREAD += -pthread
 macx:QT -= qaxcontainer axserver widgets
 macx:CONFIG -= qaxcontainer
+macx:CONFIG += link_pkgconfig
+macx:PKGCONFIG += libzip
 
 # Set libraries and includes at end, to use platform-defined defaults if not overridden
 INCLUDEPATH += $$BOOST_INCLUDE_PATH $$BDB_INCLUDE_PATH $$OPENSSL_INCLUDE_PATH $$QRENCODE_INCLUDE_PATH $$CURL_INCLUDE_PATH $$LIBZIP_INCLUDE_PATH
