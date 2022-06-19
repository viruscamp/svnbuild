if "%VER_SUBVERSION%"=="" set VER_SUBVERSION=1.14.2

if "%1"=="" goto UNPACK
if "%1"=="unpack" goto UNPACK
if not exist subversion-%VER_SUBVERSION% goto UNPACK
cd subversion-%VER_SUBVERSION%
if "%1"=="configure" goto CONFIGURE
if "%1"=="compile" goto COMPILE
if "%1"=="install" goto INSTALL

:UNPACK
rmdir /s /q subversion-%VER_SUBVERSION%
7z x %SOURCES_DIR%\subversion-%VER_SUBVERSION%.tar.bz2 -so | 7z x -aoa -si -ttar -o.
cd subversion-%VER_SUBVERSION%
patch -d . -p 1 --binary -f -i %SOURCES_DIR%\patches\subversion-db-without-apu.patch
patch -d . -p 1 --binary -f -i %SOURCES_DIR%\patches\subversion-gen-make-win-dep.patch
if "%1"=="unpack" goto EXIT

:CONFIGURE
set SVN_APACHE_DEPS=--with-httpd=%APDIR% --with-apr=%APDIR% --with-apr-util=%APDIR% --with-apr-iconv=%APDIR%
set SVN_DEPS=--with-openssl=%INSDIR% --with-zlib=%INSDIR% --with-libintl=%INSDIR% --with-sqlite=%INSDIR% --with-serf=%INSDIR% --with-sasl=%INSDIR% --with-berkeley-db=%INSDIR%
python gen-make.py --vsnet-version=%MSVC_VERSION% %SVN_APACHE_DEPS% %SVN_DEPS%
if "%1"=="configure" goto EXIT

:COMPILE
if not "%MSVC_VERSION%" geq "2010" goto VCBUILD
msbuild subversion_vcnet.sln /p:PlatformToolset=%MSVC_PLATFORMTOOLSET% /p:Platform=%TARGET_ARCH% /p:Configuration=Release /t:__MORE__ 
goto COMPILE_DONE
:VCBUILD
set VCBUILD_DEFAULT_CFG=Release|%TARGET_ARCH%
rem vcbuild 
set VCBUILD_DEFAULT_CFG=
:COMPILE_DONE
if "%1"=="compile" goto EXIT

:INSTALL
rem make dist
mkdir %INSDIR%

mkdir %INSDIR%\include

mkdir %INSDIR%\lib

mkdir %INSDIR%\bin

if "%1"=="install" goto EXIT

:EXIT
cd %BUILDROOT%
