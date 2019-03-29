class Gqrx < Formula
  desc "Open source software defined radio"
  homepage "http://gqrx.dk"
  url "https://github.com/csete/gqrx/archive/v2.11.5.tar.gz"
  sha256 "5a15d8eb863f68a8590d27ebb2f50e735e814b1651de86952a7e425a68476d9d"
  # head "https://github.com/csete/gqrx.git"
  head "file:///Users/eblot/Sources/Git/sdr/gqrx", :using => :git, :branch => "gr3.8"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "qt5"
  depends_on "python"
  depends_on "portaudio"
  depends_on "eblot/sdr/gnuradio"
  depends_on "eblot/sdr/gr-osmosdr"

  def install
    python = Formulary.factory 'python'
    args = %W[
      -DPYTHON_EXECUTABLE=#{python.bin}/python3
    ]
    mkdir "build" do
      system "cmake", "-G", "Ninja", "..", *(std_cmake_args + args)
      system "ninja"
      system "ninja", "install"
    end
  end

end
