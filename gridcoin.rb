# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                /opt/boxen/homebrew/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Gridcoin < Formula
  desc "GridCoin OS X client (GUI and CLI)"
  homepage "gridcoin.us"
  #url "https://github.com/gridcoin/Gridcoin-Research.git", :using => :git, :revision => '700c507'
  #url "https://github.com/Git-Jiro/Gridcoin-Research.git", :using => :git, :revision => '92333', :branch => 'Fix-makefile.osx'
  url "https://github.com/Git-Jiro/Gridcoin-Research.git", :using => :git, :revision => '457abd8' , :branch => 'create_brew_recipe'
  #version "3.4.0.5"
  #sha256 ""

  option "with-cli", "Also compile the command line client"
  option "without-gui", "Do not compile the graphical client"

  depends_on 'boost'
  depends_on 'berkeley-db4'
  depends_on 'insecure-openssl'
  depends_on 'miniupnpc'
  depends_on 'libzip'
  depends_on 'pkg-config'
  depends_on 'qrencode'
  depends_on 'qt'

  stable do
    # patch gridcoinstake.pro
    patch :DATA
  end

  def install

    if build.with? 'cli'
      system "chmod", "+x", "src/leveldb/build_detect_platform"
      system "mkdir", "-p", "src/obj/zerocoin"
      system "make", "-C", "src", "-f", "makefile.osx", "USE_UPNP=-"
      bin.install "src/gridcoinresearchd"
    end

    if build.with? 'gui'
      system "qmake", "USE_UPNP=-"
      system "make"
      bin.install "gridcoinresearch.app"
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
 #  INCLUDEPATH += $$BOOST_INCLUDE_PATH $$BDB_INCLUDE_PATH $$OPENSSL_INCLUDE_PATH $$QRENCODE_INCLUDE_PATH $$CURL_INCLUDE_PATH $$LIBZIP_INCLUDE_PATH
