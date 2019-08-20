class Gqrx < Formula
  desc "Open source software defined radio"
  homepage "http://gqrx.dk"
  # pristine tarballs are too old
  head "https://github.com/eblot/gqrx", :using => :git, :branch => "gr3.8-py3-plutosdr"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "qt5"
  depends_on "python"
  depends_on "portaudio"
  depends_on "eblot/sdr/gnuradio"
  depends_on "eblot/sdr/gr-osmosdr"

  # TODO:
  # Fix libraries to link, as for now, the final link fails
  # Add /usr/local/opt/gnuradio/lib/libgnuradio-{runtime,analog,audio,blocks,digital,filter,fft,pmt}.dylib
  #     /usr/local/opt/log4cpp/lib/liblog4cpp.dylib to build gqrx app
  # Waiting for GR feedback on how to retrieve the proper libs from CMake macro

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
