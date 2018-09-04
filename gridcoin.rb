class Gridcoin < Formula
  desc "OS X client (GUI and CLI)"
  homepage "https://gridcoin.us/"
  url "https://github.com/gridcoin/Gridcoin-Research/archive/3.7.16.0.tar.gz"
  version "3.7.16.0"
  sha256 "4309ccd75809dd034083c8f40983ce89b2436237afe388bab3d10af4e0936dd6"
  head "https://github.com/gridcoin/Gridcoin-Research.git", :branch => "development"

  def caveats
    s = ""
    s += "--HEAD uses Gridcoin's development branch.\n"
    s += "--devel uses Gridcoin's staging branch.\n"
    s += "Please refer to https://github.com/gridcoin/Gridcoin-Research/blob/master/README.md for Gridcoin's branching strategy\n"
    s
  end

  stable do
    patch <<-EOS
      diff --git a/gridcoinresearch.pro b/gridcoinresearch.pro
      index c53e783e..bdc430fa 100755
      --- a/gridcoinresearch.pro
      +++ b/gridcoinresearch.pro
      @@ -21,6 +21,8 @@
           QT += charts
       }
      
      +QT += charts
      +
       # for boost 1.37, add -mt to the boost libraries
       # use: qmake BOOST_LIB_SUFFIX=-mt
       # for boost thread win32 with _win32 sufix
      diff --git a/src/rpcblockchain.cpp b/src/rpcblockchain.cpp
      index e2826ba..1796de5 100755
      --- a/src/rpcblockchain.cpp
      +++ b/src/rpcblockchain.cpp
      @@ -22,6 +22,9 @@
       #include <fstream>
       #include <algorithm>
      
      +#ifndef BYTE
      +typedef unsigned char BYTE;
      +#endif
      
       bool TallyResearchAverages_v9();
       using namespace json_spirit;
      diff --git a/configure.ac b/configure.ac
      index eb96af9c..8b692612 100644
      --- a/configure.ac
      +++ b/configure.ac
      @@ -57,14 +57,8 @@ AX_CXX_COMPILE_STDCXX([11], [noext], [mandatory], [nodefault])
       dnl Check if -latomic is required for <std::atomic>
       CHECK_ATOMIC
      
      -dnl Unless the user specified OBJCXX, force it to be the same as CXX. This ensures
      -dnl that we get the same -std flags for both.
      -m4_ifdef([AC_PROG_OBJCXX],[
      -if test "x${OBJCXX+set}" = "x"; then
      -  OBJCXX="${CXX}"
      -fi
       AC_PROG_OBJCXX
      -])
      +OBJCXX="${CXX}"
      
       dnl Libtool init checks.
       LT_INIT([pic-only])
      @@ -783,7 +776,7 @@ fi
       
       if test x$use_boost = xyes; then
       
      -BOOST_LIBS="$BOOST_LDFLAGS $BOOST_SYSTEM_LIB $BOOST_FILESYSTEM_LIB $BOOST_PROGRAM_OPTIONS_LIB $BOOST_THREAD_LIB $BOOST_CHRONO_LIB"
      +BOOST_LIBS="$BOOST_LDFLAGS $BOOST_SYSTEM_LIB $BOOST_FILESYSTEM_LIB $BOOST_PROGRAM_OPTIONS_LIB $BOOST_THREAD_LIB $BOOST_CHRONO_LIB -lboost_system-mt"
      
      
       dnl If boost (prior to 1.57) was built without c++11, it emulated scoped enums
      @@ -1171,5 +1165,7 @@ echo "  CFLAGS        = $CFLAGS"
       echo "  CPPFLAGS      = $CPPFLAGS"
       echo "  CXX           = $CXX"
       echo "  CXXFLAGS      = $CXXFLAGS"
      +echo "  OBJCXX        = $OBJCXX"
      +echo "  OBJCXXFLAGS   = $OBJCXXFLAGS"
       echo "  LDFLAGS       = $LDFLAGS"
       echo
    EOS
  end

  devel do
    url "https://github.com/gridcoin/Gridcoin-Research.git", :using => :git, :branch => "staging"
    version "3.7.15.0-dev"
    patch <<-EOS
      diff --git a/gridcoinresearch.pro b/gridcoinresearch.pro
      index c53e783e..bdc430fa 100755
      --- a/gridcoinresearch.pro
      +++ b/gridcoinresearch.pro
      @@ -21,6 +21,8 @@
           QT += charts
       }
      
      +QT += charts
      +
       # for boost 1.37, add -mt to the boost libraries
       # use: qmake BOOST_LIB_SUFFIX=-mt
       # for boost thread win32 with _win32 sufix
      diff --git a/src/rpcblockchain.cpp b/src/rpcblockchain.cpp
      index e2826ba..1796de5 100755
      --- a/src/rpcblockchain.cpp
      +++ b/src/rpcblockchain.cpp
      @@ -22,6 +22,9 @@
       #include <fstream>
       #include <algorithm>
      
      +#ifndef BYTE
      +typedef unsigned char BYTE;
      +#endif
      
       bool TallyResearchAverages_v9();
       using namespace json_spirit;
      diff --git a/configure.ac b/configure.ac
      index eb96af9c..8b692612 100644
      --- a/configure.ac
      +++ b/configure.ac
      @@ -57,14 +57,8 @@ AX_CXX_COMPILE_STDCXX([11], [noext], [mandatory], [nodefault])
       dnl Check if -latomic is required for <std::atomic>
       CHECK_ATOMIC
      
      -dnl Unless the user specified OBJCXX, force it to be the same as CXX. This ensures
      -dnl that we get the same -std flags for both.
      -m4_ifdef([AC_PROG_OBJCXX],[
      -if test "x${OBJCXX+set}" = "x"; then
      -  OBJCXX="${CXX}"
      -fi
       AC_PROG_OBJCXX
      -])
      +OBJCXX="${CXX}"
      
       dnl Libtool init checks.
       LT_INIT([pic-only])
      @@ -1171,5 +1165,7 @@ echo "  CFLAGS        = $CFLAGS"
       echo "  CPPFLAGS      = $CPPFLAGS"
       echo "  CXX           = $CXX"
       echo "  CXXFLAGS      = $CXXFLAGS"
      +echo "  OBJCXX        = $OBJCXX"
      +echo "  OBJCXXFLAGS   = $OBJCXXFLAGS"
       echo "  LDFLAGS       = $LDFLAGS"
       echo
      EOS
  end

  option "without-upnp", "Do not compile with UPNP support"
  option "with-cli", "Also compile the command line client"
  option "without-gui", "Do not compile the graphical client"

  depends_on "boost@1.60"
  depends_on "berkeley-db@4"
  depends_on "leveldb"
  depends_on "openssl"
  depends_on "miniupnpc"
  depends_on "libzip"
  depends_on "pkg-config" => :build
  depends_on "qrencode"
  depends_on "qt"
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "librsvg" => :build

  def install
    if build.with? "upnp"
      upnp_build_var = "1"
    else
      upnp_build_var = "-"
    end

    if build.with? "cli"
      chmod 0755, "src/leveldb/build_detect_platform"
      mkdir_p "src/obj/zerocoin"
      system "make", "-C", "src", "-f", "makefile.osx", "USE_UPNP=#{upnp_build_var}"
      bin.install "src/gridcoinresearchd"
    end

    if build.with? "gui"
      args = %W[
        BOOST_INCLUDE_PATH=#{Formula["boost@1.60"].include}
        BOOST_LIB_PATH=#{Formula["boost@1.60"].lib}
        OPENSSL_INCLUDE_PATH=#{Formula["openssl"].include}
        OPENSSL_LIB_PATH=#{Formula["openssl"].lib}
        BDB_INCLUDE_PATH=#{Formula["berkeley-db@4"].include}
        BDB_LIB_PATH=#{Formula["berkeley-db@4"].lib}
        MINIUPNPC_INCLUDE_PATH=#{Formula["miniupnpc"].include}
        MINIUPNPC_LIB_PATH=#{Formula["miniupnpc"].lib}
        QRENCODE_INCLUDE_PATH=#{Formula["qrencode"].include}
        QRENCODE_LIB_PATH=#{Formula["qrencode"].lib}
      ]

      system "./autogen.sh"
      system "./configure"
      system "make appbundle"
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
