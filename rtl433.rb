class Rtl433 < Formula
  desc "Program to decode traffic from Devices that are broadcasting on 433MHz"
  homepage "https://github.com/merbanan/rtl_433"
  url "https://github.com/merbanan/rtl_433/archive/19.08.tar.gz"
  head "https://github.com/merbanan/rtl_433.git"
  version "19.08"
  sha256 "6d7975e8e08e724a30fe0c8658e156fe0e67299a9fddfa14daed5f62c625731f"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "rtl-sdr"
  depends_on "libusb"

  def install
    mktemp do
      system "cmake", "-G", "Ninja", buildpath, *std_cmake_args
      system "ninja"
      system "ninja", "install"
    end
  end
end
