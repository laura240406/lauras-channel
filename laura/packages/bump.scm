(define-module (laura packages bump)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system meson)
  #:use-module (guix gexp)
  #:use-module (guix utils)
  #:use-module (guix platform)
  #:use-module (gnu packages)
  #:use-module (gnu packages squirrel)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages bison)
  #:use-module (gnu packages flex)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages python)
  #:use-module (gnu packages man)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages image)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages video)
  #:use-module (gnu packages python-crypto)
  #:use-module (gnu packages music)
  #:use-module (gnu packages admin)
  #:use-module (gnu packages texinfo)
  #:use-module (gnu packages hardware)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages sqlite)
  #:use-module (gnu packages polkit)
  #:use-module (gnu packages elf)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages protobuf)
  #:use-module (gnu packages mingw)
  #:use-module (gnu packages efi)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages package-management)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages backup)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages base)
  #:use-module (gnu packages check)
  #:use-module (gnu packages engineering)
  #:use-module (gnu packages boost)
  #:use-module (gnu packages graphics)
  #:use-module (gnu packages maths)
  #:use-module (gnu packages algebra)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages multiprecision)
  #:use-module (gnu packages tbb)
  #:use-module (gnu packages llvm)
  #:use-module (gnu packages imagemagick)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages xiph)
  #:use-module (gnu packages audio)
  #:use-module (gnu packages mp3)
  #:use-module (gnu packages cdrom)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages sdl)
  #:use-module (gnu packages networking)
  #:use-module (gnu packages dbm)
  #:use-module (gnu packages libffi)
  #:use-module (gnu packages readline)
  #:use-module (gnu packages tcl)
  #:use-module (gnu packages assembly))

(define-public squirrel-3.2
  (package
    (inherit squirrel)
    (version "3.2")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "mirror://sourceforge/squirrel/squirrel3/"
                           "squirrel "
                           version
                           " stable/squirrel_"
                           (string-join (string-split version #\.) "_")
                           "_stable.tar.gz"))
       (file-name (string-append "squirrel-" version ".tar.gz"))
       (patches (search-patches
                 "laura/packages/patches/squirrel-no-cmake-files.patch"
                 "laura/packages/patches/squirrel-cve-2022-30292.patch"))
       (patch-flags '("-p1" "--binary"))
       (sha256
        (base32 "1nw1ghr4nxsvpk5bm9q0arrx4zrjpq5bai5sc17vj90by19187r1"))))))

(define-public shepherd-core
  (package
    (inherit shepherd-1.0)
    (version "1.0.100")
    (source
     (origin
       (method url-fetch)
       (uri "mirror://gnu/shepherd/shepherd-1.0.2.tar.gz")
       (patches (list (search-patch
                       "laura/packages/patches/shepherd-core.patch")))
       (sha256
        (base32 "1gr4k57jv2flks2zvvmm0i1lpi9cmj9844zdz6l6yixhnh2aqjyz"))))))

(define-public fwupd-nonfree-polkit
  (package
    (name "fwupd-nonfree-polkit")
    (version "1.8.14")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/fwupd/fwupd")
             (commit version)))
       (file-name (git-file-name name version))
       (patches (search-patches "laura/packages/patches/fwupd-polkit.patch"))
       (sha256
        (base32 "179yc0nbbyrdya5q16ncf7lkslrhr3i90rgb9vdmv751ikilkby6"))))
    (build-system meson-build-system)
    (arguments
     (list
      #:configure-flags
      #~(list "--wrap-mode=nofallback"
              "-Dsystemd=false"
              (string-append "-Defi_os_dir="
                             #$gnu-efi "/lib")
              "-Defi_binary=false"
              (string-append "-Dudevdir="
                             #$output "/lib/udev")
              "--localstatedir=/var"
              (string-append "--libexecdir="
                             #$output "/libexec")
              "-Dsupported_build=true"
              "-Dlvfs=true")
      #:glib-or-gtk? #t
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'make-source-writable
            (lambda _
              (for-each make-file-writable
                        (find-files "."))
              (substitute* "src/fu-self-test.c"
                (("/bin/sh")
                 (which "sh")))))
          (add-after 'unpack 'newer-timestamps-for-python-zip
            (lambda _
              (let ((circa-1980 (* 10 366 24 60 60)))
                (for-each (lambda (file)
                            (make-file-writable file)
                            (utime file circa-1980 circa-1980))
                          '("./libfwupdplugin/tests/colorhug/firmware.bin"
                            "./libfwupdplugin/tests/colorhug/firmware.bin.asc")))))
          (add-before 'build 'setup-home
            (lambda _
              (setenv "HOME" "/tmp")))
          (add-before 'install 'no-polkit-magic
            (lambda _
              (setenv "PKEXEC_UID" "something")))
          (add-after 'install 'ensure-all-remotes-are-enabled
            (lambda _
              (substitute* (find-files (string-append #$output "/etc")
                                       "\\.conf$")
                (("Enabled=false")
                 "Enabled=true")))))))
    (native-inputs (list gobject-introspection
                         python-pygobject
                         python-pillow
                         python-pycairo
                         python
                         pkg-config
                         vala
                         gtk-doc
                         which
                         umockdev
                         `(,glib "bin")
                         help2man
                         gettext-minimal))
    (inputs (append (list bash-completion
                          libgudev
                          libxmlb
                          sqlite
                          polkit
                          eudev
                          libelf
                          tpm2-tss
                          cairo
                          efivar
                          pango
                          protobuf-c
                          mingw-w64-tools
                          gnu-efi)
                    (if (supported-package? libsmbios
                                            (or (and=> (%current-target-system)
                                                 platform-target->system)
                                                (%current-system)))
                        (list libsmbios)
                        '())))
    (propagated-inputs (list curl
                             gcab
                             glib
                             gnutls
                             gusb
                             json-glib
                             libarchive
                             libjcat))
    (home-page "https://fwupd.org/")
    (synopsis "Daemon to allow session software to update firmware")
    (description
     "This package aims to make updating firmware on GNU/Linux
automatic, safe and reliable.  It is used by tools such as GNOME Software. Now with nonfree firmware.")
    (license license:lgpl2.1+)))

(define-public openssl-3.4.1
  (package
    (inherit openssl-3.0)
    (version "3.4.1")
    (source
     (origin
       (method url-fetch)
       (uri (list (string-append "https://www.openssl.org/source/openssl-"
                                 version ".tar.gz")
                  (string-append "ftp://ftp.openssl.org/source/" "openssl-"
                                 version ".tar.gz")
                  (string-append "ftp://ftp.openssl.org/source/old/"
                                 (string-trim-right version char-set:letter)
                                 "/openssl-" version ".tar.gz")))
       (patches (search-patches "openssl-3.0-c-rehash-in.patch"))
       (sha256
        (base32 "1wvx37d0dvpylhm7ha64lvdgiak5cgcvshvcljzg92xm61mjsah0"))))))

(define-public openscad-bumped
  (package/inherit openscad
    (name "openscad")
    (version "2025.99.99")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/openscad/openscad")
                    (recursive? #t)
                    (commit "7166904")))
              (file-name (git-file-name name version))
              (sha256 (base32
                       "1n6ssvr2mz65nx8p7hx0j9mymfkgrl7nhdv3dwp19205fj8k7xi5"))))
    (build-system cmake-build-system)
    (native-inputs (list clang-toolchain
                         pkg-config
                         bison
                         flex
                         gettext-minimal
                         which
                         imagemagick
                         procps
                         python
                         xorg-server-for-tests))
    (inputs (list boost
                  cgal
                  double-conversion
                  eigen
                  fontconfig
                  glew
                  gmp
                  harfbuzz
                  libxml2
                  libzip
                  mpfr
                  opencsg
                  qscintilla
                  qtbase-5
                  qtmultimedia-5
                  qtsvg-5
                  cairo
                  tbb))
    (arguments (list #:tests? #f
                     #:configure-flags #~(list "-DENABLE_EGL=OFF"
                                               "-DCMAKE_C_COMPILER=clang"
                                               "-DCMAKE_CXX_COMPILER=clang++")
                     #:phases #~(modify-phases %standard-phases
                                  (add-after 'unpack 'patch
                                    (lambda _
                                      (substitute* "src/glview/PolySetRenderer.cc"
                                        (("isnan")
                                         "std::isnan")))))))))

(define-public libvvenc
  (package
    (name "libvvenc")
    (version "1.13.1")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
              (url "https://github.com/fraunhoferhhi/vvenc")
              (commit "v1.13.1")))
        (file-name (git-file-name name version))
        (sha256 (base32 "045f917yzi67c8mcla0ak9ky3966dm21q4z84d53hkhqclg7bx0c"))))
    (build-system cmake-build-system)
    (arguments (list #:tests? #f #:build-type "Release" #:configure-flags #~(list "-DBUILD_SHARED_LIBS=ON" "-DVVENC_LIBRARY_ONLY=ON")))
    (home-page "https://www.hhi.fraunhofer.de/en/departments/vca/technologies-and-solutions/h266-vvc.html")
    (synopsis "VVenC, the Fraunhofer Versatile Video Encoder")
    (description "VVenC, the Fraunhofer Versatile Video Encoder, is a fast and efficient software H.266/VVC encoder implementation.")
    (license license:bsd-3)))

(define-public ffmpeg-7.1.1
  (package
    (name "ffmpeg")
    (version "7.1.1")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://ffmpeg.org/releases/ffmpeg-"
                                  version ".tar.xz"))
              (sha256
               (base32
                "1c837agaw8ljhjx6ndp2w7hffi2mkb22vnmb8v0fbfqdbqwq8fbk"))))
    (outputs '("out" "debug"))
    (build-system gnu-build-system)
    (inputs
     (append
      (if (supported-package? rav1e) (list rav1e) '())
      (list dav1d
            fontconfig
            freetype
            frei0r-plugins
            gnutls
            opus
            ladspa
            lame
            libaom
            libass
            libbluray
            libcaca
            libcdio-paranoia
            libdrm
            libtheora
            libva
            libvdpau
            libvorbis
            libvpx
            libvvenc
            libwebp
            libx11
            libx264
            mesa
            openal
            pulseaudio
            sdl2
            soxr
            speex
            srt
            svt-av1
            twolame
            vidstab
            x265
            xvid
            zlib)))
    (native-inputs
     (list bc
           perl
           pkg-config
           texinfo
           speex
           yasm))
    (arguments
     (list
      #:test-target "fate"
      #:configure-flags
      ;; possible additional inputs:
      ;;   --enable-avisynth        enable reading of AviSynth script
      ;;                            files [no]
      ;;   --enable-libaacplus      enable AAC+ encoding via libaacplus [no]
      ;;   --enable-libcelt         enable CELT decoding via libcelt [no]
      ;;   --enable-libdc1394       enable IIDC-1394 grabbing using libdc1394
      ;;                            and libraw1394 [no]
      ;;   --enable-libfdk-aac      enable AAC de/encoding via libfdk-aac [no]
      ;;   --enable-libflite        enable flite (voice synthesis) support via
      ;;                            libflite [no]
      ;;   --enable-libgme          enable Game Music Emu via libgme [no]
      ;;   --enable-libgsm          enable GSM de/encoding via libgsm [no]
      ;;   --enable-libiec61883     enable iec61883 via libiec61883 [no]
      ;;   --enable-libilbc         enable iLBC de/encoding via libilbc [no]
      ;;   --enable-libmodplug      enable ModPlug via libmodplug [no]
      ;;   --enable-libnut          enable NUT (de)muxing via libnut,
      ;;                            native (de)muxer exists [no]
      ;;   --enable-libopencore-amrnb    enable AMR-NB de/encoding via
      ;;                                 libopencore-amrnb [no]
      ;;   --enable-libopencore-amrwb    enable AMR-WB decoding via
      ;;                                 libopencore-amrwb [no]
      ;;   --enable-libopencv       enable video filtering via libopencv [no]
      ;;   --enable-libopenjpeg     enable JPEG 2000 de/encoding via
      ;;                            OpenJPEG [no]
      ;;   --enable-librtmp         enable RTMP[E] support via librtmp [no]
      ;;   --enable-libschroedinger enable Dirac de/encoding via
      ;;                            libschroedinger [no]
      ;;   --enable-libshine        enable fixed-point MP3 encoding via
      ;;                            libshine [no]
      ;;   --enable-libssh          enable SFTP protocol via libssh [no]
      ;;                            (libssh2 does not work)
      ;;   --enable-libstagefright-h264  enable H.264 decoding via
      ;;                                 libstagefright [no]
      ;;   --enable-libutvideo      enable Ut Video encoding and decoding via
      ;;                            libutvideo [no]
      ;;   --enable-libv4l2         enable libv4l2/v4l-utils [no]
      ;;   --enable-libvo-aacenc    enable AAC encoding via libvo-aacenc [no]
      ;;   --enable-libvo-amrwbenc  enable AMR-WB encoding via
      ;;                            libvo-amrwbenc [no]
      ;;   --enable-libwavpack      enable wavpack encoding via libwavpack [no]
      ;;   --enable-libxavs         enable AVS encoding via xavs [no]
      ;;   --enable-libzmq          enable message passing via libzmq [no]
      ;;   --enable-libzvbi         enable teletext support via libzvbi [no]
      ;;   --enable-opencl          enable OpenCL code
      #~(list
         #$@(if (target-powerpc?)
                ;; These tests fail on powerpc64-le (see:
                ;; https://trac.ffmpeg.org/ticket/9604).
                '("--ignore-tests=checkasm-sw_scale,filter-scale2ref_keep_aspect")
                '())
         "--enable-gpl"                 ;enable optional gpl licensed parts
         "--enable-shared"
         "--enable-frei0r"
         "--enable-fontconfig"
         "--enable-gnutls"
         "--enable-ladspa"
         "--enable-libaom"
         "--enable-libass"
         "--enable-libbluray"
         "--enable-libcaca"
         "--enable-libcdio"
         "--enable-libdav1d"
         "--enable-libfreetype"
         "--enable-libmp3lame"
         "--enable-libopus"
         "--enable-libpulse"
         #$@(if (this-package-input "rav1e")
                '("--enable-librav1e")
                '())
         "--enable-libsoxr"
         "--enable-libspeex"
         "--enable-libsrt"
         "--enable-libsvtav1"
         "--enable-libtheora"
         "--enable-libtwolame"
         "--enable-libvidstab"
         "--enable-libvorbis"
         "--enable-libvpx"
         "--enable-libwebp"
         "--enable-libxvid"
         "--enable-libx264"
         "--enable-libx265"
         "--enable-libvvenc"
         "--enable-openal"
         "--enable-opengl"
         "--enable-libdrm"
         "--enable-vaapi"

         "--enable-runtime-cpudetect"

         ;; The HTML pages take 7.2 MiB
         "--disable-htmlpages"

         ;; The static libraries are 23 MiB
         "--disable-static"

         "--disable-stripping"

         #$@(if (target-riscv64?)
                '("--extra-cflags=-fPIC")
                '())

         ;; Runtime cpu detection is not implemented on
         ;; MIPS, so we disable some features.
         "--disable-mips32r2"
         "--disable-mipsdsp"
         "--disable-mipsdspr2"
         "--disable-mipsfpu")
      #:phases
      #~(modify-phases %standard-phases
          #$@(if (target-x86-32?)
                 #~((add-before 'configure 'bypass-openal-check
                      ;; configure fails linking to openal when using binutils
                      ;; >= 2.38 due to openal's usage of protected visibility
                      ;; for its dynamic symbols. Bypass this configure time
                      ;; check for now. See:
                      ;; https://lists.gnu.org/archive/html/guix-devel/2024-08/msg00159.html
                      (lambda _
                        (substitute* "configure"
                          ;; This string only matches on ffmpeg v6 and above.
                          ;; Replace it with the one defined at ffmpeg-5 which
                          ;; matches on all ffmpeg versions. See #71917.
                          (("alGetError \\|\\|")
                           "alGetError \|\| true \|\|")))))
                 #~())
          (replace 'configure
            ;; configure does not work followed by "SHELL=..." and
            ;; "CONFIG_SHELL=..."; set environment variables instead
            (lambda* (#:key outputs configure-flags #:allow-other-keys)
              (let ((out (assoc-ref outputs "out")))
                (substitute* "configure"
                  (("#! /bin/sh") (string-append "#!" (which "sh"))))
                (substitute* "configure"
                  (("#!/bin/sh") (string-append "#!" (which "sh"))))
                (setenv "SHELL" (which "bash"))
                (setenv "CONFIG_SHELL" (which "bash"))
                (apply invoke
                       "./configure"
                       (string-append "--prefix=" out)
                       ;; Add $libdir to the RUNPATH of all the binaries.
                       (string-append "--extra-ldflags=-Wl,-rpath="
                                      out "/lib")
                       configure-flags))))
          (add-before 'check 'set-ld-library-path
            (lambda _
              ;; Allow $(top_builddir)/ffmpeg to find its dependencies when
              ;; running tests.
              (let* ((dso  (find-files "." "\\.so$"))
                     (path (string-join (map dirname dso) ":")))
                (format #t "setting LD_LIBRARY_PATH to ~s~%" path)
                (setenv "LD_LIBRARY_PATH" path)))))))
    (home-page "https://www.ffmpeg.org/")
    (synopsis "Audio and video framework")
    (description "FFmpeg is a complete, cross-platform solution to record,
convert and stream audio and video.  It includes the libavcodec
audio/video codec library.")
    (license license:gpl2+)))

(define-public p7zip-nonfree
  (package/inherit p7zip
    (name "p7zip-nonfree")
    (version "16.02")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://sourceforge/" name "/" name "/"
                                  version "/p7zip_" version
                                  "_src_all.tar.bz2"))
              (sha256
               (base32
                "07rlwbbgszq8i7m8jh3x6j2w2hc9a72dc7fmqawnqkwlwb00mcjy"))
              (modules '((guix build utils)))
              (snippet
               '(begin
                  ;; Fix FTBFS with gcc-10.
                  (substitute* "CPP/Windows/ErrorMsg.cpp"
                    (("switch\\(errorCode\\) \\{")
                     "switch(static_cast<HRESULT>(errorCode)) {"))))
              (patches (search-patches "p7zip-CVE-2016-9296.patch"
                                       "p7zip-CVE-2017-17969.patch"
                                       "p7zip-fix-build-with-gcc-11.patch"))))))

(define-public python-latest
  (package
    (name "python-latest")
    (version "3.14.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://www.python.org/ftp/python/" version
                           "/Python-" version ".tar.xz"))
       (sha256
        (base32 "1sgkx7pbgry8k1h37xxjw1lcs1q3j4y0v85chcwcx5fk8bjxm692"))
       (patches (search-patches "python-3-deterministic-build-info.patch"
                                "python-3-hurd-configure.patch"))
       (modules '((guix build utils)))
       (snippet '(begin
                   ;; Delete the bundled copy of libexpat.
                   (delete-file-recursively "Modules/expat")
                   (substitute* "Modules/Setup"
                     ;; Link Expat instead of embedding the bundled one.
                     (("^#pyexpat.*")
                      "pyexpat pyexpat.c -lexpat\n"))
                   ;; Delete windows binaries
                   (for-each delete-file
                             (find-files "Lib/distutils/command" "\\.exe$"))))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:tests? #f
      #:configure-flags
      #~(list "--enable-shared"          ;allow embedding
              "--with-system-expat"      ;for XML support
              "--with-system-ffi"        ;build ctypes
              "--with-ensurepip=install" ;install pip and setuptools
              "--with-computed-gotos"    ;main interpreter loop optimization
              "--enable-unicode=ucs4"
              "--without-static-libpython"
              "--enable-loadable-sqlite-extensions"

              ;; FIXME: These flags makes Python significantly faster,
              ;; but leads to non-reproducible binaries.
              ;; "--with-lto"   ;increase size by 20MB, but 15% speedup
              ;; "--enable-optimizations"

              ;; Prevent the installed _sysconfigdata.py from retaining
              ;; a reference to coreutils.
              "INSTALL=install -c"
              "MKDIR_P=mkdir -p"

              ;; Disable runtime check failing if cross-compiling, see:
              ;; https://lists.yoctoproject.org/pipermail/poky/2013-June/008997.html
              #$@(if (%current-target-system)
                     #~("ac_cv_buggy_getaddrinfo=no"
                        "ac_cv_file__dev_ptmx=no"
                        "ac_cv_file__dev_ptc=no")
                     #~())
              ;; -fno-semantic-interposition reinstates some
              ;; optimizations by gcc leading to around 15% speedup.
              ;; This is the default starting from python 3.10.
              "CFLAGS=-fno-semantic-interposition"
              (string-append "LDFLAGS=-Wl,-rpath="
                             (assoc-ref %outputs "out")
                             "/lib"
                             " -fno-semantic-interposition"))

      #:modules '((ice-9 ftw)
                  (ice-9 match)
                  (guix build utils)
                  (guix build gnu-build-system))

      #:phases
      #~(modify-phases %standard-phases
          #$@(if (system-hurd?)
                 #~((add-after 'unpack
                        'disable-multi-processing
                      (lambda _
                        (substitute* "Makefile.pre.in"
                          (("-j0")
                           "-j1")))))
                 #~())
          (add-before 'configure 'patch-lib-shells
            (lambda _
              ;; This variable is used in setup.py to enable cross compilation
              ;; specific switches. As it is not set properly by configure
              ;; script, set it manually.
              #$@(if (%current-target-system)
                     #~((setenv "_PYTHON_HOST_PLATFORM" ""))
                     #~())
              ;; Filter for existing files, since some may not exist in all
              ;; versions of python that are built with this recipe.
              (substitute* (filter file-exists?
                                   '("Lib/subprocess.py"
                                     "Lib/popen2.py"
                                     "Lib/distutils/tests/test_spawn.py"
                                     "Lib/test/support/__init__.py"
                                     "Lib/test/test_subprocess.py"))
                (("/bin/sh")
                 (which "sh")))))
          (add-before 'configure 'do-not-record-configure-flags
            (lambda* (#:key configure-flags #:allow-other-keys)
              ;; Remove configure flags from the installed '_sysconfigdata.py'
              ;; and 'Makefile' so we don't end up keeping references to the
              ;; build tools.
              ;;
              ;; Preserve at least '--with-system-ffi' since otherwise the
              ;; thing tries to build libffi, fails, and we end up with a
              ;; Python that lacks ctypes.
              (substitute* "configure"
                (("^CONFIG_ARGS=.*$")
                 (format #f "CONFIG_ARGS='~a'\n"
                         (if (member "--with-system-ffi"
                                     configure-flags)
                             "--with-system-ffi" ""))))))
          (add-before 'check 'pre-check
            (lambda _
              ;; 'Lib/test/test_site.py' needs a valid $HOME
              (setenv "HOME"
                      (getcwd))))
          (add-after 'unpack 'set-source-file-times-to-1980
            ;; XXX One of the tests uses a ZIP library to pack up some of the
            ;; source tree, and fails with "ZIP does not support timestamps
            ;; before 1980".  Work around this by setting the file times in the
            ;; source tree to sometime in early 1980.
            (lambda _
              (let ((circa-1980 (* 10 366 24 60 60)))
                (ftw "."
                     (lambda (file stat flag)
                       (utime file circa-1980 circa-1980) #t)))))
          (add-after 'unpack 'remove-windows-binaries
            (lambda _
              ;; Delete .exe from embedded .whl (zip) files
              (for-each (lambda (whl)
                          (let ((dir "whl-content")
                                (circa-1980 (* 10 366 24 60 60)))
                            (mkdir-p dir)
                            (with-directory-excursion dir
                              (let ((whl (string-append "../" whl)))
                                (invoke "unzip" whl)
                                (for-each delete-file
                                          (find-files "." "\\.exe$"))
                                (delete-file whl)
                                ;; Reset timestamps to prevent them from ending
                                ;; up in the Zip archive.
                                (ftw "."
                                     (lambda (file stat flag)
                                       (utime file circa-1980
                                              circa-1980) #t))
                                (apply invoke "zip" "-X" whl
                                       (find-files "."
                                                   #:directories? #t))))
                            (delete-file-recursively dir)))
                        (find-files "Lib/ensurepip" "\\.whl$"))))
          (add-after 'install 'remove-tests
            ;; Remove 25 MiB of unneeded unit tests.  Keep test_support.*
            ;; because these files are used by some libraries out there.
            (lambda* (#:key outputs #:allow-other-keys)
              (let ((out (assoc-ref outputs "out")))
                (match (scandir (string-append out "/lib")
                                (lambda (name)
                                  (string-prefix? "python" name)))
                  ((pythonX.Y)
                   (let ((testdir (string-append out "/lib/" pythonX.Y
                                                 "/test")))
                     (with-directory-excursion testdir
                       (for-each delete-file-recursively
                                 (scandir testdir
                                          (match-lambda
                                            ((or "." "..")
                                             #f)
                                            ("support" #f)
                                            (file (not (string-prefix?
                                                        "test_support."
                                                        file))))))
                       (call-with-output-file "__init__.py"
                         (const #t))))
                   (let ((libdir (string-append out "/lib/" pythonX.Y)))
                     (for-each (lambda (directory)
                                 (let ((dir (string-append libdir "/"
                                                           directory)))
                                   (when (file-exists? dir)
                                     (delete-file-recursively dir))))
                               '("email/test" "ctypes/test"
                                 "unittest/test"
                                 "tkinter/test"
                                 "sqlite3/test"
                                 "bsddb/test"
                                 "lib-tk/test"
                                 "json/tests"
                                 "distutils/tests"))))))))
          (add-after 'remove-tests 'rebuild-bytecode
            (lambda* (#:key outputs #:allow-other-keys)
              (let ((out (assoc-ref outputs "out")))
                ;; Disable hash randomization to ensure the generated .pycs
                ;; are reproducible.
                (setenv "PYTHONHASHSEED" "0")

                (for-each (lambda (output)
                            ;; XXX: Delete existing pycs generated by the build
                            ;; system beforehand because the -f argument does
                            ;; not necessarily overwrite all files, leading to
                            ;; indeterministic results.
                            (for-each (lambda (pyc)
                                        (delete-file pyc))
                                      (find-files output "\\.pyc$"))

                            (apply invoke
                                   `(,#$(if (%current-target-system)
                                            "python3"
                                            #~(string-append
                                               out
                                               "/bin/python3")) "-m"
                                               "compileall"
                                               "-o"
                                               "0"
                                               "-o"
                                               "1"
                                               "-o"
                                               "2"
                                               "-f" ;force rebuild
                                               "--invalidation-mode=unchecked-hash"
                                               ;; Don't build lib2to3, because it's
                                               ;; Python 2 code.
                                               "-x"
                                               "lib2to3/.*"
                                               ,output)))
                          (map cdr outputs)))))
          (add-before 'check 'set-TZDIR
            (lambda* (#:key inputs native-inputs #:allow-other-keys)
              ;; test_email requires the Olson time zone database.
              (setenv "TZDIR"
                      (string-append (assoc-ref (or native-inputs
                                                    inputs) "tzdata")
                                     "/share/zoneinfo"))))
          (add-after 'install 'install-sitecustomize.py
            #$(customize-site version)))))
    (inputs (list bzip2
                  expat
                  gdbm
                  libffi                ;for ctypes
                  sqlite                ;for sqlite extension
                  openssl
                  readline
                  zlib
                  tcl
                  `(,zstd "lib")
                  tk))                  ;for tkinter
    (native-inputs `(("tzdata" ,tzdata-for-tests)
                     ("unzip" ,unzip)
                     ("zip" ,(@ (gnu packages compression) zip))
                     ("pkg-config" ,pkg-config)
                     ("sitecustomize.py" ,(local-file (search-auxiliary-file
                                                       "python/sitecustomize.py")))
                     ;; When cross-compiling, a native version of Python itself is needed.
                     ,@(if (%current-target-system)
                           `(("python" ,this-package)
                             ("which" ,which))
                           '())))
    (native-search-paths
     (list (guix-pythonpath-search-path version)
           ;; Used to locate tzdata by the zoneinfo module introduced in
           ;; Python 3.9.
           (search-path-specification
            (variable "PYTHONTZPATH")
            (files (list "share/zoneinfo")))))
    (home-page "https://www.python.org")
    (synopsis "High-level, dynamically-typed programming language")
    (description
     "Python is a remarkably powerful dynamic programming language that
is used in a wide variety of application domains.  Some of its key
distinguishing features include: clear, readable syntax; strong
introspection capabilities; intuitive object orientation; natural
expression of procedural code; full modularity, supporting hierarchical
packages; exception-based error handling; and very high level dynamic
data types.")
    (properties '((cpe-name . "python")
                  (cpe-vendor . "python")))
    (license license:psfl)))
