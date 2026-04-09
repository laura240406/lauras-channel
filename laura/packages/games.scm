(define-module (laura packages games)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix gexp)
  #:use-module (guix transformations)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system cargo)
  #:use-module (guix build-system meson)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system go)
  #:use-module (gnu packages cmake)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (gnu packages)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages sdl)
  #:use-module (gnu packages pkg-config)
  #:use-module (past-crates packages crates-io)
  #:use-module (gnu packages lua)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages algebra)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages image)
  #:use-module (gnu packages serialization)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages base)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages cups)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages audio)
  #:use-module (gnu packages llvm)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages vulkan)
  #:use-module (gnu packages libusb)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages digest)
  #:use-module (gnu packages upnp)
  #:use-module (gnu packages cpp)
  #:use-module (gnu packages xiph)
  #:use-module (gnu packages video)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages libffi)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages fribidi)
  #:use-module (gnu packages multiprecision)
  #:use-module (gnu packages nettle)
  #:use-module (gnu packages libidn)
  #:use-module (gnu packages web)
  #:use-module (gnu packages pcre)
  #:use-module (gnu packages libunistring)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages kerberos)
  #:use-module (gnu packages xfce)
  #:use-module (gnu packages avahi)
  #:use-module (gnu packages elf)
  #:use-module (gnu packages python)
  #:use-module (gnu packages golang-xyz)
  #:use-module (gnu packages golang-build)
  #:use-module (gnu packages java)
  #:use-module (gnu packages man)
  #:use-module (gnu packages kde-frameworks)
  #:use-module (gnu packages markup)
  #:use-module (gnu packages aidc)
  #:use-module (gnu packages backup)
  #:use-module (guix build-system qt)
  #:use-module (nonguix licenses)
  #:use-module (nonguix build-system binary)
  #:use-module (laura packages rust-common)
  #:use-module (laura packages go-common))

(define-public minecraft-launcher
  (let ((launcher-version "2.2.1441"))
    (package
      (name "minecraft-launcher")
      (version launcher-version)
      (supported-systems '("x86_64-linux"))
      (source
       (origin
         (method url-fetch)
         ;; look at https://launchermeta.mojang.com/v1/products/launcher/6f083b80d5e6fabbc4236f81d0d8f8a350c665a9/linux.json
         (uri
          "https://piston-data.mojang.com/v1/objects/bb5d7a5bd5476db2ce04f52b5c7a74ad8db455a7/minecraft-launcher")
         (sha256
          (base32 "0wf2faz9c0pkj555akhlx2alcl5qh1ilmd1p1d9w48sm7gicck69"))))
      (build-system binary-build-system)
      (arguments
       `(#:phases (modify-phases %standard-phases
                    (add-before 'patchelf 'make-executable
                      (lambda _
                        (chmod "minecraft-launcher" #o755)))
                    (add-after 'install 'wrap
                      (lambda* (#:key inputs outputs #:allow-other-keys)
                        (wrap-program (string-append (assoc-ref outputs "out")
                                       "/bin/minecraft-launcher")
                          `("LD_LIBRARY_PATH" ":" =
                            (,(string-append (assoc-ref inputs "glibc") "/lib") ,
                             (string-append (assoc-ref inputs "gcc") "/lib")
                             ,(string-append (assoc-ref inputs "gdk-pixbuf")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "glib") "/lib")
                             ,(string-append (assoc-ref inputs "gtk+") "/lib")
                             ,(string-append (assoc-ref inputs "curl") "/lib")
                             ,(string-append (assoc-ref inputs "libx11")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "zlib") "/lib")
                             ,(string-append (assoc-ref inputs "util-linux")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "nss")
                                             "/lib/nss")
                             ,(string-append (assoc-ref inputs "nspr") "/lib")
                             ,(string-append (assoc-ref inputs "at-spi2-core")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "cups") "/lib")
                             ,(string-append (assoc-ref inputs "libdrm")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "libxcomposite")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "libxdamage")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "libxext")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "libxfixes")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "libxrandr")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "mesa") "/lib")
                             ,(string-append (assoc-ref inputs "expat") "/lib")
                             ,(string-append (assoc-ref inputs "libxcb")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "libxkbcommon")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "dbus") "/lib")
                             ,(string-append (assoc-ref inputs "pango") "/lib")
                             ,(string-append (assoc-ref inputs "cairo") "/lib")
                             ,(string-append (assoc-ref inputs "bzip2") "/lib")
                             ,(string-append (assoc-ref inputs
                                              "libcloudproviders-minimal")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "libdatrie")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "libepoxy")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "libffi")
                                             "/lib")
                             ,(string-append (assoc-ref inputs
                                                        "fontconfig-minimal")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "freetype")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "fribidi")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "gmp") "/lib")
                             ,(string-append (assoc-ref inputs "gnutls")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "graphite2")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "harfbuzz")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "nettle")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "libidn2")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "libjpeg-turbo")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "nettle")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "p11-kit")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "pcre2") "/lib")
                             ,(string-append (assoc-ref inputs "pixman")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "libpng")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "libpsl")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "libtasn1")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "libthai")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "libunistring")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "wayland")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "libxau")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "libxcursor")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "libxdmcp")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "libxinerama")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "libxi") "/lib")
                             ,(string-append (assoc-ref inputs "libxrender")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "libsecret")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "libgpg-error")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "libgcrypt")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "mit-krb5")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "e2fsprogs")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "nghttp2")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "libxfce4util")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "avahi") "/lib")
                             ,(string-append (assoc-ref inputs "elfutils")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "llvm") "/lib")
                             ,(string-append (assoc-ref inputs "libpciaccess")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "xfconf")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "libxshmfence")
                                             "/lib")
                             ,(string-append (assoc-ref inputs "alsa-lib")
                                             "/lib")))))))
         #:patchelf-plan `(("minecraft-launcher" ("glibc" "gcc" "gdk-pixbuf"
                                                  "glib" "gtk+" "curl")))
         #:install-plan `(("minecraft-launcher" "bin/"))))
      (inputs (list (list gcc "lib")
                    (list util-linux "lib")
                    (list nghttp2 "lib")
                    glibc
                    gdk-pixbuf
                    glib
                    gtk+
                    curl
                    libx11
                    zlib
                    nss
                    nspr
                    at-spi2-core
                    cups
                    libdrm
                    libxcomposite
                    libxdamage
                    libxext
                    libxfixes
                    libxrandr
                    mesa
                    expat
                    libxcb
                    libxkbcommon
                    dbus
                    pango
                    cairo
                    bzip2
                    libcloudproviders-minimal
                    libdatrie
                    libepoxy
                    libffi
                    fontconfig
                    freetype
                    fribidi
                    gmp
                    gnutls
                    graphite2
                    harfbuzz
                    nettle
                    libidn2
                    libjpeg-turbo
                    nettle
                    p11-kit
                    pcre2
                    pixman
                    libpng
                    libpsl
                    libtasn1
                    libthai
                    libunistring
                    wayland
                    libxau
                    libxcursor
                    libxdmcp
                    libxinerama
                    libxi
                    libxrender
                    libsecret
                    libgpg-error
                    libgcrypt
                    mit-krb5
                    e2fsprogs
                    libxfce4util
                    avahi
                    elfutils
                    llvm-18
                    libpciaccess
                    xfconf
                    libxshmfence
                    alsa-lib))
      (synopsis "Proprietary Minecraft launcher")
      (description "Minecraft launcher binary")
      (home-page "https://www.minecraft.net/")
      (license (nonfree "https://minecraft.net/terms")))))

(define-public ScuffedMinecraft
  (package
    (name "ScuffedMinecraft")
    (version "1.3.0-pre-alpha")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/EvanatorM/ScuffedMinecraft")
             (commit "pre-alpha-v1.3.0")))
       (file-name (git-file-name name version))
       (modules '((guix build utils)))
       (snippet #~(substitute* "ScuffedMinecraft/src/Application.cpp"
                    (("#include <thread>")
                     "#include <thread>\n#include <libgen.h>")
                    (("int main\\(\\)")
                     "int main(int argc, char *argv[])")
                    (("glfwInit\\(\\);")
                     "glfwInit();
chdir(strcat(dirname(argv[0]), \"/../share/scuffed_mc\"));")))
       (sha256
        (base32 "15g2rc1ny6z88smsaryvqpy0mzm36b5fcc92595x6gakw5f8n20n"))))
    (build-system cmake-build-system)
    (inputs (list glfw-3.4 mesa))
    (arguments
     (list
      #:tests? #f
      #:build-type "Release"
      #:phases
      #~(modify-phases %standard-phases
          (add-before 'configure 'chdir-to-source
            (lambda _
              (chdir "ScuffedMinecraft")))
          (replace 'install
            (lambda* (#:key inputs outputs #:allow-other-keys)
              (begin
                (install-file "../ScuffedMinecraft/bin/scuffed_mc"
                              (string-append (assoc-ref outputs "out") "/bin/"))
                (mkdir-p (string-append (assoc-ref outputs "out")
                                        "/share/scuffed_mc/assets"))
                (copy-recursively "../ScuffedMinecraft/assets"
                                  (string-append (assoc-ref outputs "out")
                                                 "/share/scuffed_mc/assets"))
                (wrap-program (string-append (assoc-ref outputs "out")
                                             "/bin/scuffed_mc")
                  `("LD_LIBRARY_PATH" =
                    ,(list (string-append (assoc-ref inputs "mesa") "/lib"))))))))))
    (home-page "https://github.com/EvanatorM/ScuffedMinecraft")
    (synopsis "A Minecraft Clone in C++")
    (description "A Minecraft clone made in C++ and OpenGL")
    (license license:expat)))

(define-public rpcs3
  (package
    (name "rpcs3")
    (version "0.0.34")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/rpcs3/rpcs3/")
             (commit "v0.0.34")
             (recursive? #t)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0slp83yi9g5by04m58gw3dv907y445d5k0vga73zds4a96jpkrnj"))))
    (build-system cmake-build-system)
    (arguments
     (list
      #:tests? #f
      #:build-type "Release"
      #:configure-flags
      #~(list "-Wno-dev"
              "-DUSE_SYSTEM_OPENAL=ON"
              "-DUSE_SYSTEM_CURL=ON"
              "-DUSE_SYSTEM_LIBPNG=ON"
              "-DUSE_SYSTEM_ZLIB=ON"
              "-DUSE_SYSTEM_WOLFSSL=OFF"
              "-DUSE_SYSTEM_FLATBUFFERS=ON"
              "-DUSE_SYSTEM_PUGIXML=ON"
              "-DUSE_SYSTEM_LIBUSB=ON"
              "-DUSE_SYSTEM_XXHASH=ON"
              "-DUSE_SYSTEM_MVK=ON"
              "-DUSE_SYSTEM_FAUDIO=ON"
              "-DUSE_SYSTEM_FFMPEG=ON"
              "-DUSE_SYSTEM_SDL=ON"
              "-DUSE_NATIVE_INSTRUCTIONS=OFF")
      #:phases
      #~(modify-phases %standard-phases
          (add-before 'build 'fix-source
            (lambda _
              (substitute* "../source/rpcs3/Emu/Cell/PPUThread.cpp"
                (("std::fesetround\\(FE_TONEAREST\\);")
                 ""))
              (substitute* "../source/rpcs3/Emu/Cell/SPUThread.cpp"
                (("std::fesetround\\(FE_TOWARDZERO\\);")
                 "")))))))
    (native-inputs (list pkg-config gcc-toolchain-14))
    (inputs (list zlib
                  mesa
                  libglvnd
                  openal
                  glew
                  llvm-16
                  curl
                  qtbase
                  qtmultimedia
                  qtsvg
                  wayland
                  libxkbcommon
                  vulkan-headers
                  libusb
                  libevdev
                  eudev
                  vulkan-loader
                  sdl2
                  pugixml
                  yaml-cpp
                  xxhash
                  libpng
                  faudio
                  miniupnpc
                  rtmidi
                  asmjit
                  cubeb
                  speex
                  glslang
                  hidapi
                  flatbuffers
                  ffmpeg))
    (home-page "https://rpcs3.net")
    (synopsis "PlayStation 3 emulator and debugger.")
    (description
     "The world's first free and open-source PlayStation 3 emulator/debugger, written in C++ for Windows, Linux, macOS and FreeBSD.")
    (license license:gpl2)))

(define-public tpt
  (package
    (name "tpt")
    (version "99.3.384")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/The-Powder-Toy/The-Powder-Toy")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0l067j0bbzvr0i2prxrgb0af4xdpl648x741jgnyp4bjzdbm61x7"))))
    (build-system meson-build-system)
    (native-inputs (list pkg-config cmake python-3))
    (inputs (list luajit
                  curl
                  fftwf
                  zlib
                  libpng
                  sdl2
                  ((options->transformation `((with-patch unquote
                                                          (string-append
                                                           "bzip2="
                                                           (search-patch
                                                            "laura/packages/patches/bzip2-pkg-config.patch")))))
                   bzip2)
                  jsoncpp))
    (arguments
     (list
      #:tests? #f
      #:configure-flags
      #~(list "-Dworkaround_elusive_bzip2=false" "-Doptimization=3")))
    (home-page "https://powdertoy.co.uk")
    (synopsis "The Powder Toy")
    (description
     "Written in C++ and using SDL, The Powder Toy is a desktop version of the classic 'falling sand' physics sandbox, it simulates air pressure and velocity as well as heat. ")
    (license license:gpl3)))

(define-public rust-uesave-lib-0.6
  (package
    (name "rust-uesave-lib")
    (version "0.6.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "uesave" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1sk11fnzd7v09214qnr74xn7sa3z9jnwvbzhnz0x779vg8zy4ndq"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-2)
                       ("rust-byteorder" ,rust-byteorder-1)
                       ("rust-indexmap" ,rust-indexmap-2)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-uuid" ,rust-uuid-1))))
    (home-page "https://github.com/trumank/uesave-rs")
    (synopsis "Unreal Engine save file (GVAS) reading/writing")
    (description
     "This package provides Unreal Engine save file (GVAS) reading/writing.")
    (license license:expat)))

(define-public uesave
  (package
    (name "uesave")
    (version "0.6.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "uesave_cli" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0lxmiflmnfrrwj0zvabw52fqgfaqshc885544359y5116hsran30"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-anyhow" ,rust-anyhow-1)
                       ("rust-clap" ,rust-clap-4)
                       ("rust-edit" ,rust-edit-0.1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-tempfile" ,rust-tempfile-3)
                       ("rust-uesave" ,rust-uesave-lib-0.6))))
    (home-page "https://github.com/trumank/uesave-rs")
    (synopsis "Unreal Engine save file (GVAS) reading/writing")
    (description
     "This package provides Unreal Engine save file (GVAS) reading/writing.")
    (license license:expat)))

(define-public aaaaxy
  (package
    (name "aaaaxy")
    (version "1.6.176")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/divVerent/aaaaxy")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "13yy5w19xmkpnfznqmsh8dmq2xqbdf98l3h5s7vwvfsqrj95msyc"))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
      #:import-path "github.com/divVerent/aaaaxy"
      #:phases
      #~(modify-phases %standard-phases
          (replace 'build
            (lambda _
              (begin
                (delete-file-recursively "src/github.com/hajimehoshi/ebiten")
                (copy-recursively (string-append #$go-github-com-hajimehoshi-ebiten-v2
                                   "/src/github.com/hajimehoshi/ebiten")
                                  "src/github.com/hajimehoshi/ebiten")
                (delete-file-recursively
                 "src/github.com/hajimehoshi/bitmapfont")
                (copy-recursively (string-append #$go-github-com-hajimehoshi-bitmapfont-v3
                                   "/src/github.com/hajimehoshi/bitmapfont")
                                  "src/github.com/hajimehoshi/bitmapfont")
                (substitute* "src/github.com/divVerent/aaaaxy/generate_licenses.go"
                  (("^//.*$")
                   ""))
                (substitute* "src/github.com/divVerent/aaaaxy/licenses/embed.go"
                  (("^//.*$")
                   ""))
                (invoke "make" "-C" "src/github.com/divVerent/aaaaxy"
                        "BUILDTYPE=embedrelease"))))
          (replace 'install
            (lambda _
              (begin
                (install-file "src/github.com/divVerent/aaaaxy/aaaaxy"
                              (string-append #$output "/bin"))
                (wrap-program (string-append #$output "/bin/aaaaxy")
                  `("LD_LIBRARY_PATH" ":" =
                    (,(string-append #$mesa "/lib"))))))))))
    (inputs (list libx11
                  libxrandr
                  libxcursor
                  libxinerama
                  libxi
                  mesa
                  alsa-lib))
    (native-inputs (list pkg-config))
    (propagated-inputs (list go-github-com-spf13-cobra
                             go-github-com-otiai10-copy
                             go-golang-org-x-text
                             go-golang-org-x-sys
                             go-golang-org-x-image
                             go-github-com-zachomedia-go-bdf
                             go-github-com-ncruces-zenity
                             go-github-com-mitchellh-hashstructure-v2
                             go-github-com-lucasb-eyer-go-colorful
                             go-github-com-lestrrat-go-strftime
                             go-github-com-leonelquinteros-gotext
                             go-github-com-jeandeaual-go-locale
                             go-github-com-hajimehoshi-ebiten-v2
                             go-github-com-hajimehoshi-bitmapfont-v3
                             go-github-com-google-go-cmp
                             go-github-com-fardog-tmx
                             go-github-com-akavel-rsrc
                             go-github-com-adrg-xdg))
    (home-page "https://divverent.github.io/aaaaxy/")
    (synopsis
     "AAAAXY is a nonlinear 2D puzzle platformer taking place in impossible spaces.")
    (description
     "Although your general goal is reaching the surprising end of the game, you are encouraged to set your own goals while playing. Exploration will be rewarded, and secrets await you!

So jump and run around, and enjoy losing your sense of orientation in this World of Wicked Weirdness. Find out what Van Vlijmen will make you do. Pick a path, get inside a Klein Bottle, recognize some memes, and by all means: don’t look up.

And beware of a minor amount of trolling.

To reach the end, a new player will take about 4 to 6 hours, a full playthrough can be finished in about 1 hour and the end can be reached in about 15 minutes.")
    (license license:asl2.0)))

(define-public cubiomes-viewer
  (package
    (name "cubiomes-viewer")
    (version "4.1.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/Cubitect/cubiomes-viewer")
             (recursive? #t)
             (commit "4.1.2")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0llzkr1wpn9pjbg5q08vl40cksqxj5awdj4saymksd8b9x5wlc4b"))))
    (build-system qt-build-system)
    (arguments
     (list
      #:tests? #f
      #:build-type "Release"
      #:phases
      #~(modify-phases %standard-phases
          (replace 'configure
            (lambda _
              (begin
                (mkdir "../build")
                (chdir "../build")
                (system "qmake ../source"))))
          (replace 'install
            (lambda _
              (begin
                (mkdir-p (string-append #$output "/bin"))
                (copy-file "cubiomes-viewer"
                           (string-append #$output "/bin/cubiomes-viewer"))))))))
    (home-page "https://github.com/Cubitect/cubiomes-viewer")
    (synopsis "An efficient graphical Minecraft seed finder and map viewer.")
    (description
     "Cubiomes Viewer provides a graphical interface for the efficient and flexible seed-finding utilities provided by cubiomes and a map viewer for the Minecraft biomes and structure generation.

The tool is designed for high performance and supports Minecraft Java Edition main releases up to 1.21.")
    (license license:gpl3)))

(define-public prismlauncher
  (package
    (name "prismlauncher")
    (version "11.0.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/PrismLauncher/PrismLauncher")
             (recursive? #t)
             (commit version)))
       (file-name (git-file-name name version))
       (modules '((guix build utils)))
       (snippet #~(substitute* "launcher/CMakeLists.txt" (("-Wall -Wextra -Wpedantic -Werror") "-Wall -Wextra -Wpedantic")))
       (sha256
        (base32 "0bms11fz4lfby5hyrs0kn0vl07mkidvbnwvfiqrwqnil540v05rc"))))
    (build-system qt-build-system)
    (native-inputs (list pkg-config
                         (list openjdk17 "jdk") scdoc extra-cmake-modules))
    (inputs (list qtbase
                  qt5compat
                  qtnetworkauth
                  glfw-3.4
                  mesa
                  openal
                  openjdk25
                  cmark
                  gamemode
                  qrencode
                  tomlplusplus
                  libarchive
                  libxcursor
                  libxrandr
                  libxxf86vm))
    (arguments
     (list
      #:build-type "Release"
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'install 'wrap
            (lambda _
              (wrap-program (string-append #$output "/bin/prismlauncher")
                `("LD_LIBRARY_PATH" ":" =
                  (,(string-append #$glfw-3.4 "/lib")
                   ,(string-append #$mesa "/lib")
                   ,(string-append #$openal "/lib")
                   ,(string-append #$libxcursor "/lib")
                   ,(string-append #$libxrandr "/lib")
                   ,(string-append #$libxxf86vm "/lib")))))))))
    (home-page "https://prismlauncher.org/")
    (synopsis
     "A custom launcher for Minecraft that allows you to easily manage multiple installations of Minecraft at once (Fork of MultiMC)")
    (description
     "Prism Launcher is a custom launcher for Minecraft that allows you to easily manage multiple installations of Minecraft at once.

This is a fork of the MultiMC Launcher and is not endorsed by it.")
    (license license:gpl3)))
