(define-module (laura packages utils)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (gnu packages autotools)
  #:use-module (guix download)
  #:use-module (guix build-system cargo)
  #:use-module (guix build-system copy)
  #:use-module (guix build-system zig)
  #:use-module (guix build-system pyproject)
  #:use-module (guix build-system ant)
  #:use-module (gnu packages)
  #:use-module (past-crates packages crates-io)
  #:use-module (gnu packages protobuf)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages multiprecision)
  #:use-module (gnu packages python)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages golang-build)
  #:use-module (gnu packages golang)
  #:use-module (gnu packages golang-xyz)
  #:use-module (gnu packages golang-check)
  #:use-module (gnu packages golang-crypto)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages virtualization)
  #:use-module (gnu packages dns)
  #:use-module (gnu packages llvm)
  #:use-module (gnu packages popt)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages man)
  #:use-module (gnu packages golang-web)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages cross-base)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages lua)
  #:use-module (gnu packages sdl)
  #:use-module (gnu packages readline)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages package-management)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages language)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages serialization)
  #:use-module (gnu packages databases)
  #:use-module (gnu packages elf)
  #:use-module (gnu packages docbook)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages web)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages python-crypto)
  #:use-module (gnu packages check)
  #:use-module (gnu packages python-check)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages sagemath)
  #:use-module (gnu packages base)
  #:use-module (gnu packages engineering)
  #:use-module (gnu packages radio)
  #:use-module (gnu packages image)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages ruby)
  #:use-module (gnu packages electronics)
  #:use-module (gnu packages boost)
  #:use-module (gnu packages aidc)
  #:use-module (gnu packages crypto)
  #:use-module (gnu packages tor)
  #:use-module (gnu packages dbm)
  #:use-module (gnu system uuid)
  #:use-module (guix build utils)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system go)
  #:use-module (guix build-system python)
  #:use-module (guix build-system meson)
  #:use-module (guix build-system qt)
  #:use-module (guix gexp)
  #:use-module (guix utils)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-26)
  #:use-module (laura packages go-common)
  #:use-module (laura packages rust-common))

(define-public Amogus-File-Encoder
  (package
    (name "Amogus-File-Encoder")
    (version "sus")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/RegularRabbit05/Amogus-File-Encoder")
             (commit "sus")))
       (modules '((guix build utils)))
       (snippet #~(begin
                    (substitute* "main.cpp"
                      (("getpid\\(\\)")
                       "1"))
                    (make-file-writable "CMakeLists.txt")
                    (let ((output-port (open-file "CMakeLists.txt" "a")))
                      (display "\ninstall(TARGETS AmogusCoder)\n" output-port)
                      (close output-port))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "04z1i34y2y3g7d8qvdfjwxk98qybbc49qzzpplvpgmn4iwhikm4s"))))
    (build-system cmake-build-system)
    (arguments
     (list
      #:tests? #f
      #:build-type "Release"))
    (home-page "https://github.com/RegularRabbit05/Amogus-File-Encoder")
    (synopsis "Encode and decode your files and strings in a sussy way!")
    (description
     "Because Base64 is overrated. Now with -600% compression rates!")
    (license (license:non-copyleft "file://LICENSE.md"))))

(define-public gcc-cross-riscv64-linux-gnu-toolchain
  (cross-gcc-toolchain "riscv64-linux-gnu"))

(define-public CasioEmu
  (package
    (name "CasioEmu")
    (version "0.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/jakiki6/CasioEmu")
             (commit "85f2e0e20194e4b9b793899b77a4c7aaa8e7d27a")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1pnhbrx4yfzy3limqblvpmcabzdb9z9mhwjqn5axzwr4hmhhvas0"))))
    (build-system meson-build-system)
    (native-inputs (list pkg-config))
    (inputs (list lua-5.4 sdl2 sdl2-image readline))
    (arguments
     (list
      #:phases
      #~(modify-phases %standard-phases
          (add-before 'configure 'chdir
            (lambda _
              (chdir "emulator")))
          (replace 'install
            (lambda* (#:key outputs #:allow-other-keys)
              (begin
                (install-file "emulator"
                              (string-append (assoc-ref outputs "out") "/bin"))
                (copy-recursively "../models"
                                  (string-append (assoc-ref outputs "out")
                                                 "/models"))))))))
    (home-page "https://github.com/jakiki6/CasioEmu")
    (synopsis "An emulator for nX-U8 based Casio fx-es PLUS calculators.")
    (description
     "An emulator and disassembler for the CASIO calculator series using the nX-U8/100 core.")
    (license license:gpl3)))

(define-public activate-linux
  (package
    (name "activate-linux")
    (version "1.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/Kljunas2/activate-linux")
             (commit "8521a85e8b30229635dea58ab053f2b7d674d242")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0g4w73jhinw9kx9kixsyjy29q0p1jqhgw4yycmfghc0shyiv7vyh"))))
    (build-system gnu-build-system)
    (native-inputs (list pkg-config))
    (inputs (list gtk-layer-shell gtk+))
    (arguments
     `(#:tests? #f
       #:phases (modify-phases %standard-phases
                  (delete 'configure)
                  (replace 'install
                    (lambda* (#:key outputs #:allow-other-keys)
                      (install-file "bin/activate-linux"
                                    (string-append (assoc-ref outputs "out")
                                                   "/bin")))))))
    (home-page "https://github.com/Kljunas2/activate-linux")
    (synopsis "Activate Linux watermark for Wayland")
    (description
     "The \"Activate Windows\" watermark ported to Linux with Gtk Layer Shell")
    (license license:expat)))

(define-public bkcrack
  (package
    (name "bkcrack")
    (version "1.7.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/kimci86/bkcrack")
             (commit "v1.7.0")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1jy8jk8spsp80vc06grk9k35hpl8w83jvm4xibvm9f4qm6gfcq5j"))))
    (build-system cmake-build-system)
    (arguments
     (list
      #:tests? #f
      #:build-type "Release"
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'install 'move
            (lambda* (#:key outputs #:allow-other-keys)
              (begin
                (chdir #$output)
                (mkdir "bin")
                (rename-file "bkcrack" "bin/bkcrack")
                (map delete-file-recursively
                     (list "example" "tools" "readme.md" "license.txt"))))))))
    (home-page "https://github.com/kimci86/bkcrack")
    (synopsis
     "Crack legacy zip encryption with Biham and Kocher's known plaintext attack.")
    (description
     "A ZIP archive may contain many entries whose content can be compressed and/or encrypted. In particular, entries can be encrypted with a password-based symmetric encryption algorithm referred to as traditional PKWARE encryption, legacy encryption or ZipCrypto. This algorithm generates a pseudo-random stream of bytes (keystream) which is XORed to the entry's content (plaintext) to produce encrypted data (ciphertext). The generator's state, made of three 32-bits integers, is initialized using the password and then continuously updated with plaintext as encryption goes on. This encryption algorithm is vulnerable to known plaintext attacks as shown by Eli Biham and Paul C. Kocher in the research paper A known plaintext attack on the PKZIP stream cipher. Given ciphertext and 12 or more bytes of the corresponding plaintext, the internal state of the keystream generator can be recovered. This internal state is enough to decipher ciphertext entirely as well as other entries which were encrypted with the same password. It can also be used to bruteforce the password with a complexity of nl-6 where n is the size of the character set and l is the length of the password.")
    (license license:zlib)))

(define-public bsdiff
  (package
    (name "bsdiff")
    (version "4.3")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/mendsley/bsdiff")
             (commit "b817e9491cf7b8699c8462ef9e2657ca4ccd7667")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1f72rpivnvkim2xr4j7p2inm8a84g2kbzbs0shfcbi2qpgxmm8m1"))))
    (build-system gnu-build-system)
    (inputs '())
    (native-inputs (list autoconf automake libtool))
    (synopsis "Libraries for building and applying patches to binary files.")
    (description
     "bsdiff and bspatch are libraries for building and applying patches to binary files.")
    (home-page "https://github.com/mendsley/bsdiff")
    (license license:bsd-3)))

(define-public cado-nfs
  (package
    (name "cado-nfs")
    (version "2.3.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://gitlab.inria.fr/cado-nfs/cado-nfs.git")
             (commit "2551f43ca06cb31d86fe39847033ac8dedca1938")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1qd75c6qa38xnm2b3h1k7n8g5vf746bkz68ljbpds9ma6rzlwyiw"))))
    (inputs (list gmp python-3 perl))
    (build-system cmake-build-system)
    (arguments
     `(#:tests? #f
       #:build-type "Release"
       #:phases (modify-phases %standard-phases
                  (add-before 'patch-generated-file-shebangs 'patch-files
                    (lambda* (#:key inputs #:allow-other-keys)
                      (begin
                        (use-modules (guix build utils))
                        (map (lambda (x)
                               (with-exception-handler (lambda (e)
                                                         #f)
                                                       (lambda ()
                                                         (substitute* x
                                                           (("#! /bin/sh")
                                                            "#!/bin/sh")))))
                             (find-files "."))))))))
    (home-page "https://gitlab.inria.fr/cado-nfs/cado-nfs")
    (synopsis "An Implementation of the Number Field Sieve Algorithm")
    (description
     "Cado-NFS, An Implementation of the Number Field Sieve Algorithm")
    (license license:lgpl2.1)))

(define-public cerca
  (package
    (name "cerca")
    (version "0.0.0-20240906135835-1f4d8ff974ed")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/cblgh/cerca")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "17wsk87p1v5wsxdfypc293nrsdx4nna2q9ldwf89r6bia3978gsi"))))
    (build-system go-build-system)
    (arguments
     `(#:import-path "cerca"
       #:go ,go-1.23
       #:build-flags (list "-ldflags=-s -w --buildid=none")
       #:phases (modify-phases %standard-phases
                  (add-before 'build 'deref-symlinks
                    (lambda* (#:key inputs #:allow-other-keys)
                      (begin
                        (delete-file-recursively
                         "src/golang.org/x/net/publicsuffix/data")
                        (copy-recursively (string-append (assoc-ref inputs
                                                          "go-golang-org-x-net")
                                           "/src/golang.org/x/net/publicsuffix/data")
                         "src/golang.org/x/net/publicsuffix/data")))))))
    (propagated-inputs (list go-golang-org-x-time
                             go-golang-org-x-exp
                             go-github-com-microcosm-cc-bluemonday
                             go-github-com-mattn-go-sqlite3
                             go-github-com-matthewhartstonge-argon2
                             go-github-com-komkom-toml
                             go-github-com-gorilla-sessions
                             go-github-com-gomarkdown-markdown
                             go-github-com-cblgh-plain
                             go-github-com-carlmjohnson-requests))
    (home-page "https://github.com/cblgh/cerca")
    (synopsis "Cerca")
    (description "a forum software")
    (license license:agpl3+)))

(define-public clipmon
  (package
    (name "clipmon")
    (version "0.1.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "clipmon" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0fcspz7dw1vwin7vqizjszwc8qyzpdpz6hvvnrvnrp3gqmbm1ny3"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-calloop" ,rust-calloop-0.9)
                       ("rust-libc" ,rust-libc-0.2.155)
                       ("rust-mime" ,rust-mime-0.3)
                       ("rust-smithay-client-toolkit" ,rust-smithay-client-toolkit-0.15)
                       ("rust-wayland-client" ,rust-wayland-client-0.29)
                       ("rust-wayland-protocols" ,rust-wayland-protocols-0.29))))
    (home-page "https://sr.ht/~whynothugo/clipmon/")
    (synopsis
     "clipmon, or clipboard monitor is a wayland helper that keeps the selection when the application that copied exits")
    (description
     "This package provides clipmon, or clipboard monitor is a wayland helper that keeps the selection when
the application that copied exits.")
    (license license:isc)))

(define-public coremark
  (package
    (name "coremark")
    (version "1.01")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/eembc/coremark")
             (commit "v1.01")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "17sdf01715w0fwhlgl21w5hc9d97ixkrgx20vyglz2w418cwk1b7"))
       (snippet `(begin
                   (use-modules (guix build utils))
                   (substitute* "Makefile"
                     (("rerun score")
                      "compile"))))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f
       #:phases (modify-phases %standard-phases
                  (delete 'configure)
                  (replace 'install
                    (lambda* (#:key outputs #:allow-other-keys)
                      (begin
                        (rename-file "coremark.exe" "coremark")
                        (install-file "coremark"
                                      (string-append (assoc-ref outputs "out")
                                                     "/bin"))))))))
    (home-page "https://github.com/eembc/coremark")
    (synopsis
     "CoreMark® is an industry-standard benchmark that measures the performance of central processing units (CPU) and embedded microcrontrollers (MCU).")
    (description
     "CoreMark's primary goals are simplicity and providing a method for testing only a processor's core features. For more information about EEMBC's comprehensive embedded benchmark suites, please see www.eembc.org.")
    (license license:asl2.0)))

(define-public csvlens
  (package
    (name "csvlens")
    (version "0.9.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "csvlens" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0gvw0lz8jsk88vpnfb6zv0rnm9pshj4rjbifx5cxkq9biin9qnvj"))))
    (build-system cargo-build-system)
    (arguments
     `(#:tests? #f
       #:cargo-inputs (("rust-anyhow" ,rust-anyhow-1)
                       ("rust-arboard" ,rust-arboard-3.4)
                       ("rust-arrow" ,rust-arrow-50)
                       ("rust-clap" ,rust-clap-4)
                       ("rust-crossterm" ,rust-crossterm-0.27)
                       ("rust-csv" ,rust-csv-1)
                       ("rust-csv-sniffer" ,rust-csv-sniffer-0.3)
                       ("rust-ratatui" ,rust-ratatui-0.25)
                       ("rust-regex" ,rust-regex-1)
                       ("rust-sorted-vec" ,rust-sorted-vec-0.8)
                       ("rust-tempfile" ,rust-tempfile-3)
                       ("rust-tui-input" ,rust-tui-input-0.8))))
    (home-page "https://github.com/YS-L/csvlens")
    (synopsis "Command line csv viewer")
    (description "This package provides Command line csv viewer.")
    (license license:expat)))

(define-public duf
  (package
    (name "duf")
    (version "0.8.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/muesli/duf")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "08hzmj3phli4yzj10z9q0y6zrzjq8r7iaxgpz4rfjqqarxgslnvd"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/muesli/duf"))
    (propagated-inputs `(("go-golang-org-x-term" ,go-golang-org-x-term)
                         ("go-golang-org-x-sys" ,go-golang-org-x-sys)
                         ("go-github-com-muesli-termenv" ,go-github-com-muesli-termenv)
                         ("go-github-com-muesli-roff" ,go-github-com-muesli-roff)
                         ("go-github-com-muesli-mango" ,go-github-com-muesli-mango)
                         ("go-github-com-mattn-go-runewidth" ,go-github-com-mattn-go-runewidth)
                         ("go-github-com-jedib0t-go-pretty-v6" ,go-github-com-jedib0t-go-pretty-v6)
                         ("go-github-com-iglou-eu-go-wildcard" ,go-github-com-iglou-eu-go-wildcard)))
    (home-page "https://github.com/muesli/duf")
    (synopsis "Disk Usage/Free Utility - a better 'df' alternative")
    (description
     "Disk Usage/Free Utility (Linux, BSD, @code{macOS} & Windows).")
    (license license:expat)))

(define-public encpipe
  (package
    (name "encpipe")
    (version "0.5")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/jedisct1/encpipe")
             (recursive? #t)
             (commit "0.5")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1mk178kf7vbk92hshylfm20giy8dgncc16s9if1hrffrdi4hllb2"))
       (snippet `(begin
                   (use-modules (guix build utils))
                   (substitute* "Makefile"
                     (("-march=native ")
                      ""))))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f
       #:phases (modify-phases %standard-phases
                  (delete 'configure)
                  (add-before 'build 'env
                    (lambda* (#:key outputs #:allow-other-keys)
                      (setenv "CC" "gcc")))
                  (replace 'install
                    (lambda* (#:key outputs #:allow-other-keys)
                      (begin
                        (install-file "encpipe"
                                      (string-append (assoc-ref outputs "out")
                                                     "/bin"))))))))
    (home-page "https://github.com/jedisct1/encpipe")
    (synopsis "The dum^H^H^Hsimplest encryption tool in the world.")
    (description
     "It was faster to write than remember how to use GnuPG and OpenSSL.")
    (license license:isc)))

(define-public ent
  (package
    (name "ent")
    (version "1.2")
    (source
     (origin
       (method url-fetch)
       (uri
        "http://deb.debian.org/debian/pool/main/e/ent/ent_1.2debian.orig.tar.gz")
       (sha256
        (base32 "0jfhqzf5iwn5c7bb0kr9h9x5znxammlwxgqn6hvryc0dnci3gxid"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f
       #:phases (modify-phases %standard-phases
                  (delete 'configure)
                  (replace 'install
                    (lambda* (#:key outputs #:allow-other-keys)
                      (begin
                        (install-file "ent"
                                      (string-append (assoc-ref outputs "out")
                                                     "/bin"))))))))
    (home-page "https://www.fourmilab.ch/random/")
    (synopsis "Pseudorandom number sequence test program")
    (description
     "This program applies various tests to sequences of bytes stored in files and reports the results of those tests. The program is useful for those evaluating pseudorandom number generators for encryption and statistical sampling applications, compression algorithms, and other applications where the information density of a file is of interest.")
    (license license:public-domain)))

(define appsteam-for-flatpak-builder
  (package/inherit appstream
    (inputs (list curl
                  libsoup-minimal-2
                  libstemmer
                  libxmlb
                  libxml2
                  libyaml
                  lmdb
                  cairo
                  gdk-pixbuf
                  pango
                  librsvg))
    (arguments (substitute-keyword-arguments (package-arguments appstream)
                 ((#:configure-flags flags)
                  '(list "-Dsystemd=false" "-Dcompose=true"))))))

(define-public flatpak-builder
  (package
    (name "flatpak-builder")
    (version "1.4.4")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/flatpak/flatpak-builder")
             (commit "1.4.4")
             (recursive? #t)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "01v9197wl9nd0104w6933n1vrkm7blbmlrb4khvcbafr6pgcp23z"))))
    (build-system gnu-build-system)
    (native-inputs (list (@ (gnu packages base) which)
                         autoconf
                         gettext-minimal
                         automake
                         libtool
                         pkg-config))
    (inputs (list flatpak
                  libostree
                  json-glib
                  libxml2
                  curl
                  elfutils
                  xz
                  libyaml))
    (propagated-inputs (list appsteam-for-flatpak-builder))
    (arguments
     (list
      #:configure-flags
      #~(list "--enable-documentation=false")
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'install 'wrap-program
            (lambda* (#:key outputs #:allow-other-keys)
              (wrap-program (string-append (assoc-ref outputs "out")
                                           "/bin/flatpak-builder")
                '("FLATPAK_VALIDATE_ICON" ":" =
                  ("/usr/bin/true"))))))))
    (home-page "https://github.com/flatpak/flatpak-builder")
    (synopsis "Tool to build flatpaks from source")
    (description
     "flatpak-builder is a tool for building flatpaks from sources.

It reads a JSON or YAML based manifest to automatically download, build, and install projects which eventually get exported into a flatpak.")
    (license license:lgpl2.1)))

(define-public go-github-com-iglou-eu-go-wildcard
  (package
    (name "go-github-com-iglou-eu-go-wildcard")
    (version "1.0.3")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/IGLOU-EU/go-wildcard")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1navfgv8k4lk0ajd8xib75qzjiingbh9xfhrh1qdxin5cycrn1al"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/IGLOU-EU/go-wildcard"))
    (home-page "https://github.com/IGLOU-EU/go-wildcard")
    (synopsis "Go-wildcard")
    (description
     "This part of Minio project is a very cool, fast and light wildcard pattern
matching.")
    (license license:asl2.0)))

(define-public go-github-com-jedib0t-go-pretty-v6
  (package
    (name "go-github-com-jedib0t-go-pretty-v6")
    (version "6.5.9")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/jedib0t/go-pretty")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1xb6sskfmbycfd0373cvq0849k0mq7b8xah9ai099m519iqawkx9"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/jedib0t/go-pretty/v6"
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (delete 'check))))
    (propagated-inputs `(("go-golang-org-x-term" ,go-golang-org-x-term)
                         ("go-golang-org-x-sys" ,go-golang-org-x-sys)
                         ("go-github-com-stretchr-testify" ,go-github-com-stretchr-testify)
                         ("go-github-com-pkg-profile" ,go-github-com-pkg-profile)
                         ("go-github-com-mattn-go-runewidth" ,go-github-com-mattn-go-runewidth)))
    (home-page "https://github.com/jedib0t/go-pretty")
    (synopsis "go-pretty")
    (description
     "Utilities to prettify console output of tables, lists, progress-bars, text, etc.
 with a heavy emphasis on customization.")
    (license license:expat)))

(define-public go-github-com-muesli-mango
  (package
    (name "go-github-com-muesli-mango")
    (version "0.2.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/muesli/mango")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "16d0sga6cbdxzlqkibcgw0civkw11fpkcjpgv21i0q5j9mjbsjw4"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/muesli/mango"))
    (propagated-inputs `(("go-github-com-muesli-roff" ,go-github-com-muesli-roff)))
    (home-page "https://github.com/muesli/mango")
    (synopsis "mango")
    (description
     "mango is a man-page generator for the Go flag, pflag, cobra, coral, and kong
packages.  It extracts commands, flags, and arguments from your program and
enables it to self-document.")
    (license license:expat)))

(define-public go-github-com-muesli-roff
  (package
    (name "go-github-com-muesli-roff")
    (version "0.1.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/muesli/roff")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0l263rqwq2ccr1lpamsvs48dddsr70xim8mv6rsj2x9y3prcq3yh"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/muesli/roff"
      #:tests? #f))
    (home-page "https://github.com/muesli/roff")
    (synopsis "roff")
    (description "roff lets you write roff documents in Go.")
    (license license:expat)))

(define-public leopard
  (package
    (name "leopard")
    (version "2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/catid/leopard")
             (commit "6e5725ebdf9da4370b0bcc4f70fa8eb66f4e6198")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0hbcd97q972ifp88ypd9y1w5nm5x08xbbzc35fwj35kvlpsnz4vi"))
       (snippet '(begin
                   (chmod "CMakeLists.txt" #o644)
                   (let ((out (open-file "CMakeLists.txt" "a")))
                     (display "add_library(leopard SHARED ${LIB_SOURCE_FILES})
install(TARGETS bench_leopard DESTINATION bin)
install(TARGETS leopard DESTINATION lib)
install(FILES leopard.h DESTINATION include)
"
                      out)
                     (close-port out))
                   (use-modules (guix build utils))
                   (substitute* "CMakeLists.txt"
                     (("-march=native")
                      "-march=haswell"))))))
    (build-system cmake-build-system)
    (arguments
     (list
      #:tests? #f
      #:build-type "Release"))
    (home-page "https://github.com/catid/leopard")
    (synopsis
     "Leopard-RS : O(N Log N) MDS Reed-Solomon Block Erasure Code for Large Data")
    (description
     "Leopard-RS is a fast library for Erasure Correction Coding. From a block of equally sized original data pieces, it generates recovery symbols that can be used to recover lost original data.")
    (license license:bsd-3)))

(define-public libgbinder
  (package
    (name "libgbinder")
    (version "1.1.40")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/mer-hybris/libgbinder")
             (commit "1.1.40")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0z293a1cr3hxkxlyi0cd6syd5dj9jhbx91plzl6nziviprwd9zbf"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f
       #:phases (modify-phases %standard-phases
                  (delete 'configure)
                  (add-before 'build 'fix-makefile
                    (lambda* (#:key outputs #:allow-other-keys)
                      (begin
                        (substitute* "Makefile"
                          (("CC \\?\\= \\$\\(CROSS_COMPILE\\)gcc")
                           (string-append "CC := gcc\nDESTDIR := "
                                          (assoc-ref outputs "out")))
                          (("install:")
                           "pre-install:")
                          (("install-dev: install")
                           "install: pre-install")
                          (("usr\\/")
                           "")
                          (("\\$\\(ABS_LIBDIR\\)\\|")
                           "$(DESTDIR)/$(LIBDIR)|")))
                      (substitute* "libgbinder.pc.in"
                        (("\\/usr\\/include")
                         "@libdir@/../include"))
                      (substitute* "include/gbinder_types.h"
                        (("gutil_types.h")
                         "gutil/gutil_types.h")))))))
    (inputs (list glib))
    (native-inputs (list pkg-config))
    (propagated-inputs (list libglibutil))
    (home-page "https://github.com/mer-hybris/libgbinder")
    (synopsis "GLib-style interface to binder")
    (description "GLib-style interface to binder (Android IPC mechanism)")
    (license license:bsd-3)))

(define-public libgfshare
  (package
    (name "libgfshare")
    (version "1.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/jcushman/libgfshare")
             (commit "beeebe381a3953a3535295b0121e13c0aae1112e")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "053gzsy5sv7yjzbnnql2a89f5y0bab173m057z7xxwrpkvqkvcq5"))))
    (build-system gnu-build-system)
    (inputs '())
    (native-inputs (list autoconf automake libtool))
    (synopsis "Library for Shamir Secret Sharing in the Galois Field 2**8")
    (description
     "This library implements what is known as Shamir Secret Sharing.")
    (home-page "https://github.com/jcushman/libgfshare")
    (license license:expat)))

(define-public libglibutil
  (package
    (name "libglibutil")
    (version "1.0.79")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/sailfishos/libglibutil")
             (commit "1.0.79")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1zn0h9f8bd4kwqz33b8719r1wwbx790qvwl05w1yqrm0z270m6sh"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f
       #:phases (modify-phases %standard-phases
                  (delete 'configure)
                  (add-before 'build 'fix-makefile
                    (lambda* (#:key outputs #:allow-other-keys)
                      (begin
                        (substitute* "Makefile"
                          (("CC \\?\\= \\$\\(CROSS_COMPILE\\)gcc")
                           (string-append "CC := gcc\nDESTDIR := "
                                          (assoc-ref outputs "out")))
                          (("install:")
                           "pre-install:")
                          (("install-dev: install")
                           "install: pre-install")
                          (("usr\\/")
                           "")
                          (("\\$\\(ABS_LIBDIR\\)\\|")
                           "$(DESTDIR)/$(LIBDIR)|")))
                      (substitute* "libglibutil.pc.in"
                        (("\\/usr\\/include")
                         "@libdir@/../include")))))))
    (inputs (list glib))
    (native-inputs (list pkg-config))
    (home-page "https://github.com/sailfishos/libglibutil")
    (synopsis "Library of glib utilities.")
    (description "Library of glib utilities.")
    (license license:bsd-3)))

(define-public liboqs
  (package
    (name "liboqs")
    (version "0.11.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/open-quantum-safe/liboqs")
             (commit "0.11.0")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0cv7v2cxdjavc24a10b5vp2ayf21r551gj6hqwif78f9z8j7av7q"))))
    (build-system cmake-build-system)
    (inputs (list openssl))
    (arguments
     `(#:tests? #f
       #:build-type "Release"))
    (home-page "https://openquantumsafe.org/")
    (synopsis
     "liboqs is an open source C library for quantum-safe cryptographic algorithms.")
    (description
     "C library for prototyping and experimenting with quantum-resistant cryptography")
    (license license:expat)))

(define-public paper-age
  (package
    (name "paper-age")
    (version "1.3.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "paper-age" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "14n6qv6f39qy8wvw71vfm8y0yfggp975yibqdqdzz61iis46mykv"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-age" ,rust-age-0.10)
                       ("rust-clap" ,rust-clap-4.5.6)
                       ("rust-clap-verbosity-flag" ,rust-clap-verbosity-flag-2.2)
                       ("rust-clap-complete" ,rust-clap-complete-4.5.5)
                       ("rust-clap-mangen" ,rust-clap-mangen-0.2)
                       ("rust-env-logger" ,rust-env-logger-0.11)
                       ("rust-exitcode" ,rust-exitcode-1)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-path-absolutize" ,rust-path-absolutize-3)
                       ("rust-printpdf" ,rust-printpdf-0.7)
                       ("rust-printpdf" ,rust-printpdf-0.7)
                       ("rust-qrcode" ,rust-qrcode-0.14)
                       ("rust-rpassword" ,rust-rpassword-7))
       #:cargo-development-inputs (("rust-assert-cmd" ,rust-assert-cmd-2)
                                   ("rust-assert-fs" ,rust-assert-fs-1.1.1)
                                   ("rust-predicates" ,rust-predicates-3.1.0))))
    (home-page "https://github.com/matiaskorhonen/paper-age")
    (synopsis "Easy and secure paper backups of secrets")
    (description
     "This package provides Easy and secure paper backups of secrets.")
    (license license:expat)))

(define-public payload-dumper-go
  (package
    (name "payload-dumper-go")
    (version "0.0.0-20241018080004-d8ba4911ebd7")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/ssut/payload-dumper-go")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1d7rdmx04wi29hbafih3hv4lrp5dyrnpsylhzc5r7gmn7sp08xij"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/ssut/payload-dumper-go"))
    (propagated-inputs (list go-google-golang-org-protobuf
                             go-github-com-vbauerster-mpb-v5
                             go-github-com-spencercw-go-xz
                             go-github-com-dustin-go-humanize
                             go-github-com-valyala-gozstd))
    (home-page "https://github.com/ssut/payload-dumper-go")
    (synopsis "payload-dumper-go")
    (description "An android OTA payload dumper written in Go.")
    (license license:asl2.0)))

(define-public pesign
  (package
    (name "pesign")
    (version "116")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/rhboot/pesign")
             (commit "116")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0fnqfiivj46bha4hsnwiqy8vq8b4i3w2dig0h9h2k4j7yq7r5qvj"))))
    (build-system gnu-build-system)
    (native-inputs (list pkg-config mandoc))
    (inputs (list popt
                  efivar
                  nspr
                  nss
                  openssl
                  `(,util-linux "lib")))
    (arguments
     `(#:tests? #f
       #:phases (modify-phases %standard-phases
                  (delete 'configure)
                  (add-before 'build 'fix-env
                    (lambda* (#:key inputs outputs #:allow-other-keys)
                      (setenv "LIBRARY_PATH"
                              (string-append (getenv "LIBRARY_PATH") ":"
                                             (assoc-ref inputs "nss")
                                             "/lib/nss"))
                      (substitute* "Make.defaults"
                        (("DESTDIR.*\\?.*$")
                         (string-append "DESTDIR = "
                                        (assoc-ref outputs "out") "\n"))
                        (("/usr/")
                         "/")))))))
    (home-page "https://github.com/rhboot/pesign")
    (synopsis "Linux tools for signed PE-COFF binaries")
    (description
     "Signing tools for PE-COFF binaries. Compliant with the PE and Authenticode specifications.")
    (license license:gpl2)))

(define-public python-gbinder
  (package
    (name "python-gbinder")
    (version "2.10")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/erfanoabdi/gbinder-python")
             (commit "1.1.2")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1qxadb1ccmdwnwj4p15sm2i3b7cjaxh7far1jk9sxrblwh7497ds"))))
    (build-system python-build-system)
    (arguments
     `(#:phases (modify-phases %standard-phases
                  (add-before 'build 'cythonize
                    (lambda* (#:key outputs #:allow-other-keys)
                      (substitute* "setup.py"
                        (("USE_CYTHON = False")
                         "USE_CYTHON = True")
                        (("extension_kwargs = pkgconfig\\('libgbinder', extension_kwargs\\)")
                         "extension_kwargs = pkgconfig('libgbinder', extension_kwargs)
extension_kwargs = pkgconfig('libglibutil', extension_kwargs)")))))))
    (inputs (list python-cython libgbinder libglibutil glib))
    (native-inputs (list pkg-config))
    (home-page "https://github.com/erfanoabdi/gbinder-python")
    (synopsis "Python bindings for libgbinder")
    (description "Cython extension module for gbinder")
    (license license:gpl3)))

(define-public ricochet-refresh
  (package
    (name "ricochet-refresh")
    (version "3.0.27")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/blueprint-freespeech/ricochet-refresh")
             (recursive? #t)
             (commit "v3.0.27-release")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "06clv5cbmwf6j3lby5fqbxvyadsy7cffy72257mhcn07dqwk2jz9"))))
    (build-system cmake-build-system)
    (arguments
     `(#:tests? #f
       #:build-type "Release"
       #:phases (modify-phases %standard-phases
                  (add-before 'configure 'chdir
                    (lambda _
                      (chdir "src")))
                  (add-after 'install 'wrap
                    (lambda* (#:key inputs outputs #:allow-other-keys)
                      (wrap-program (string-append (assoc-ref outputs "out")
                                                   "/bin/ricochet-refresh")
                        `(QML2_IMPORT_PATH suffix
                                           (,(string-append (assoc-ref inputs
                                                             "qtdeclarative")
                                                            "/lib/qt5/qml") ,(string-append
                                                                              (assoc-ref
                                                                               inputs
                                                                               "qtquickcontrols")
                                                                              "/lib/qt5/qml")))))))))
    (inputs (list openssl
                  qtbase-5
                  qtdeclarative-5
                  qttools-5
                  qtmultimedia-5
                  qtquickcontrols-5
                  qtquickcontrols2-5
                  protobuf
                  libxkbcommon))
    (home-page "https://www.ricochetrefresh.net/")
    (synopsis "Anonymous peer-to-peer instant messaging")
    (description
     "Ricochet Refresh is an instant messenger where no one knows your identity, who you're talking to, or what you're talking about.")
    (license license:bsd-3)))

(define-public sbctl
  (package
    (name "sbctl")
    (version "0.15.4")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/Foxboron/sbctl")
             (commit "a53a6ba59ccf")))
       (file-name (git-file-name name version))
       (modules '((guix build utils)))
       (snippet #~(begin
                    (invoke (string-append #$git "/bin/git") "apply"
                            #$(local-file (search-patch
                                           "laura/packages/patches/sbctl-remove-tpm-and-landlock-support.patch")))
                    (delete-file-recursively "tests")))
       (sha256
        (base32 "0qgf3ywpv1rxplhk2jj7zzvyyagk90lxqs7brn4ai7i4pp6v9bq8"))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
      #:unpack-path "github.com/foxboron/sbctl"
      #:import-path "github.com/foxboron/sbctl/cmd/sbctl"))
    (propagated-inputs (list go-golang-org-x-sys
                             go-golang-org-x-exp
                             go-github-com-spf13-cobra
                             go-github-com-spf13-afero
                             go-github-com-onsi-gomega
                             go-github-com-google-uuid
                             go-github-com-goccy-go-yaml
                             go-github-com-foxboron-go-uefi-authenticode
                             go-github-com-foxboron-go-uefi-efi
                             go-github-com-foxboron-go-uefi-efivar
                             go-github-com-foxboron-go-uefi-efivarfs
                             go-github-com-foxboron-go-uefi-pkcs7
                             go-github-com-fatih-color))
    (home-page "https://github.com/foxboron/sbctl")
    (synopsis "sbctl - Secure Boot Manager")
    (description
     "sbctl intends to be a user-friendly secure boot key manager capable of setting
up secure boot, offer key management capabilities, and keep track of files that
needs to be signed in the boot chain.")
    (license license:expat)))

(define-public vbmeta-disable-verification
  (package
    (name "vbmeta-disable-verification")
    (version "1.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/libxzr/vbmeta-disable-verification")
             (commit "v1.0")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1qzgf463xj7ks1hrmmsh0hvb67hraayz8qzjn4y3s3bn95k92pls"))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:phases
      #~(modify-phases %standard-phases
          (replace 'configure
            (lambda _
              (chdir "jni")))
          (replace 'build
            (lambda _
              (system "gcc -O2 -o vbmeta-disable-verification main.c")))
          (delete 'check)
          (replace 'install
            (lambda* (#:key outputs #:allow-other-keys)
              (install-file "vbmeta-disable-verification"
                            (string-append (assoc-ref outputs "out") "/bin/")))))))
    (home-page "https://github.com/libxzr/vbmeta-disable-verification")
    (synopsis
     "Patch Android vbmeta image and disable verification flags inside.")
    (description
     "Give it a vbmeta image and then verification will be disabled on it.")
    (license license:expat)))

(define-public wasmtime
  (package
    (name "wasmtime")
    (version "24.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wasmtime-cli" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (modules '((guix build utils)))
       (snippet #~(begin
                    (substitute* "Cargo.toml"
                      (("1.78.0")
                       "1.77.0"))))
       (sha256
        (base32 "1q0m6wycrdw7vv9b73ckqmcx5fh7xim1m5dh0f4xrihdff1ys5j2"))))
    (build-system cargo-build-system)
    (native-inputs (list pkg-config))
    (inputs (list (list zstd "lib")))
    (arguments
     `(#:tests? #f
       #:cargo-inputs (("rust-anyhow" ,rust-anyhow-1)
                       ("rust-anyhow" ,rust-anyhow-1)
                       ("rust-async-trait" ,rust-async-trait-0.1)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-clap" ,rust-clap-4)
                       ("rust-http" ,rust-http-1)
                       ("rust-http-body-util" ,rust-http-body-util-0.1.1)
                       ("rust-humantime" ,rust-humantime-2)
                       ("rust-hyper" ,rust-hyper-1.3)
                       ("rust-listenfd" ,rust-listenfd-1)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-rustix" ,rust-rustix-0.38.34)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-derive" ,rust-serde-derive-1.203)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-target-lexicon" ,rust-target-lexicon-0.12.16)
                       ("rust-tempfile" ,rust-tempfile-3)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-tracing" ,rust-tracing-0.1)
                       ("rust-wasi-common" ,rust-wasi-common-24)
                       ("rust-wasmparser" ,rust-wasmparser-0.215)
                       ("rust-wasmtime" ,rust-wasmtime-24)
                       ("rust-wasmtime-cache" ,rust-wasmtime-cache-24)
                       ("rust-wasmtime-cli-flags" ,rust-wasmtime-cli-flags-24)
                       ("rust-wasmtime-cranelift" ,rust-wasmtime-cranelift-24)
                       ("rust-wasmtime-environ" ,rust-wasmtime-environ-24)
                       ("rust-wasmtime-explorer" ,rust-wasmtime-explorer-24)
                       ("rust-wasmtime-wasi" ,rust-wasmtime-wasi-24)
                       ("rust-wasmtime-wasi-http" ,rust-wasmtime-wasi-http-24)
                       ("rust-wasmtime-wasi-keyvalue" ,rust-wasmtime-wasi-keyvalue-24)
                       ("rust-wasmtime-wasi-nn" ,rust-wasmtime-wasi-nn-24)
                       ("rust-wasmtime-wasi-runtime-config" ,rust-wasmtime-wasi-runtime-config-24)
                       ("rust-wasmtime-wasi-threads" ,rust-wasmtime-wasi-threads-24)
                       ("rust-wasmtime-wast" ,rust-wasmtime-wast-24)
                       ("rust-wat" ,rust-wat-1))
       #:cargo-development-inputs (("rust-async-trait" ,rust-async-trait-0.1)
                                   ("rust-bstr" ,rust-bstr-1)
                                   ("rust-bytesize" ,rust-bytesize-1)
                                   ("rust-capstone" ,rust-capstone-0.12)
                                   ("rust-cranelift-codegen" ,rust-cranelift-codegen-0.111)
                                   ("rust-cranelift-reader" ,rust-cranelift-reader-0.111)
                                   ("rust-criterion" ,rust-criterion-0.5)
                                   ("rust-env-logger" ,rust-env-logger-0.10)
                                   ("rust-filecheck" ,rust-filecheck-0.5)
                                   ("rust-libc" ,rust-libc-0.2)
                                   ("rust-libtest-mimic" ,rust-libtest-mimic-0.7)
                                   ("rust-log" ,rust-log-0.4)
                                   ("rust-memchr" ,rust-memchr-2)
                                   ("rust-num-cpus" ,rust-num-cpus-1)
                                   ("rust-object" ,rust-object-0.36)
                                   ("rust-rayon" ,rust-rayon-1)
                                   ("rust-serde" ,rust-serde-1)
                                   ("rust-serde-json" ,rust-serde-json-1)
                                   ("rust-similar" ,rust-similar-2)
                                   ("rust-tempfile" ,rust-tempfile-3)
                                   ("rust-tokio" ,rust-tokio-1)
                                   ("rust-toml" ,rust-toml-0.8)
                                   ("rust-walkdir" ,rust-walkdir-2)
                                   ("rust-wasmtime" ,rust-wasmtime-24)
                                   ("rust-wasmtime-component-util" ,rust-wasmtime-component-util-24)
                                   ("rust-wasmtime-wast" ,rust-wasmtime-wast-24)
                                   ("rust-wast" ,rust-wast-215)
                                   ("rust-wat" ,rust-wat-1)
                                   ("rust-windows-sys" ,rust-windows-sys-0.52)
                                   ("rust-wit-component" ,rust-wit-component-0.215))))
    (home-page "https://github.com/bytecodealliance/wasmtime")
    (synopsis "Command-line interface for Wasmtime")
    (description "This package provides Command-line interface for Wasmtime.")
    (license license:asl2.0)))

(define-public waydroid
  (package
    (name "waydroid")
    (version "1.5.4")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/waydroid/waydroid")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "050cn84ambjd02cnszp9qqgzm62x14jxg9jp7fxrzbv6qps8k2rb"))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'configure)
          (delete 'build)
          (add-before 'install 'patch-environment
            (lambda _
              (substitute* "Makefile"
                (("PREFIX := /usr")
                 (string-append "PREFIX := "
                                #$output "\nUSE_SYSTEMD := 0"))
                (("\\/etc")
                 "$(PREFIX)/etc"))))
          (add-after 'install 'wrap-script
            (lambda _
              (let* ((python-version (string-join (list (list-ref (string-split #$
                                                                   (package-version
                                                                    python)
                                                                   #\.) 0)
                                                        (list-ref (string-split #$
                                                                   (package-version
                                                                    python)
                                                                   #\.) 1))
                                                  "."))
                     (packages-path (string-append "/lib/python"
                                                   python-version
                                                   "/site-packages")))
                (wrap-program (string-append #$output "/bin/waydroid")
                  `("PYTHONPATH" suffix
                    (,(string-append #$python-gbinder packages-path) ,(string-append #$python-dbus
                                                                       packages-path)
                     ,(string-append #$python-pygobject packages-path)))
                  `("PATH" suffix
                    (,(string-append #$lxc "/bin") ,(string-append #$dnsmasq
                                                                   "/sbin")
                     ,(string-append #$iproute "/sbin")))
                  `("GI_TYPELIB_PATH" suffix
                    (,(string-append #$glib "/lib/girepository-1.0"))))))))))
    (inputs (list python
                  python-gbinder
                  python-dbus
                  python-pygobject
                  glib
                  lxc
                  dnsmasq
                  iproute))
    (home-page "https://waydro.id")
    (synopsis
     "Waydroid uses a container-based approach to boot a full Android system on a regular GNU/Linux system like Ubuntu.")
    (description
     "Waydroid uses Linux namespaces (user, pid, uts, net, mount, ipc) to run a full Android system in a container and provide Android applications on any GNU/Linux-based platform.")
    (license license:gpl3)))

(define-public wshowkeys
  (package
    (name "wshowkeys")
    (version "1.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://git.sr.ht/~sircmpwn/wshowkeys")
             (commit "6388a49e0f431d6d5fcbd152b8ae4fa8e87884ee")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "10kafdja5cwbypspwhvaxjz3hvf51vqjzbgdasl977193cvxgmbs"))))
    (build-system meson-build-system)
    (native-inputs (list cmake pkg-config))
    (inputs (list cairo
                  libinput
                  pango
                  wayland
                  wayland-protocols
                  libxkbcommon))
    (arguments
     `(#:tests? #f))
    (home-page "https://git.sr.ht/~sircmpwn/wshowkeys")
    (synopsis "Displays keys being pressed on a Wayland session")
    (description
     "Displays keypresses on screen on supported Wayland compositors (requires wlr_layer_shell_v1 support).")
    (license license:gpl3)))

(define-public yara
  (package
    (name "yara")
    (version "4.5.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/VirusTotal/yara")
             (commit "v4.5.1")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1b8fj83lr5m0pma3rj1l5rkjkn69hrfd1hnl5zrjdsik4nq532i4"))))
    (build-system gnu-build-system)
    (native-inputs (list autoconf automake libtool pkg-config))
    (inputs (list protobuf-c openssl))
    (arguments
     (list
      #:tests? #f))
    (home-page "https://virustotal.github.io/yara/")
    (synopsis "The pattern matching swiss knife")
    (description
     "YARA is a tool aimed at (but not limited to) helping malware researchers to identify and classify malware samples.")
    (license license:bsd-3)))

(define-public lite
  (package
    (name "lite")
    (version "1.11")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/rxi/lite")
             (commit "v1.11")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0wxqfb4ly8g7w5qph76xys95b55ackkags8jgd1nasmiyi8gcd5a"))))
    (build-system gnu-build-system)
    (inputs (list sdl2))
    (arguments
     (list
      #:phases
      #~(modify-phases %standard-phases
          (delete 'configure)
          (replace 'build
            (lambda* (#:key outputs #:allow-other-keys)
              (system "./build.sh")))
          (delete 'check)
          (replace 'install
            (lambda* (#:key outputs #:allow-other-keys)
              (begin
                (install-file "lite"
                              (string-append (assoc-ref outputs "out") "/bin"))
                (copy-recursively "data"
                                  (string-append (assoc-ref outputs "out")
                                                 "/bin/data"))))))))
    (home-page "https://github.com/rxi/lite")
    (synopsis "A lightweight text editor written in Lua")
    (description
     "lite is a lightweight text editor written mostly in Lua — it aims to provide something practical, pretty, small and fast, implemented as simply as possible; easy to modify and extend, or to use without doing either.")
    (license license:expat)))

(define-public ags
  (package
    (name "ags")
    (version "2.2.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/Aylur/ags")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1py4ii6jpkjdxf00pb4lbpiwgrg6xfhh4nlib4111wh70w1f2wdj"))
       (modules '((guix build utils)))
       (snippet #~(begin
                    (substitute* "go.mod"
                      (("ags")
                       "github.com/Aylur/ags"))
                    (map (lambda (x)
                           (substitute* x
                             (("\"ags/")
                              "\"github.com/Aylur/ags/")))
                         (list "main.go"
                               "cmd/bundle.go"
                               "cmd/init.go"
                               "cmd/inspect.go"
                               "cmd/list.go"
                               "cmd/quit.go"
                               "cmd/request.go"
                               "cmd/run.go"
                               "cmd/toggle.go"
                               "cmd/types.go"))))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/Aylur/ags"))
    (propagated-inputs (list go-github-com-evanw-esbuild-internal
                             go-github-com-evanw-esbuild-api
                             go-github-com-spf13-cobra
                             go-github-com-titanous-json5))
    (home-page "https://github.com/spf13/cobra")
    (synopsis "Scaffolding CLI for Astal+TypeScript")
    (description "CLI around Astal to scaffold and run projects")
    (license license:gpl3)))

(define-public astral-io
  (package
    (name "astral-io")
    (version "0.0.0-a3bb83a22b7d237c2c2fc6bd531f30d6265135cf")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/Aylur/astal")
             (commit "a3bb83a22b7d237c2c2fc6bd531f30d6265135cf")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1m78w5llnbg6cdcd8yabknn7sz7527rn8h6lgm1wfz3c896y6qz0"))))
    (build-system meson-build-system)
    (inputs (list glib))
    (native-inputs (list vala pkg-config gobject-introspection))
    (arguments
     (list
      #:phases
      #~(modify-phases %standard-phases
          (add-before 'configure 'chdir
            (lambda _
              (chdir "lib/astal/io"))))))
    (home-page "https://aylur.github.io/astal/")
    (synopsis "Building blocks for creating custom desktop shells")
    (description "Building blocks for creating custom desktop shells")
    (license license:lgpl2.1)))

(define-public astral-gtk3
  (package
    (name "astral-gtk3")
    (version "0.0.0-a3bb83a22b7d237c2c2fc6bd531f30d6265135cf")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/Aylur/astal")
             (commit "a3bb83a22b7d237c2c2fc6bd531f30d6265135cf")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1m78w5llnbg6cdcd8yabknn7sz7527rn8h6lgm1wfz3c896y6qz0"))))
    (build-system meson-build-system)
    (inputs (list astral-io gtk+ gtk-layer-shell))
    (native-inputs (list vala pkg-config gobject-introspection))
    (arguments
     (list
      #:phases
      #~(modify-phases %standard-phases
          (add-before 'configure 'chdir
            (lambda _
              (chdir "lib/astal/gtk3"))))))
    (home-page "https://aylur.github.io/astal/")
    (synopsis "Building blocks for creating custom desktop shells")
    (description "Building blocks for creating custom desktop shells")
    (license license:lgpl2.1)))

(define-public hyprpanel
  (package
    (name "hyprpanel")
    (version "0.0.0-a7b553725c1deb4a856ddd8582fa217451533ec3")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/Jas-SinghFSU/HyprPanel")
             (commit "a7b553725c1deb4a856ddd8582fa217451533ec3")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0y25ns6nizszq0h5d31ihsjcaxpsp1cc5a5ixklcdq3x8r7gsrnq"))))
    (build-system meson-build-system)
    (inputs (list astral-gtk3 astral-io))
    (native-inputs (list ags gjs))
    (home-page "https://www.gnu.org/software/hello/")
    (synopsis "A Bar/Panel for Hyprland with extensive customizability.")
    (description "A panel built for Hyprland with Astal")
    (license license:expat)))

(define-public binsider
  (package
    (name "binsider")
    (version "0.2.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "binsider" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "052hw02wb92zyb1g3p6b5z5fs1gifgzccj8q7v08nff9x7r3dscs"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-ansi-to-tui" ,rust-ansi-to-tui-6)
                       ("rust-better-panic" ,rust-better-panic-0.3)
                       ("rust-bytesize" ,rust-bytesize-1)
                       ("rust-chrono" ,rust-chrono-0.4)
                       ("rust-clap" ,rust-clap-4.5.20)
                       ("rust-console" ,rust-console-0.15)
                       ("rust-elf" ,rust-elf-0.7)
                       ("rust-heh" ,rust-heh-0.6)
                       ("rust-itertools" ,rust-itertools-0.13)
                       ("rust-lddtree" ,rust-lddtree-0.3)
                       ("rust-lurk-cli" ,rust-lurk-cli-0.3)
                       ("rust-nix" ,rust-nix-0.29)
                       ("rust-ratatui" ,rust-ratatui-0.28)
                       ("rust-rust-strings" ,rust-rust-strings-0.6)
                       ("rust-sysinfo" ,rust-sysinfo-0.32)
                       ("rust-termbg" ,rust-termbg-0.5)
                       ("rust-textwrap" ,rust-textwrap-0.16)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-tui-big-text" ,rust-tui-big-text-0.6)
                       ("rust-tui-input" ,rust-tui-input-0.10)
                       ("rust-tui-popup" ,rust-tui-popup-0.5)
                       ("rust-unicode-width" ,rust-unicode-width-0.2)
                       ("rust-webbrowser" ,rust-webbrowser-1)
                       ("rust-which" ,rust-which-6))
       #:cargo-development-inputs (("rust-pretty-assertions" ,rust-pretty-assertions-1))))
    (home-page "https://binsider.dev")
    (synopsis "Analyze ELF binaries like a boss")
    (description "This package provides Analyze ELF binaries like a boss.")
    (license (list license:expat license:asl2.0))))

(define-public mbw
  (package
    (name "mbw")
    (version "2.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "http://github.com/raas/mbw")
             (commit "v2.0")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0p3lpa9bmix1za53q0n77swp4bx4myasz53wqspf62q52hwsxx50"))))
    (build-system cmake-build-system)
    (arguments
     (list
      #:tests? #f
      #:build-type "Release"))
    (home-page " http://github.com/raas/mbw")
    (synopsis "Memory Bandwidth Benchmark")
    (description
     "MBW determines the \"copy\" memory bandwidth available to userspace programs. Its simplistic approach models that of real applications. It is not tuned to extremes and it is not aware of hardware architecture, just like your average software package.")
    (license license:gpl3)))

(define-public binwalk-3
  (package
    (name "binwalk")
    (version "3.1.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "binwalk" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0488gsnmlrsbf1j5ciq0s03ir76ys7jdm2h99xi5a702ymqdrmcr"))))
    (build-system cargo-build-system)
    (native-inputs (list pkg-config))
    (inputs (list fontconfig))
    (arguments
     `(#:tests? #f
       #:cargo-inputs (("rust-aho-corasick" ,rust-aho-corasick-1)
                       ("rust-base64" ,rust-base64-0.22.1)
                       ("rust-bzip2" ,rust-bzip2-0.4)
                       ("rust-chrono" ,rust-chrono-0.4)
                       ("rust-clap" ,rust-clap-4)
                       ("rust-colored" ,rust-colored-2)
                       ("rust-crc32-v2" ,rust-crc32-v2-0.0.4)
                       ("rust-crc32c" ,rust-crc32c-0.6)
                       ("rust-entropy" ,rust-entropy-0.4)
                       ("rust-env-logger" ,rust-env-logger-0.11)
                       ("rust-flate2" ,rust-flate2-1)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-plotters" ,rust-plotters-0.3.7)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-termsize" ,rust-termsize-0.1.9)
                       ("rust-threadpool" ,rust-threadpool-1)
                       ("rust-uuid" ,rust-uuid-1)
                       ("rust-walkdir" ,rust-walkdir-2)
                       ("rust-xxhash-rust" ,rust-xxhash-rust-0.8)
                       ("rust-xz2" ,rust-xz2-0.1))))
    (home-page "https://github.com/ReFirmLabs/binwalk")
    (synopsis "Analyzes data for embedded file types")
    (description
     "This package provides Analyzes data for embedded file types.")
    (license license:expat)))

(define-public cshatag
  (package
    (name "cshatag")
    (version "2.2.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/rfjakob/cshatag")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0b9zgkdbfiq1nhw6w0ddvyq55b82zg80ngzhbhxsi275lxp0z926"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/rfjakob/cshatag"))
    (propagated-inputs (list go-github-com-pkg-xattr))
    (home-page "https://github.com/rfjakob/cshatag")
    (synopsis "Similar Tools")
    (description
     "@@url{https://github.com/rfjakob/cshatag/actions/workflows/ci.yml,(img (@@ (src
https://github.com/rfjakob/cshatag/actions/workflows/ci.yml/badge.svg) (alt
CI)))} @@url{https://goreportcard.com/report/github.com/rfjakob/cshatag,(img (@@
(src https://goreportcard.com/badge/github.com/rfjakob/cshatag) (alt Go Report
Card)))} • @@url{#readme-Changelog,View Changelog} •
@@url{https://github.com/rfjakob/cshatag/releases,Download Binary Releases}.")
    (license license:expat)))

(define-public dsvpn
  (package
    (name "dsvpn")
    (version "0.1.4")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/jedisct1/dsvpn")
             (commit "327928d")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1z0nligx2v2kp707z9rpi9p5y347zzniclxciv98zpa0h7f9j9b8"))))
    (build-system zig-build-system)
    (arguments
     (list
      #:tests? #f))
    (home-page "https://github.com/jedisct1/dsvpn")
    (synopsis "A Dead Simple VPN.")
    (description
     "DSVPN is a Dead Simple VPN, designed to address the most common use case for using a VPN.")
    (license license:expat)))

(define openssl-with-compression
  (package/inherit openssl
    (inputs (list zlib))
    (arguments (substitute-keyword-arguments (package-arguments openssl)
                 ((#:phases phases
                   '%standard-phases)
                  #~(modify-phases #$phases
                      (replace 'configure
                        (lambda* (#:key configure-flags #:allow-other-keys)
                          ;; It's not a shebang so patch-source-shebangs misses it.
                          (substitute* "config"
                            (("/usr/bin/env")
                             (which "env")))
                          (apply invoke
                                 #$@(if (%current-target-system)
                                        #~("./Configure")
                                        #~("./config"))
                                 "shared" ;build shared libraries
                                 "--libdir=lib"

                                 ;; The default for this catch-all directory is
                                 ;; PREFIX/ssl.  Change that to something more
                                 ;; conventional.
                                 (string-append "--openssldir="
                                                #$output "/share/openssl-"
                                                #$(package-version
                                                   this-package))

                                 (string-append "--prefix="
                                                #$output)
                                 (string-append "-Wl,-rpath,"
                                                (string-append #$output "/lib"))
                                 "enable-weak-ssl-ciphers"
                                 "zlib"
                                 #$@(if (%current-target-system)
                                        #~((getenv "CONFIGURE_TARGET_ARCH"))
                                        #~())
                                 configure-flags)
                          ;; Output the configure variables.
                          (invoke "perl" "configdata.pm" "--dump")))
                      (replace 'remove-miscellany
                        (lambda _
                          ;; The 'misc' directory contains random undocumented shell and
                          ;; Perl scripts.  Remove them to avoid retaining a reference on
                          ;; Perl.
                          (delete-file-recursively (string-append #$output
                                                    "/share/openssl-"
                                                    #$(package-version
                                                       this-package) "/misc"))))))))))

(define-public sslscan
  (package
    (name "sslscan")
    (version "2.1.6")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/rbsec/sslscan")
             (commit "2.1.6")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0bkvv5w5qi2yqxxrdpd0nzgz3wdl6b0xq6md4pzl8zkf3g016njw"))))
    (build-system gnu-build-system)
    (inputs (list openssl-with-compression))
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (replace 'configure
            (lambda _
              (setenv "CC" "gcc")))
          (replace 'install
            (lambda _
              (install-file "sslscan"
                            (string-append #$output "/bin")))))))
    (home-page "https://github.com/rbsec/sslscan")
    (synopsis
     "Test SSL/TLS enabled services to discover supported cipher suites.")
    (description
     "sslscan version 2 has now been released. This includes a major rewrite of the backend scanning code, which means that it is no longer reliant on the version of OpenSSL for many checks. This means that it is possible to support legacy protocols (SSLv2 and SSLv3), as well as supporting TLSv1.3 - regardless of the version of OpenSSL that it has been compiled against.")
    (license license:gpl3)))

(define-public ssh-audit
  (package
    (name "ssh-audit")
    (version "3.3.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "ssh_audit" version))
       (sha256
        (base32 "1c55c5k0ybfm7fs9zhid8486lxj69cx2k7vck1j5vx24k2n3cvmp"))))
    (build-system pyproject-build-system)
    (native-inputs (list python-setuptools python-wheel))
    (home-page "https://github.com/jtesta/ssh-audit")
    (synopsis "An SSH server & client configuration security auditing tool")
    (description
     "An SSH server & client configuration security auditing tool.")
    (license license:expat)))

(define-public simdutf
  (package
    (name "simdutf")
    (version "6.2.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/simdutf/simdutf")
             (commit "v6.2.0")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1r6hw3ds4rjjq6s2zmrbmqfmsiyy57bg5zwldckprk16l0jb0clj"))))
    (build-system cmake-build-system)
    (arguments
     (list
      #:build-type "Release"))
    (home-page "https://github.com/simdutf/simdutf")
    (synopsis
     "simdutf: Unicode validation and transcoding at billions of characters per second")
    (description
     "Unicode routines (UTF8, UTF16, UTF32) and Base64: billions of characters per second using SSE2, AVX2, NEON, AVX-512, RISC-V Vector Extension, LoongArch64. Part of Node.js, WebKit/Safari, Ladybird, Chromium, Cloudflare Workers and Bun.")
    (license license:asl2.0)))

(define-public bzip3
  (package
    (name "bzip3")
    (version "1.5.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/kspalaiologos/bzip3")
             (commit "1.5.1")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0f81a05rp6y8bmi9ffwvyfilnp8rlfrvxn7v86k1srzlqg8cmjs0"))
       (snippet #~(let ((file (open-output-file ".tarball-version")))
                    (display "1.5.1" file)
                    (close-output-port file)))))
    (build-system gnu-build-system)
    (native-inputs (list autoconf automake libtool pkg-config git))
    (home-page "https://github.com/kspalaiologos/bzip3")
    (synopsis "A better and stronger spiritual successor to BZip2.")
    (description
     "A better, faster and stronger spiritual successor to BZip2. Features higher compression ratios and better performance thanks to a order-0 context mixing entropy coder, a fast Burrows-Wheeler transform code making use of suffix arrays and a RLE with Lempel Ziv+Prediction pass based on LZ77-style string matching and PPM-style context modeling.

Like its ancestor, BZip3 excels at compressing text or code.")
    (license license:lgpl3)))

(define-public faest-ref
  (package
    (name "faest-ref")
    (version "2.0.3")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/faest-sign/faest-ref")
             (recursive? #t)
             (commit "v2.0.3")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0bawgc34piswbbkz62sk9ybmai8cqjw5jvcx82495mz96xjirsva"))))
    (build-system meson-build-system)
    (native-inputs (list python-3))
    (home-page "https://faest.info")
    (synopsis "FAEST reference implementation")
    (description "FAEST reference implementation")
    (license license:expat)))

(define-public cpu-rec-rs
  (package
    (name "cpu-rec-rs")
    (version "1.0.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/trou/cpu_rec_rs")
             (commit (string-append "release-" version))))
       (file-name (string-append name "-" version ".tar.gz"))
       (patches (search-patches
                 "laura/packages/patches/cpu-rec-rs-corpus.patch"))
       (sha256
        (base32 "0xhayjf7m1v64dy6d9rvwih3ck97gnhalz3xvrjshh0ak9rm9i6i"))))
    (build-system cargo-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'install 'copy-corpus
            (lambda _
              (copy-recursively "cpu_rec_corpus"
                                (string-append #$output
                                               "/share/cpu_rec_corpus")))))
      #:cargo-inputs `(("rust-anyhow" ,rust-anyhow-1)
                       ("rust-clap" ,rust-clap-4.4)
                       ("rust-glob" ,rust-glob-0.3)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-simple-logger" ,rust-simple-logger-4)
                       ("rust-tablestream" ,rust-tablestream-0.1)
                       ("rust-assert-approx-eq" ,rust-assert-approx-eq-1))))
    (home-page "https://github.com/trou/cpu_rec_rs")
    (synopsis "Determine which CPU architecture is used in a binary file.")
    (description
     "cpu_rec_rs is a Rust reimplementation of the original cpu_rec.")
    (license license:asl2.0)))

(define-public echfs-fuse
  (package
    (name "echfs-fuse")
    (version "1.0.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/echfs/echfs")
             (commit "ed17326")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1ns3aipiz12pidql3jyv43v14nlwxjqqz1bxfichq8aw2grdy3bw"))))
    (build-system gnu-build-system)
    (native-inputs (list pkg-config autoconf automake libtool))
    (inputs (list fuse))
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (add-before 'bootstrap 'chdir
            (lambda _
              (chdir "echfs-fuse"))))))
    (home-page "https://github.com/echfs/echfs")
    (synopsis "The echfs filesystem")
    (description
     "The echfs filesystem is a 64-bit FAT-like filesystem which aims to support most UNIX and POSIX-style features while being extremely simple to implement. Ideal for hobbyist OS developers who want a simple filesystem and don't want to deal with old crufty FAT (which isn't UNIX/POSIX compliant either), or complex filesystems such as ext2/3/4.")
    (license license:bsd-2)))

(define-public echfs-utils
  (package/inherit echfs-fuse
    (name "echfs-utils")
    (inputs (list `(,util-linux "lib")))
    (arguments (list #:tests? #f
                     #:phases #~(modify-phases %standard-phases
                                  (add-before 'bootstrap 'chdir
                                    (lambda _
                                      (chdir "echfs-utils"))))))))

(define-public dumpasn1
  (package
    (name "dumpasn1")
    (version "20230207.0.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/katexochen/dumpasn1")
             (commit "v20230207.0.0")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0wv9rf92hjrzgy4rrymsra8gz0qan6vjpwxxnwdjd36x4b6ir3dg"))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (replace 'configure
            (lambda _
              (list (setenv "CC" "gcc")
                    (setenv "prefix"
                            #$output)
                    (substitute* "dumpasn1.c"
                      (("/etc/dumpasn1/")
                       (string-append #$output "/etc/")))))))))
    (home-page "https://www.cs.auckland.ac.nz/~pgut001/#standards")
    (synopsis "Display and debug ASN.1 data")
    (description
     "dumpasn1 is an ASN.1 object dump program that will dump data encoded using any of the ASN.1 encoding rules in a variety of user-specified formats.")
    (license license:bsd-2)))

(define-public python-jschon
  (package
    (name "python-jschon")
    (version "0.11.1")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "jschon" version))
       (sha256
        (base32 "17qlpwaq5xv5szm93bpkg9waf166bvbixf96sw1llsgin7m0pjn0"))))
    (build-system pyproject-build-system)
    (arguments
     (list
      #:tests? #f))
    (propagated-inputs (list python-rfc3986))
    (native-inputs (list python-coverage
                         python-hypothesis
                         python-pytest
                         python-pytest-benchmark
                         python-pytest-httpserver
                         python-requests
                         python-setuptools
                         python-tox
                         python-wheel))
    (home-page "https://github.com/marksparkza/jschon")
    (synopsis "A JSON toolkit for Python developers.")
    (description "This package provides a JSON toolkit for Python developers.")
    (license license:expat)))

(define-public python-pyvcd
  (package
    (name "python-pyvcd")
    (version "0.4.1")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "pyvcd" version))
       (sha256
        (base32 "15nnydvr1a4ykh8cagi484sfgvdg0dnjxaw6c0ivhjbrbblpaqnw"))))
    (build-system pyproject-build-system)
    (native-inputs (list python-setuptools python-setuptools-scm python-wheel))
    (home-page "http://pyvcd.readthedocs.io/en/latest/")
    (synopsis "Python VCD file support")
    (description "Python VCD file support.")
    (license license:expat)))

(define-public amaranth
  (package
    (name "amaranth")
    (version "0.5.4")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "amaranth" version))
       (sha256
        (base32 "1zd4p14v7xi61qjwhip1gd1j75r7glkl6g5m4iahvc4a6pz7zsm0"))))
    (build-system pyproject-build-system)
    (arguments
     (list
      #:tests? #f))
    (propagated-inputs (list python-importlib-resources
                             python-jinja2
                             python-jschon
                             python-paramiko
                             python-pyvcd
                             yosys))
    (native-inputs (list python-pdm-backend))
    (home-page "https://amaranth-lang.org/")
    (synopsis "Amaranth hardware definition language")
    (description "Amaranth hardware definition language.")
    (license license:bsd-2)))

(define-public badkeys
  (package
    (name "badkeys")
    (version "0.0.13")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "badkeys" version))
       (sha256
        (base32 "03jkairy3bps5h1yn0rbpy4d2bmq100if95nd9r3v691c94s44v0"))))
    (build-system pyproject-build-system)
    (arguments
     (list
      #:tests? #f))
    (propagated-inputs (list python-cryptography python-gmpy2))
    (native-inputs (list python-setuptools python-setuptools-scm python-wheel))
    (home-page "https://badkeys.info/")
    (synopsis "Check cryptographic keys for known weaknesses")
    (description "Check cryptographic keys for known weaknesses.")
    (license license:expat)))

(define-public ssh-x25519
  (package
    (name "ssh-x25519")
    (version "0.0.0-20211029144534-88351537beaf")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/arachsys/ssh-x25519")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0jgr40jx5fsywqyqw2d4mah0smmayr0ww7f9j6gww6cbkca1z996"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/arachsys/ssh-x25519"))
    (propagated-inputs (list go-golang-org-x-term go-golang-org-x-crypto
                             go-filippo-io-edwards25519))
    (home-page "https://github.com/arachsys/ssh-x25519")
    (synopsis "Map ssh-ed25519 keys into x25519 keys")
    (description
     "
The twisted Edwards curve used for Ed25519 signatures is birationally
equivalent to the Montgomery curve used for X25519. In Ed25519, the secret
scalar is half of the private key's SHA512 hash, whereas X25519 uses the
private key directly as a scalar. It is therefore straightforward to map
ssh-ed25519 keys into X25519 keys preserving keypair correspondence.")
    (license license:expat)))

(define-public die-engine
  (package
    (name "die-engine")
    (version "3.10")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/horsicq/DIE-engine")
             (recursive? #t)
             (commit "3.10")))
       (file-name (git-file-name name version))
       (patches (search-patches "laura/packages/patches/die-engine-db.patch"))
       (sha256
        (base32 "057w3317045q72q2ipcd68jrpqls6r4pjw2ckhv2d6rr51i32y68"))))
    (build-system cmake-build-system)
    (arguments
     (list
      #:tests? #f
      #:build-type "Release"))
    (inputs (list qtbase-5 qtsvg-5 qtscript-5))
    (home-page "https://github.com/horsicq/DIE-engine")
    (synopsis "DIE engine")
    (description "GUI & console sources for Detect It Easy(DiE)")
    (license license:expat)))

(define %glibc-patches
  (list "glibc-ldd-powerpc.patch"
        "glibc-2.41-ldd-x86_64.patch"
        "glibc-2.40-dl-cache.patch"
        "glibc-2.37-versioned-locpath.patch"
        "glibc-reinstate-prlimit64-fallback.patch"
        "glibc-supported-locales.patch"
        "glibc-2.37-hurd-clock_t_centiseconds.patch"
        "glibc-2.41-hurd-local-clock_gettime_MONOTONIC.patch"
        "glibc-hurd-mach-print.patch"
        "glibc-hurd-gettyent.patch"
        "glibc-hurd-getauxval.patch"
        "glibc-hurd-pthread_setcancelstate.patch"
        "glibc-hurd-2.41-pthread-once.patch"
        "glibc-hurd-2.41-pthread-sigmask.patch"
        "glibc-hurd-2.41-symlink.patch"
        "glibc-hurd64-intr-msg-clobber.patch"
        "glibc-hurd64-gcc-14.2-tls-bug.patch"))

(define-public glibc-ld
  (package
    (inherit glibc)
    (name "glibc-ld")
    (version (package-version glibc))
    (source
     (origin
       (method url-fetch)
       (uri (string-append "mirror://gnu/glibc/glibc-" version ".tar.xz"))
       (sha256
        (base32 "00g95047sshv0zxk9ja3mi7lzwi8wh8qx0nxngbvgmj5yli6p8m5"))
       (patches (map search-patch
                     (append %glibc-patches
                             (list "laura/packages/patches/glibc-ld.patch"))))))))

(define-public sqlitefs
  (package
    (name "sqlitefs")
    (version "0.1.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/narumatt/sqlitefs")
             (commit "ad19579")))
       (file-name (git-file-name name version))
       (modules '((guix build utils)))
       (snippet #~(substitute* "Cargo.toml"
                    (("\\[\"fs\"\\]")
                     "[\"fs\", \"dir\"]")))
       (sha256
        (base32 "0d1y03dd4bxigjrpw1cbghx083309qsr3y2h3icjvv112zga0gjx"))))
    (build-system cargo-build-system)
    (native-inputs (list pkg-config))
    (inputs (list fuse-2))
    (arguments
     (list
      #:cargo-development-inputs (list rust-chrono-0.4 rust-clap-4.5.26
                                       rust-fuse-0.3 rust-nix-0.29.0
                                       rust-rusqlite-0.20)))
    (home-page "https://github.com/narumatt/sqlitefs")
    (synopsis "sqlite as a filesystem")
    (description
     "sqlite-fs allows Linux and MacOS to mount a sqlite database file as a normal filesystem.")
    (license license:expat)))

(define-public u8_r2_plugin
  (package
    (name "u8_r2_plugin")
    (version "0.0.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/cetus9/u8_r2_plugin")
             (commit "7bedc13")))
       (file-name (git-file-name name version))
       (patches (search-patches "laura/packages/patches/u8_r2_plugin.patch"))
       (sha256
        (base32 "0affzh6c9ybzircmsvqahvryspc32nq7n3f3pqa6kql8zp7az6gf"))))
    (build-system gnu-build-system)
    (native-inputs (list pkg-config))
    (inputs (list radare2 openssl))
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (replace 'configure
            (lambda _
              (setenv "CC" "gcc")))
          (replace 'install
            (lambda _
              (mkdir-p (string-append #$output "/share/radare2/plugins"))
              (copy-file "asm_u8.so"
                         (string-append #$output
                                        "/share/radare2/plugins/asm_u8.so"))
              (copy-file "anal_u8.so"
                         (string-append #$output
                                        "/share/radare2/plugins/anal_u8.so")))))))
    (home-page "https://github.com/cetus9/u8_r2_plugin")
    (synopsis "radare2 plugins for nX-U8/100")
    (description
     "Experimental radare2 disassembly and analysis plugins for nX-U8/100 architecture.")
    (license license:lgpl2.1)))

(define-public acarsdec
  (package
    (name "acarsdec")
    (version "4.3.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/f00b4r0/acarsdec")
             (commit "v4.3.1")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1lgzc7n30xmi2c8llzccvv908mcl3arz72jf91jl5jql1nnjp8mp"))))
    (build-system cmake-build-system)
    (native-inputs (list pkg-config))
    (inputs (list libacars rtl-sdr))
    (arguments
     (list
      #:tests? #f
      #:build-type "Release"
      #:configure-flags
      #~(list "-Drtl=on")))
    (home-page "https://github.com/TLeconte/acarsdec")
    (synopsis "ACARS SDR decoder")
    (description
     "Acarsdec is a multi-channels acars decoder with built-in rtl_sdr, airspy front end or sdrplay device. Since 3.0, It comes with a database backend : acarsserv to store received acars messages.")
    (license license:gpl2)))

(define-public vdr
  (package
    (name "vdr")
    (version "2.7.7")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "git://git.tvdr.de/vdr.git")
             (commit "2.7.7")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1wkz3rs496r4501hvw9g6p0vb1r7sisy619l7lyfxrn4hikw0cwx"))))
    (build-system gnu-build-system)
    (native-inputs (list pkg-config gettext-minimal))
    (inputs (list fontconfig freetype ijg-libjpeg libcap ncurses))
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (replace 'configure
            (lambda _
              (setenv "PREFIX"
                      #$output)
              (substitute* "Makefile"
                (("install-pc install-bin install-conf install-doc install-plugins install-i18n install-includes")
                 "install-pc install-bin install-doc install-plugins install-i18n install-includes")))))))
    (home-page "https://tvdr.de/")
    (synopsis "The Video Disk Recorder")
    (description
     "\"VCR\" was short for \"Video Cassette Recorder\", a device that recorded analog video on tape cassettes. When digital tv came up in the late 1990s, it was only natural to record that data on computer harddisks instead of cassettes. So, in the year 2000 the very first steps were made into programming a \"VDR\", which stands for \"Video Disk Recorder\".

Version 1 of VDR was able to record and play plain old SDTV. The new version 2 can now handle HDTV (High Definition Television).")
    (license license:gpl2)))

(define-public fil-c
  (package
    (name "fil-c")
    (version "0.670")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
              (url "https://github.com/pizlonator/fil-c")
              (commit "v0.670")))
        (file-name (git-file-name name version))
        (sha256 (base32 "1k20h712q8ad5y5bswg9sz45cz3qjyp8k2inl0kq0g9izi2cz6az"))))
    (build-system cmake-build-system)
    (native-inputs (list python-wrapper patchelf ruby clang))
    (arguments (list #:phases #~(modify-phases %standard-phases
      (delete 'configure)
      (replace 'build (lambda _ (invoke "./build_all_fast.sh"))))))
    (home-page "https://github.com/pizlonator/fil-c")
    (synopsis "Fil-C: completely compatible memory safety for C and C++ ")
    (description "Fil-C is a fanatically compatible memory-safe implementation of C and C++. Lots of software compiles and runs with Fil-C with zero or minimal changes. All memory safety errors are caught as Fil-C panics. Fil-C achieves this using a combination of concurrent garbage collection and invisible capabilities (each pointer in memory has a corresponding capability, not visible to the C address space). Every fundamental C operation (as seen in LLVM IR) is checked against the capability. Fil-C has no unsafe escape hatch of any kind.")
    (license license:asl2.0)))

(define-public feather
  (package
    (name "feather")
    (version "2.8.1")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
              (url "https://github.com/feather-wallet/feather")
              (recursive? #t)
              (commit "2.8.1")))
        (file-name (git-file-name name version))
        (sha256 (base32 "18r67kff0kl1gqfri0qja7qq5j7nzwclxignczvasv982xj5340d"))))
    (build-system qt-build-system)
    (inputs (list openssl unbound boost qrencode protobuf zxing-cpp readline qtbase qtsvg qtwebsockets qtmultimedia qtwayland wayland libsodium tor))
    (native-inputs (list python-3))
    (arguments (list #:build-type "Release" #:tests? #f))
    (home-page "https://featherwallet.org/")
    (synopsis "A free and open-source Monero desktop wallet")
    (description "Feather is a free Monero desktop wallet for Linux, Tails, macOS and Windows. It is written in C++ with the Qt framework.")
    (license license:bsd-3)))

(define-public i2p
  (package
    (name "i2p")
    (version "2.7.0")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
              (url "https://github.com/i2p/i2p.i2p")
              (recursive? #t)
              (commit "i2p-2.7.0")))
        (file-name (git-file-name name version))
        (modules '((guix build utils)))
        (snippet #~(begin
          (substitute* "build.xml" (("preppkg-linux, preppkg-freebsd, preppkg-osx, preppkg-windows, jbigi") "preppkg-linux, jbigi"))
          (substitute* "apps/routerconsole/java/build.xml" (("jstlel.jar ") ""))))
        (sha256 (base32 "1s49kxlcjwhcg41jpvzry3i52zkljk9qwhlr17yzqkg67bm643c3"))))
    (native-inputs (list gnu-gettext))
    (arguments (list #:tests? #f #:build-target "tarball" #:phases
      #~(modify-phases %standard-phases
          (replace 'install (lambda _
            (mkdir-p (string-append #$output "/share"))
            (chdir (string-append #$output "/share"))
            (system "tar vfx /tmp/guix-build-i2p-2.7.0.drv-0/source/i2p.tar.bz2")))
          (add-after 'strip-jar-timestamps 'remove-remnants (lambda _
            (chdir #$output)
            (rename-file "share/i2p" "i2p")
            (delete-file-recursively "share")
            (mkdir "share")
            (rename-file "i2p" "share/i2p")
            (chdir "share/i2p")
            (chmod "postinstall.sh" 511)
            (system "./postinstall.sh"))))))
    (build-system ant-build-system)
    (home-page "https://geti2p.net/en/")
    (synopsis "Reference Java implementation of I2P")
    (description "I2P is an anonymizing network, offering a simple layer that identity-sensitive applications can use to securely communicate. All data is wrapped with several layers of encryption, and the network is both distributed and dynamic, with no trusted parties.")
    (license (license:non-copyleft "file://licenses"))))

(define-public modem-manager-gui
  (package
    (name "modem-manager-gui")
    (version "0.0.20")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
              (url "https://github.com/dmikushin/modem-manager-gui")
              (commit "3a7f24e")))
        (file-name (git-file-name name version))
        (sha256 (base32 "0bshral7p3vk9mj4rd9s1wqgndbprk8praj5yrgja4fmwr392nw6"))))
    (build-system meson-build-system)
    (native-inputs (list pkg-config po4a gettext-minimal itstool python-wrapper))
    (inputs (list glib gtk+ gdbm))
    (home-page "https://github.com/dmikushin/modem-manager-gui")
    (synopsis "Modem Manager GUI")
    (description "Modem Manager GUI is a simple GTK based graphical interface compatible with Modem manager, Wader and oFono system services able to control EDGE/3G/4G broadband modem specific functions. You can check balance of your SIM card, send or receive SMS messages, control mobile traffic consumption and more using Modem Manager GUI.")
    (license license:gpl3+)))
