class Libiio < Formula
  desc "Library for interfacing with IIO devices."
  homepage "https://wiki.analog.com/software/linux/docs/iio/iio"
  url "https://github.com/analogdevicesinc/libiio/archive/v0.18.tar.gz"
  sha256 "bc2c5299974b65cfe9aa4a06d8c74d7651594e026bce416db48a2c5aa7ba2554"
  head "https://github.com/analogdevicesinc/libiio.git"

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  patch do
    # use find_library to locate Framework library
    url "https://github.com/eblot/libiio/commit/3c8e9c23e149b4a4cace9fb78d50e9a7d67a6072.patch"
    sha256 "e8e04f7e54a70472cdebdccbef7b77904e74151fed4ad26bb388918fda7ed1ed"
  end

  def install
    mktemp do
      inreplace buildpath/"CMakeLists.txt",
                "FRAMEWORK DESTINATION /Library/Frameworks",
                "FRAMEWORK DESTINATION #{prefix}"
      inreplace buildpath/"tests/CMakeLists.txt",
                "RUNTIME DESTINATION /Library/Frameworks/iio.framework/Tools",
                "RUNTIME DESTINATION #{prefix}/iio.framework/Tools"

      system "cmake", "-G", "Ninja", buildpath, "-DOSX_PACKAGE=OFF",
             *std_cmake_args
      system "ninja"
      system "cmake", "--build", ".", "--target", "install"
    end
  end

end
