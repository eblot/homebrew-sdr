class Soapyplutosdr < Formula
  desc "Soapy SDR plugin for PlutoSDR."
  homepage "https://github.com/pothosware/SoapyPlutoSDR"
  head "https://github.com/pothosware/SoapyPlutoSDR.git"
  url "https://github.com/pothosware/SoapyPlutoSDR/archive/soapy-plutosdr-0.1.0.tar.gz"
  sha256 "d468803f603b78fad91e271f6718630a21d591d732349b568b515458a2d67d8d"

  depends_on "soapysdr"
  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "eblot/sdr/libiio"
  depends_on "eblot/sdr/libad9361"

  def install
    libiio = Formulary.factory 'eblot/sdr/libiio'
    libad9361 = Formulary.factory 'eblot/sdr/libad9361'

    mktemp do
      system "cmake", "-G", "Ninja", buildpath,
             "-DCMAKE_FRAMEWORK_PATH=#{libad9361.opt_prefix};#{libiio.opt_prefix}",
             *std_cmake_args
      system "ninja"
      system "cmake", "--build", ".", "--target", "install"
    end
  end

end
