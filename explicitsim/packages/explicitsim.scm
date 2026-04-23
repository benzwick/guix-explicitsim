(define-module (explicitsim packages explicitsim)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages algebra)
  #:use-module (gnu packages boost)
  #:use-module (gnu packages documentation)
  #:use-module (gnu packages graphics)
  #:use-module (gnu packages graphviz)
  #:use-module (gnu packages multiprecision)
  #:use-module (gnu packages xml))

(define-public explicitsim
  (let ((commit "c6109a36474d539e27fefb0bef390d596d7aac51")
        (revision "0"))
    (package
      (name "explicitsim")
      (version (git-version "1.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://bitbucket.org/explicitsim/explicitsim.git")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "19i0fg1r4ypfzci6x1g7qw3dfgml3v453s5hnfi159rmfga66zsf"))))
      (build-system cmake-build-system)
      (arguments
       (list
        #:configure-flags
        #~(list "-DBUILD_SHARED_LIBS=ON"
                "-DBUILD_STATIC_LIBS=OFF"
                "-DBoost_USE_STATIC_LIBS=OFF"
                "-DEXPLICITSIM_NEAREST_NEIGHBOR=CGAL"
                ;; GCC 14 no longer transitively includes <cstdint>, which
                ;; some headers (e.g. load_curve.hpp) rely on for uint32_t.
                "-DCMAKE_CXX_FLAGS=-include cstdint"
                ;; Upstream installs the shared library to lib/ExplicitSim
                ;; and the executable to bin/ExplicitSim, so the default
                ;; RUNPATH ($out/lib) cannot find libExplicitSim.so.
                (string-append "-DCMAKE_INSTALL_RPATH="
                               #$output "/lib/ExplicitSim")
                (string-append "-DTINYXML2_DIRS="
                               #$(this-package-input "tinyxml2"))
                (string-append "-DEIGEN3_DIRS="
                               #$(this-package-input "eigen")))
        #:tests? #f))
      ;; Use boost-1.88 because the current default (boost 1.89.0 in Guix)
      ;; does not ship the boost_system CMake config, which is required by
      ;; FIND_PACKAGE(Boost REQUIRED COMPONENTS system filesystem ...).
      (inputs (list boost-1.88 cgal eigen gmp mpfr tinyxml2))
      (native-inputs (list doxygen graphviz))
      (home-page "https://bitbucket.org/explicitsim/explicitsim")
      (synopsis "Explicit PDE solver using meshless and finite element methods")
      (description
       "ExplicitSim is a C++ library and application for solving partial
differential equations using explicit time-integration schemes.  It supports
finite element and meshless discretisations and is used for large-deformation
biomechanical simulations such as patient-specific brain modelling.")
      (license license:gpl3+))))
