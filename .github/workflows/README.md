# CI Workflows

Five workflows test the different ways to build and install explicitsim
with Guix. Each mirrors a real user workflow and serves as executable
documentation. Structure mirrors
[`guix-mvox`](https://github.com/benzwick/guix-mvox/tree/main/.github/workflows).

## guix-build.yml

Build and install explicitsim using the local package definition.
Runs `guix build -L .` and `guix install -L .` to test package
changes in this repo without publishing them to the channel first.
Use this workflow to verify package changes before pushing.

Runs on: push, pull requests, weekly, manual dispatch.

## guix-channel.yml

Install explicitsim through the Guix channel, as an end user would.
Configures the explicitsim channel in `channels.scm`, runs `guix pull`
to fetch the channel, then installs explicitsim with `guix install
explicitsim`. Verifies that the published channel works correctly.

Runs on: push, weekly, manual dispatch.
Does not run on pull requests since the channel points to `main`.

## guix-shell.yml

Build upstream ExplicitSim from source inside a Guix development
environment. Runs `guix shell -D explicitsim` to provide the build
dependencies (boost, cgal, eigen, tinyxml2, gmp, mpfr, cmake, …),
then builds with `cmake` and `make` against a fresh clone of the
bitbucket upstream. This is how a developer would build ExplicitSim
locally from source.

Runs on: push, pull requests, weekly, manual dispatch.

## guix-slicer.yml

Verify that the Slicer + SlicerCBM + ExplicitSim graph resolves when
all three channels are present. Uses `--dry-run` because a full Slicer
build is too large for GitHub Actions runners.

Runs on: weekly, manual dispatch.

## guix-systole.yml

Test that `guix-explicitsim` composes correctly with `guix-systole`.
Users of SlicerCBM need both channels; this workflow catches
cross-channel conflicts before they reach consumers.

Runs on: push, pull requests, weekly, manual dispatch.
