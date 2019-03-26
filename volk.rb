class Volk < Formula
  include Language::Python::Virtualenv

  desc "The Vector Optimized Library of Math Kernels"
  homepage "http://libvolk.org/"
  url "https://github.com/gnuradio/volk/archive/v1.4.tar.gz"
  head "https://github.com/gnuradio/volk.git"
  sha256 "32131ba17846850c07270bc5897dd2de7130ec02ca029875a36966335120e7bf"
  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python@2" => :build

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/eb/69/6137c60cae2ab8c911bff510bb6d1d23a0189f75d114bb277606c6486b5f/Mako-1.0.8.tar.gz"
    sha256 "04092940c0df49b01f43daea4f5adcecd0e50ef6a4b222be5ac003d5d84b2843"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/b9/2e/64db92e53b86efccfaea71321f597fa2e1b2bd3853d8ce658568f7a13094/MarkupSafe-1.1.1.tar.gz"
    sha256 "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    resource("MarkupSafe").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    resource("Mako").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    mktemp do
      system "cmake", "-G", "Ninja", buildpath, *std_cmake_args
      system "ninja"
      system "ninja", "install"
    end
  end

end
