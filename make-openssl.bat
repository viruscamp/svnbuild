if "%VER_OPENSSL%"=="" set VER_OPENSSL=1.1.1o

if "%1"=="" goto UNPACK
if "%1"=="unpack" goto UNPACK
if not exist openssl-%VER_OPENSSL% goto UNPACK
cd openssl-%VER_OPENSSL%
if "%1"=="configure" goto CONFIGURE
if "%1"=="compile" goto COMPILE
if "%1"=="install" goto INSTALL
if "%1"=="test" goto TEST

:UNPACK
rmdir /s /q openssl-%VER_OPENSSL%
7z x %SOURCES_DIR%\openssl-%VER_OPENSSL%.tar.gz -so | 7z x -aoa -si -ttar -o.
cd openssl-%VER_OPENSSL%

if not "%VER_OPENSSL%"=="1.1.1o" goto PATCH111O_DONE
  patch -d . -p 1 --binary -f -i %SOURCES_DIR%\patches\openssl-1.1.1-pull-18446.patch
  patch -d . -p 1 --binary -f -i %SOURCES_DIR%\patches\openssl-1.1.1-pull-18481.patch
:PATCH111O_DONE

if "%MSVC_VERSION%" geq "2010" goto PATCH_STDINT_DONE
@rem vs2008 undefined macros: INT64_MAX UINT64_C EISCONN
  if not "%VER_OPENSSL%"=="3.0.13" goto PATCH3013_STDINT_DONE
    patch -d . -p 1 --binary -f -i %SOURCES_DIR%\patches\openssl-3.0.13-vs2008-stdint.patch
  :PATCH3013_STDINT_DONE

  if not "%VER_OPENSSL%"=="3.2.1" goto PATCH321_STDINT_DONE
    patch -d . -p 1 --binary -f -i %SOURCES_DIR%\patches\openssl-3.2.1-vs2008-stdint-errno.patch
  :PATCH321_STDINT_DONE
  
  if not "%VER_OPENSSL%"=="3.3.0" goto PATCH330_STDINT_DONE
    patch -d . -p 1 --binary -f -i %SOURCES_DIR%\patches\openssl-3.2.1-vs2008-stdint-errno.patch
  :PATCH330_STDINT_DONE

:PATCH_STDINT_DONE

if "%MSVC_VERSION%" geq "2015" goto PATCH_SNPRINTF_DONE
@rem replace all `snprintf` to `BIO_snprintf` for MSVC_VERSION < 2015
  if not "%VER_OPENSSL%"=="3.2.1" goto PATCH321_SNPRINTF_DONE
    patch -d . -p 1 --binary -f -i %SOURCES_DIR%\patches\openssl-3.2.1-snprintf.patch
  :PATCH321_SNPRINTF_DONE

  if not "%VER_OPENSSL%"=="3.3.0" goto PATCH330_SNPRINTF_DONE
    patch -d . -p 1 --binary -f -i %SOURCES_DIR%\patches\openssl-3.3.0-snprintf.patch
  :PATCH330_SNPRINTF_DONE

:PATCH_SNPRINTF_DONE

if not "%VER_OPENSSL%"=="3.3.0" goto PATCH330_DONE
  patch -d . -p 1 --binary -f -i %SOURCES_DIR%\patches\openssl-3.3.0-issue-24109.patch
:PATCH330_DONE

:UNPACK_DONE
if "%1"=="unpack" goto EXIT

:CONFIGURE
set OPENSSL_TARGET=
if "%TARGET_ARCH%"=="win32" (set OPENSSL_TARGET=VC-WIN32)
if "%TARGET_ARCH%"=="x86" (set OPENSSL_TARGET=VC-WIN32)
if "%TARGET_ARCH%"=="x64" (set OPENSSL_TARGET=VC-WIN64A)
perl Configure %OPENSSL_TARGET% --prefix=%INSDIR%
set OPENSSL_TARGET=
if "%1"=="configure" goto EXIT

:COMPILE
nmake
if "%1"=="compile" goto EXIT

:INSTALL
nmake install_sw

mkdir %INSDIR%\licenses\openssl
copy /y LICENSE %INSDIR%\licenses\openssl
copy /y README %INSDIR%\licenses\openssl
copy /y LICENSE.txt %INSDIR%\licenses\openssl
copy /y README.md %INSDIR%\licenses\openssl

if "%1"=="install" goto EXIT

goto EXIT
:TEST
nmake test
goto EXIT

:EXIT
cd %BUILDROOT%
