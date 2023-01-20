if "%VER_ZLIB%"=="" set VER_ZLIB=1.2.13

if "%1"=="" goto UNPACK
if "%1"=="unpack" goto UNPACK
if not exist zlib-%VER_ZLIB% goto UNPACK
cd zlib-%VER_ZLIB%
if "%1"=="compile" goto COMPILE
if "%1"=="install" goto INSTALL

:UNPACK
rmdir /s /q zlib-%VER_ZLIB%
7z x %SOURCES_DIR%\zlib-%VER_ZLIB%.tar.gz -so | 7z x -aoa -si -ttar -o.
cd zlib-%VER_ZLIB%
patch -d . -p 1 --binary -f -i %SOURCES_DIR%\patches\zlib-win32-makefile-cmd-macro.patch
if "%1"=="unpack" goto EXIT

:COMPILE
if "%TARGET_WIN32_WINNT%"=="" (set MY_CFLAGS=) else (set MY_CFLAGS=-D_WIN32_WINNT=%TARGET_WIN32_WINNT%)
if "%TARGET_SUBSYSTEM%"=="" (set MY_LDFLAGS=) else (set MY_LDFLAGS=-subsystem:console,%TARGET_SUBSYSTEM%)
nmake -f win32\Makefile.msc
set MY_CFLAGS=
set MY_LDFLAGS=
if "%1"=="compile" goto EXIT

:INSTALL
mkdir %INSDIR%

mkdir %INSDIR%\include
copy /y zconf.h %INSDIR%\include
copy /y zlib.h %INSDIR%\include

mkdir %INSDIR%\lib
copy /y zlib.lib %INSDIR%\lib
@rem copy /y zdll.lib %INSDIR%\lib

@rem mkdir %INSDIR%\bin
@rem copy /y zlib1.dll %INSDIR%\bin
@rem copy /y zlib1.pdb %INSDIR%\bin
if "%1"=="install" goto EXIT

:EXIT
cd %BUILDROOT%
