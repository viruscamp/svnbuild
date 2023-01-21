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
if not "%VER_OPENSSL%"=="1.1.1o" goto UNPACK_DONE
patch -d . -p 1 --binary -f -i %SOURCES_DIR%\patches\openssl-1.1.1-pull-18446.patch
patch -d . -p 1 --binary -f -i %SOURCES_DIR%\patches\openssl-1.1.1-pull-18481.patch
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
mkdir %INSDIR%

if "%1"=="install" goto EXIT

goto EXIT
:TEST
nmake test
goto EXIT

:EXIT
cd %BUILDROOT%
