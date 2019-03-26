class PothosLime < Formula
  desc "Pothos for Lime"
  head "https://github.com/pothosware/PothosCore.git"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pyqt5"
  depends_on "portaudio"
  depends_on "qwt"
  depends_on "audiofilter/spuc/spuce"

  def install
    mktemp do
      system "cmake", "-G", "Ninja", buildpath, *std_cmake_args
      system "ninja"
      system "ninja", "install"
    end
  end
end
