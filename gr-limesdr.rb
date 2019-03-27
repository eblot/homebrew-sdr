class GrLimesdr < Formula
  desc "LimeSDR Plugin for GNURadio"
  homepage "https://wiki.myriadrf.org/Gr-limesdr_Plugin_for_GNURadio"
  url "https://github.com/myriadrf/gr-limesdr/archive/v2.0.0.tar.gz"
  sha256 "466dd049daf32531ed717b6c2daf07881cad27b7ce037c53cb947e5dadd948b8"
  head "https://github.com/myriadrf/gr-limesdr"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python@2"
  depends_on "eblot/sdr/gnuradio"

  def install
    mkdir "build" do
      system "cmake", "-G", "Ninja", "..", *std_cmake_args
      system "ninja"
      system "ninja", "install"
    end
  end

end
