class LimesdrSuite < Formula
  # weird name to avoid conflicts with Pothos project
  desc "Driver and GUI for LMS7002M-based SDR platforms (LimeSDR)."
  homepage "https://wiki.myriadrf.org/Lime_Suite"
  url "https://github.com/myriadrf/LimeSuite/archive/v19.01.0.tar.gz"
  sha256 "06bc5cb40ae5ebcf7104a02d73864bb1526fd3f86d58f38f3d419b38ed52761e"
  head "https://github.com/myriadrf/LimeSuite.git"

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  def install
    args = %W[
      -DCMAKE_BUILD_TYPE=Release
    ]

    mkdir "build" do
      system "cmake", "-G", "Ninja", "..", *(std_cmake_args + args)
      system "ninja"
      system "ninja", "install"
    end
  end

end
