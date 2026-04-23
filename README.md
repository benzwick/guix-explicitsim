# ExplicitSim Guix Channel

<!-- Badges ordered by scope: local build, dev shell, published channel,
     multi-channel composition, full Slicer integration. -->
[![Guix Build](https://github.com/benzwick/guix-explicitsim/actions/workflows/guix-build.yml/badge.svg)](https://github.com/benzwick/guix-explicitsim/actions/workflows/guix-build.yml)
[![Guix Shell](https://github.com/benzwick/guix-explicitsim/actions/workflows/guix-shell.yml/badge.svg)](https://github.com/benzwick/guix-explicitsim/actions/workflows/guix-shell.yml)
[![Guix Channel](https://github.com/benzwick/guix-explicitsim/actions/workflows/guix-channel.yml/badge.svg)](https://github.com/benzwick/guix-explicitsim/actions/workflows/guix-channel.yml)
[![Guix Systole](https://github.com/benzwick/guix-explicitsim/actions/workflows/guix-systole.yml/badge.svg)](https://github.com/benzwick/guix-explicitsim/actions/workflows/guix-systole.yml)
[![Guix Slicer](https://github.com/benzwick/guix-explicitsim/actions/workflows/guix-slicer.yml/badge.svg)](https://github.com/benzwick/guix-explicitsim/actions/workflows/guix-slicer.yml)

This [Guix channel](https://guix.gnu.org/manual/en/html_node/Channels.html)
provides a package for
[ExplicitSim](https://bitbucket.org/explicitsim/explicitsim), a C++ library
and application for solving PDEs using explicit time-integration schemes on
finite element and meshless discretisations.

The pinned commit and version live in
[`explicitsim/packages/explicitsim.scm`](explicitsim/packages/explicitsim.scm).

## Installing

Add the channel to `~/.config/guix/channels.scm`:

```scheme
(cons (channel
       (name 'explicitsim)
       (url "https://github.com/benzwick/guix-explicitsim")
       (branch "main"))
      %default-channels)
```

Then pull and install:

    guix pull
    guix install explicitsim
    ExplicitSimRun

The executable is installed as `$out/bin/ExplicitSim/ExplicitSimRun` and the
shared library as `$out/lib/ExplicitSim/libExplicitSim.so`, following the
layout defined by upstream's `CMakeLists.txt`.

## Development

Build from a local checkout without adding the channel:

    guix build -L . explicitsim

Lint:

    guix lint -L . explicitsim

## Integration with SlicerCBM

ExplicitSim is invoked at runtime by CBM modules in
[SlicerCBM](https://github.com/SlicerCBM/SlicerCBM) such as `MTLEDSimulator`.
For a full ExplicitSim + SlicerCBM + 3D Slicer stack installed via Guix, see
the channels list in
[Guix-SlicerCBM's README](https://github.com/SlicerCBM/Guix-SlicerCBM).

## Build notes

Context for anyone updating the package — the rationale behind the
non-obvious choices is recorded as comments in
[`explicitsim/packages/explicitsim.scm`](explicitsim/packages/explicitsim.scm):

- a specific `boost-*` variant is used rather than the default `boost`,
- `-include cstdint` is added to `CXXFLAGS` for GCC 14,
- `CMAKE_INSTALL_RPATH` is set so the executable finds the library
  (upstream installs into `lib/ExplicitSim`, not `lib`),
- `EIGEN3_DIRS` and `TINYXML2_DIRS` are passed explicitly because the
  project ships its own `Find*.cmake` modules with hard-coded
  `/usr/local` defaults.
