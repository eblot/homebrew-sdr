class Libad9361 < Formula
  desc "IIO AD9361 library for filter design and handling, multi-chip sync, etc."
  homepage "https://wiki.analog.com/software/linux/docs/iio/iio"
  url "https://github.com/analogdevicesinc/libad9361-iio/archive/v0.2.tar.gz"
  sha256 "f0d935eb7f70fde8596d98e9eb1f311b408b87662fc1fff45ae3ed455697b747"
  head "https://github.com/analogdevicesinc/libad9361-iio.git"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "eblot/sdr/libiio"

  def install
    libiio = Formulary.factory 'eblot/sdr/libiio'

    mktemp do
      if !(build.head?)
        inreplace  buildpath/"CMakeLists.txt",
                   "include(FindGit OPTIONAL)",
                   "SET(FindGit)"
      end
      inreplace  buildpath/"CMakeLists.txt",
                 "FRAMEWORK DESTINATION lib",
                 "FRAMEWORK DESTINATION ."

      system "cmake", "-G", "Ninja", buildpath, "-DOSX_PACKAGE=OFF",
             "-DCMAKE_FRAMEWORK_PATH=#{libiio.opt_prefix}",
             *std_cmake_args
      system "ninja"
      system "cmake", "--build", ".", "--target", "install"
    end
  end

end
