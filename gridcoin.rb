class Gridcoin < Formula
  desc "OS X client (GUI and CLI)"
  homepage "https://gridcoin.us/"
  url "https://github.com/gridcoin/Gridcoin-Research/archive/3.7.3.0.tar.gz"
  version "3.7.3.0"
  sha256 "8183109280dbe82ae78a40a579298d4e60b0c66569a681a9ae8938d685962e2a"
  head "https://github.com/gridcoin/Gridcoin-Research.git", :branch => "development"

  def caveats
    s = ""
    s += "--HEAD uses Gridcoin's development branch.\n"
    s += "--devel uses Gridcoin's staging branch.\n"
    s += "Please refer to https://github.com/gridcoin/Gridcoin-Research/blob/master/README.md for Gridcoin's branching strategy\n"
    s
  end

  stable do
    patch <<-EOS.undent
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
      @@ -18,6 +18,10 @@
       #include <boost/algorithm/string/case_conv.hpp> // for to_lower()
       #include <fstream>
      
      +#ifndef BYTE
      +typedef unsigned char BYTE;
      +#endif
      +
       using namespace json_spirit;
       using namespace std;
       extern std::string YesNo(bool bin);
      diff --git a/src/rpcwallet.cpp b/src/rpcwallet.cpp
      index c9349625..67d79de7 100644
      --- a/src/rpcwallet.cpp
      +++ b/src/rpcwallet.cpp
      @@ -1062,7 +1062,7 @@ Value ListReceived(const Array& params, bool fByAccounts)
                   obj.push_back(Pair("account",       strAccount));
                   obj.push_back(Pair("amount",        ValueFromAmount(nAmount)));
                   obj.push_back(Pair("confirmations", (nConf == std::numeric_limits<int>::max() ? 0 : nConf)));
      -            obj.push_back(Pair("tx_count", (*it).second.sContracts.size()));
      +            obj.push_back(Pair("tx_count", (int)(*it).second.sContracts.size()));
       
                   // Add support for contract or message information appended to the TX itself
                   Object oTX;
    EOS
  end

  devel do
    url "https://github.com/gridcoin/Gridcoin-Research.git", :using => :git, :branch => "staging"
    version "3.7.3.0-dev"
    patch <<-EOS.undent
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
      @@ -18,6 +18,10 @@
       #include <boost/algorithm/string/case_conv.hpp> // for to_lower()
       #include <fstream>
      
      +#ifndef BYTE
      +typedef unsigned char BYTE;
      +#endif
      +
       using namespace json_spirit;
       using namespace std;
       extern std::string YesNo(bool bin);
      diff --git a/src/rpcwallet.cpp b/src/rpcwallet.cpp
      index c9349625..67d79de7 100644
      --- a/src/rpcwallet.cpp
      +++ b/src/rpcwallet.cpp
      @@ -1062,7 +1062,7 @@ Value ListReceived(const Array& params, bool fByAccounts)
                   obj.push_back(Pair("account",       strAccount));
                   obj.push_back(Pair("amount",        ValueFromAmount(nAmount)));
                   obj.push_back(Pair("confirmations", (nConf == std::numeric_limits<int>::max() ? 0 : nConf)));
      -            obj.push_back(Pair("tx_count", (*it).second.sContracts.size()));
      +            obj.push_back(Pair("tx_count", (int)(*it).second.sContracts.size()));
       
                   // Add support for contract or message information appended to the TX itself
                   Object oTX;
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

      system "qmake", "USE_QRCODE=1", "NO_UPGRADE=1", "USE_UPNP=#{upnp_build_var}", *args
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
