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
set SVN_DEPS=--with-openssl=%INSDIR% --with-zlib=%INSDIR% --with-libintl=%INSDIR% --with-serf=%INSDIR%
if "%VER_SQLITE%"=="" (set SVN_SQLITE_DEPS=) else set SVN_SQLITE_DEPS=--with-sqlite=%INSDIR%
if "%VER_SASL%"=="" (set SVN_SASL_DEPS=) else set SVN_SASL_DEPS=--with-sasl=%INSDIR%
if "%USE_DB%"=="" (set SVN_DB_DEPS=) else set SVN_DB_DEPS=--with-berkeley-db=%INSDIR%
python gen-make.py --vsnet-version=%MSVC_VERSION% %SVN_APACHE_DEPS% %SVN_DEPS% %SVN_DB_DEPS% %SVN_SASL_DEPS% %SVN_SQLITE_DEPS%
if "%1"=="configure" goto EXIT

:COMPILE
if not "%MSVC_VERSION%" geq "2010" goto VCBUILD
msbuild subversion_vcnet.sln /p:PlatformToolset=%MSVC_PLATFORMTOOLSET% /p:Platform=%TARGET_ARCH% /p:Configuration=Release /t:__MORE__ 
goto COMPILE_DONE
:VCBUILD
vcbuild subversion_vcnet.sln "Release|%TARGET_ARCH%"
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
