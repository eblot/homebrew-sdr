# homebrew-sdr

Formulas for SDR (Software Defined Radio) on macOS

## Goal

These formulas are dedicated to run SDR application on macOS, using recent
versions of well known applications. It does not intend to provice a
comprensive set of SDR application, but to be able to build and run some of
them with less hassle than what I've been facing up to now with deprecated
versions or unsupported hardware.

## Hardware

For now, these formulas are dedicated to support the following SDR devices.

* RTL-SDR USB dongle
  * Those ~ €15 cheap dongles are by far the best supported devices.

* Analog Device PlutoSDR
  * Those ~ €100 devices have TX capability and a larger frequency bandwidth
    than RTL-SDR, but are quite less supported, although the Analog Devices
    keeps releasing update and are quite active.

* LimeSDR
  * These ~ €400 devices have strong TX and RX capability and a very large
    frequency bandwidth. However their support is simply ugly, with buggy
    software, rely on legacy applications and APIs and very few applications
    are able to support them properly, *i.e.* nice hardware, but notably
    difficult, if not impossible, to use on macOS.

## Software

 * GNUradio 3.8 w/ GRC support (Quartz backend, no need for X11)
 * Python 3.7
 * GQRX
 * GR-osmosdr
 * GR-iio / libiio

## Status

GNUradio 3.8 final has been released this month (August '19) and has still
very rough corners to run on macOS with a Quartz backend, especially the
gnuradio-companion UI tool. Several bugs are being investigated by the time
of writing, and a couple of patches have been proposed but are not yet
integrated upstream. Those patches are applied to build GRC on macOS, but for
now GR 3.8 on macOS should be considered as very experimental.

* RTL-SDR device seems to work fine with GQRX
* PlutoSDR/RX is quite experimental but works with GQRX
* TX feature is yet to be tested
* LimeSDR is not yet supported (will it be?)
* GRC works without crashing, but several UI glitches remain.

### Warning

I do not want to support the 10 year old deprecated Python 2.7 interpreter,
so all formulas are built against Python 3.7.

## Build

Most applications and libraries require patch to successfully build and run,
so many sources come from forked Github repositories.

    brew tap eblot/sdr
    brew install [-d] [-v] -s eblot/sdr/gnuradio
    brew install [-d] [-v] -s eblot/sdr/libiio
    brew install [-d] [-v] -s eblot/sdr/libad9361
    brew install [-d] [-v] --HEAD eblot/sdr/gr-iio
    brew install [-d] [-v] --HEAD eblot/sdr/gr-osmosdr
    brew install [-d] [-v] --HEAD eblot/sdr/gqrx
