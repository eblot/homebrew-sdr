class GrIio < Formula
  desc "Osmocom GNU Radio Blocks"
  homepage "https://github.com/analogdevicesinc/gr-iio"
  head "https://github.com/eblot/gr-iio.git", :branch => "gr3.8-py3"

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "ninja" => :build
  depends_on "boost" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "flex" => :build
  depends_on "bison" => :build
  depends_on "python"
  depends_on "gmp"
  depends_on "mpir"
  depends_on "eblot/sdr/gnuradio"
  depends_on "eblot/sdr/libiio"
  depends_on "eblot/sdr/libad9361"
  depends_on "log4cpp"
  depends_on "swig"

  resource "Cheetah3" do
    url "https://files.pythonhosted.org/packages/d8/49/25d1d310c274433e1bc82736483f2c57f870688deddb0c56f296dcfe36f7/Cheetah3-3.2.1.tar.gz"
    sha256 "685f961d2761e140bfea67156a013313acda66a229edc6c8708b71d9080ece9c"
  end

  # TODO:
  #   * fix installation path (iio/iio is likely wrong)
  #   * library version (version number do not exist, so lib is *uio....dylib)

  def install
    python = Formulary.factory 'python'
    libad9361 = Formulary.factory 'eblot/sdr/libad9361'
    pyver = 'python3.7'

    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/#{pyver}/site-packages"
    ENV.append "CXXFLAGS", "-std=c++11"

    resource("Cheetah3").stage do
      system "#{python.bin}/#{pyver}", *Language::Python.setup_install_args(libexec/"vendor")
    end

    args = %W[
      -DPYTHON_EXECUTABLE=#{python.bin}/python3
      -DAD9361_INCLUDE_DIRS=#{libad9361.prefix}/ad9361.framework/Headers
      -DAD9361_LIBRARIES=#{libad9361.prefix}/ad9361.framework
    ]

    mkdir "build" do
      system "cmake", "-G", "Ninja", buildpath, *(std_cmake_args + args)
      system "ninja"
      system "ninja", "install"
    end
  end
end
