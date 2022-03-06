class Gridcoin < Formula
  desc "OS X client (GUI and CLI)"
  homepage "https://gridcoin.us/"
  license "MIT"

  stable do
    url "https://github.com/gridcoin-community/Gridcoin-Research/archive/5.3.3.0.tar.gz"
    sha256 "45c80a24a289c5488df8cf3fdc713b19679a9a248de75227b552d72321ac0ed7"

    patch <<-EOS
      diff --git a/configure.ac b/configure.ac
      index eb96af9c..8b692612 100644
      --- a/configure.ac
      +++ b/configure.ac
      @@ -829,5 +823,5 @@
       if test x$use_boost = xyes; then

      -BOOST_LIBS="$BOOST_LDFLAGS $BOOST_SYSTEM_LIB $BOOST_FILESYSTEM_LIB $BOOST_IOSTREAMS_LIB $BOOST_THREAD_LIB $BOOST_ZLIB_LIB"
      +BOOST_LIBS="$BOOST_LDFLAGS $BOOST_SYSTEM_LIB $BOOST_FILESYSTEM_LIB $BOOST_IOSTREAMS_LIB $BOOST_THREAD_LIB $BOOST_ZLIB_LIB -lboost_system-mt"


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

  head do
    url "https://github.com/gridcoin/Gridcoin-Research.git", branch: "development"

    def caveats
      <<~EOS
        --HEAD uses Gridcoin's development branch.
        Please refer to https://github.com/gridcoin/Gridcoin-Research/blob/master/README.md for Gridcoin's branching strategy
      EOS
    end
  end

  option "without-upnp", "Do not compile with UPNP support"
  option "with-cli", "Also compile the command line client"
  option "without-gui", "Do not compile the graphical client"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "librsvg" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "berkeley-db@4"
  depends_on "boost"
  depends_on "leveldb"
  depends_on "libzip"
  depends_on "miniupnpc"
  depends_on "openssl@1.1"
  depends_on "qt@5"

  depends_on "qrencode" => :recommended

  def install
    config_args = %w[
    ]
    config_args << "--without-qrencode" if build.without? "qrencode"

    make_use_upnp = build.with?("upnp") ? "1" : "-"
    make_use_qrcode = build.with?("qrencode") ? "1" : "0"

    system "cd src ; ../contrib/nomacro.pl"

    system "./autogen.sh"
    ENV.delete "OBJCXX"
    system "./configure", *config_args
    system "make", "NO_UPGRADE=1", "USE_UPNP=#{make_use_upnp}", "USE_QRCODE=#{make_use_qrcode}"
    system "make", "check"

    bin.install "src/gridcoinresearchd" if build.with? "cli"

    if build.with? "gui"
      system "make", "appbundle"
      prefix.install "Gridcoin.app"
    end
  end

  test do
    system bin/"gridcoinresearchd", "-version" if build.with? "cli"

    # Currently help is the only flag which does not actually start the gui
    system prefix/"Gridcoin.app/Contents/MacOS/gridcoinresearch", "-?" if build.with? "gui"
  end
end
