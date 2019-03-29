class PothosLime < Formula
  desc "Pothos for Lime"
  head "https://github.com/pothosware/PothosCore.git"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pyqt5"
  depends_on "portaudio"
  depends_on "qwt"
  depends_on "audiofilter/spuc/spuce"
  depends_on "python"

  def install
    python = Formulary.factory 'python'

    mktemp do
      args = %W[
        -DPYTHON_EXECUTABLE=#{python.bin}/python3
      ]
      system "cmake", "-G", "Ninja", buildpath, *(std_cmake_args + args)
      system "ninja"
      system "ninja", "install"
    end
  end
end
