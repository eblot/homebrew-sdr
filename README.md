# homebrew-sdr

Formulas for SDR (Software Defined Radio)

## LimeSDR
    This setup works on my machine. YMMV...

    brew install -d -v --build-from-source --HEAD --with-python2 soapysdr
    brew install -d -v --build-from-source --HEAD --with-images limesuite
    brew install -d -v --build-from-source --HEAD eblot/sdr/volk
    brew install -d -v --build-from-source --HEAD eblot/sdr/pothos-lime
    brew install -d -v --build-from-source eblot/sdr/gnuradio
    brew install -d -v --build-from-source --HEAD librtlsdr
    brew install -d -v --build-from-source --HEAD eblot/sdr/gr-osmosdr
