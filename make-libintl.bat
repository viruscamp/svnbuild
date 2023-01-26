if "%VER_LIBINTL%"=="" set VER_LIBINTL=0.14.6

if "%1"=="" goto UNPACK
if "%1"=="unpack" goto UNPACK
if not exist gettext-%VER_LIBINTL% goto UNPACK
cd gettext-%VER_LIBINTL%\gettext-runtime\intl\
if "%1"=="compile" goto COMPILE
if "%1"=="install" goto INSTALL
if "%1"=="test" goto TEST

:UNPACK
rmdir /s /q gettext-%VER_LIBINTL%
7z x %SOURCES_DIR%\gettext-%VER_LIBINTL%.zip -aoa -tzip -o.
cd gettext-%VER_LIBINTL%\gettext-runtime\intl\
patch -d . -p 0 --binary -f -i %SOURCES_DIR%\patches\libintl-tsvn-makefile.patch
patch -d . -p 0 --binary -f -i %SOURCES_DIR%\patches\libintl-version.patch
:UNPACK_DONE
if "%1"=="unpack" goto EXIT

:COMPILE
nmake -f Makefile.msvc DLL=1 prefix=%INSDIR%
:COMPILE_DONE
if "%1"=="compile" goto EXIT

:INSTALL
@rem nmake -f Makefile.msvc DLL=1 TARGET_ARCH=%TARGET_ARCH% prefix=%INSDIR% install
mkdir %INSDIR%

mkdir %INSDIR%\bin
copy /y intl3_svn.dll %INSDIR%\bin
copy /y intl3_svn.pdb %INSDIR%\bin

mkdir %INSDIR%\include
copy /y libintl.h %INSDIR%\include

mkdir %INSDIR%\lib
copy /y intl3_svn.lib %INSDIR%\lib

mkdir %INSDIR%\licenses\intl
copy /y COPYING.LIB-2.0 %INSDIR%\licenses\intl
copy /y COPYING.LIB-2.1 %INSDIR%\licenses\intl

if "%1"=="install" goto EXIT

goto EXIT
:TEST
%SCONSCMD% check
goto EXIT

:EXIT
cd %BUILDROOT%
