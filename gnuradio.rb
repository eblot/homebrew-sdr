class Gnuradio < Formula
  desc "SDK providing the signal processing runtime and processing blocks"
  homepage "https://gnuradio.org/"
  url "https://github.com/gnuradio/gnuradio/releases/download/v3.8.0.0-rc2/gnuradio-3.8.0.0-rc2.tar.xz"
  sha256 "1c3219a40bc44f22215457585ed57332a2aa63a46342e1231f204fda37d4354a"
  head "https://github.com/gnuradio/gnuradio.git", :tag => "v3.8.0.0-rc2"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "swig" => :build
  depends_on "boost"
  depends_on "fftw"
  depends_on "gsl"
  depends_on "numpy"
  depends_on "portaudio"
  depends_on "libyaml"
  depends_on "mpir"
  depends_on "python"
  depends_on "uhd"
  depends_on "zeromq"
  depends_on "pyqt"
  depends_on "qwt"
  depends_on "freeglut"
  depends_on "log4cpp"
  depends_on "gnome-icon-theme"

  patch :DATA

  # cheetah starts here
  resource "Markdown" do
    url "https://files.pythonhosted.org/packages/51/3f/92f9d2f4a1d5da51e7808a469ab40c6cfdf3ba1013f56abb1f46677a655c/Markdown-3.1.tar.gz"
    sha256 "fc4a6f69a656b8d858d7503bda633f4dd63c2d70cf80abdc6eafa64c4ae8c250"
  end

  resource "Cheetah3" do
    url "https://files.pythonhosted.org/packages/d8/49/25d1d310c274433e1bc82736483f2c57f870688deddb0c56f296dcfe36f7/Cheetah3-3.2.1.tar.gz"
    sha256 "685f961d2761e140bfea67156a013313acda66a229edc6c8708b71d9080ece9c"
  end
  # cheetah ends here

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/7d/29/174d70f303016c58bd790c6c86e6e86a9d18239fac314d55a9b7be501943/lxml-4.3.3.tar.gz"
    sha256 "4a03dd682f8e35a10234904e0b9508d705ff98cf962c5851ed052e9340df3d90"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/b9/2e/64db92e53b86efccfaea71321f597fa2e1b2bd3853d8ce658568f7a13094/MarkupSafe-1.1.1.tar.gz"
    sha256 "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b"
  end

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/eb/69/6137c60cae2ab8c911bff510bb6d1d23a0189f75d114bb277606c6486b5f/Mako-1.0.8.tar.gz"
    sha256 "04092940c0df49b01f43daea4f5adcecd0e50ef6a4b222be5ac003d5d84b2843"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/9f/2c/9417b5c774792634834e730932745bc09a7d36754ca00acf1ccd1ac2594d/PyYAML-5.1.tar.gz"
    sha256 "436bc774ecf7c103814098159fbb84c2715d25980175292c648f2da143909f95"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f8/5c/f60e9d8a1e77005f664b76ff8aeaee5bc05d0a91798afd7f53fc998dbc47/Click-7.0.tar.gz"
    sha256 "5b94b49521f6456670fdb30cd82a4eca9412788a93fa6dd6df72c94d5a8ff2d7"
  end

  resource "click-plugins" do
    url "https://files.pythonhosted.org/packages/5f/1d/45434f64ed749540af821fd7e42b8e4d23ac04b1eda7c26613288d6cd8a8/click-plugins-1.1.1.tar.gz"
    sha256 "46ab999744a9d831159c3411bb0c79346d94a444df9a3a3742e9ed63645f264b"
  end

  resource "cppzmq" do
    url "https://raw.githubusercontent.com/zeromq/cppzmq/46fc0572c5e9f09a32a23d6f22fd79b841f77e00/zmq.hpp"
    sha256 "964031c0944f913933f55ad1610938105a6657a69d1ac5a6dd50e16a679104d5"
  end

  def install
    python = Formulary.factory 'python'
    # python3 -c 'from sys import version_info; print("python%d.%d" % version_info[0:2])'
    pyver = "python3.7"

    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/#{pyver}/site-packages"

    ENV["CHEETAH_INSTALL_WITHOUT_SETUPTOOLS"] = "1"
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    %w[Markdown Cheetah3 MarkupSafe Mako six pyyaml click click-plugins].each do |r|
      resource(r).stage do
        system  "#{python.bin}/#{pyver}", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    begin
      # Fix "ld: file not found: /usr/lib/system/libsystem_darwin.dylib" for lxml
      ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra

      resource("lxml").stage do
        system  "#{python.bin}/#{pyver}", *Language::Python.setup_install_args(libexec/"vendor")
      end
    ensure
      ENV.delete("SDKROOT")
    end

    resource("cppzmq").stage include.to_s

    qwt = Formulary.factory 'qwt'

    args = std_cmake_args + %W[
      -DGR_PKG_CONF_DIR=#{etc}/gnuradio/conf.d
      -DGR_PREFSDIR=#{etc}/gnuradio/conf.d
      -DPYTHON_EXECUTABLE=#{python.bin}/#{pyver}
      -DPC_QWT_LIBRARIES=qwt
      -DPC_QWT_LIBDIR=#{qwt.lib}/qwt.framework
      -DPC_QWT_INCLUDEDIR=#{qwt.lib}/qwt.framework/Headers
    ]

    # -DENABLE_DEFAULT=OFF

    enabled = %w[GR_ANALOG GR_FFT VOLK GR_FILTER GNURADIO_RUNTIME
                 GR_BLOCKS GR_CHANNELS GR_AUDIO GR_QTGUI
                 GR_VOCODER GR_FEC GR_DIGITAL GR_DTV
                 GR_TRELLIS GR_ZEROMQ GR_WAVELET GR_UHD DOXYGEN SPHINX
                 PYTHON GR_UTILS GRC]
    enabled.each do |c|
      args << "-DENABLE_#{c}=ON"
    end

    inreplace "docs/doxygen/Doxyfile.swig_doc.in" do |s|
      s.gsub! /USE_PDFLATEX\s+=\s+YES/, "USE_PDFLATEX = NO"
    end

    mkdir "build" do
      system "cmake", "-G", "Ninja", "..", *args
      system "ninja"
      system "ninja", "install"
    end

    ENV.prepend_create_path "PYTHONPATH", lib/"#{pyver}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", lib/"#{pyver}/dist-packages"

    rm bin.children.reject(&:executable?)
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gnuradio-config-info -v")

    (testpath/"test.c++").write <<~EOS
      #include <gnuradio/top_block.h>
      #include <gnuradio/blocks/null_source.h>
      #include <gnuradio/blocks/null_sink.h>
      #include <gnuradio/blocks/head.h>
      #include <gnuradio/gr_complex.h>

      class top_block : public gr::top_block {
      public:
        top_block();
      private:
        gr::blocks::null_source::sptr null_source;
        gr::blocks::null_sink::sptr null_sink;
        gr::blocks::head::sptr head;
      };

      top_block::top_block() : gr::top_block("Top block") {
        long s = sizeof(gr_complex);
        null_source = gr::blocks::null_source::make(s);
        null_sink = gr::blocks::null_sink::make(s);
        head = gr::blocks::head::make(s, 1024);
        connect(null_source, 0, head, 0);
        connect(head, 0, null_sink, 0);
      }

      int main(int argc, char **argv) {
        top_block top;
        top.run();
      }
    EOS
    system ENV.cxx, "-L#{lib}", "-L#{Formula["boost"].opt_lib}",
           "-lgnuradio-blocks", "-lgnuradio-runtime", "-lgnuradio-pmt",
           "-lboost_system", testpath/"test.c++", "-o", testpath/"test"
    system "./test"

    (testpath/"test.py").write <<~EOS
      from gnuradio import blocks
      from gnuradio import gr

      class top_block(gr.top_block):
          def __init__(self):
              gr.top_block.__init__(self, "Top Block")
              self.samp_rate = 32000
              s = gr.sizeof_gr_complex
              self.blocks_null_source_0 = blocks.null_source(s)
              self.blocks_null_sink_0 = blocks.null_sink(s)
              self.blocks_head_0 = blocks.head(s, 1024)
              self.connect((self.blocks_head_0, 0),
                           (self.blocks_null_sink_0, 0))
              self.connect((self.blocks_null_source_0, 0),
                           (self.blocks_head_0, 0))

      def main(top_block_cls=top_block, options=None):
          tb = top_block_cls()
          tb.start()
          tb.wait()

      main()
    EOS
    system #{python.bin}/#{pyver}, testpath/"test.py"

    cd testpath do
      system "#{bin}/gr_modtool", "newmod", "test"

      cd "gr-test" do
        system "#{bin}/gr_modtool", "add", "-t", "general", "test_ff", "-l",
               "python", "-y", "--argument-list=''", "--add-python-qa",
               "--copyright=brew"
      end
    end
  end
end

__END__
diff --git a/gnuradio-runtime/lib/pmt/CMakeLists.txt b/gnuradio-runtime/lib/pmt/CMakeLists.txt
index c46227e76..a073dee05 100644
--- a/gnuradio-runtime/lib/pmt/CMakeLists.txt
+++ b/gnuradio-runtime/lib/pmt/CMakeLists.txt
@@ -28,6 +28,7 @@ add_library(gnuradio-pmt
 target_link_libraries(gnuradio-pmt
   Boost::boost
   Log4Cpp::log4cpp
+  boost_thread-mt
 )
 
 target_include_directories(gnuradio-pmt
diff --git a/gr-audio/lib/CMakeLists.txt b/gr-audio/lib/CMakeLists.txt
index 91333b24d..e6a978090 100644
--- a/gr-audio/lib/CMakeLists.txt
+++ b/gr-audio/lib/CMakeLists.txt
@@ -28,6 +28,7 @@ target_include_directories(gnuradio-audio
   PUBLIC
   $<INSTALL_INTERFACE:include>
   $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../include>
+  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
   )
 
 list(APPEND gr_audio_confs ${CMAKE_CURRENT_SOURCE_DIR}/gr-audio.conf)
