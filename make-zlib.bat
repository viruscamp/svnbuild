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
if "%1"=="unpack" goto EXIT

:COMPILE
nmake -f win32\Makefile.msc
if "%1"=="compile" goto EXIT

:INSTALL
mkdir %INSDIR%

@rem mkdir %INSDIR%\bin
@rem copy /y zlib1.dll %INSDIR%\bin
@rem copy /y zlib1.pdb %INSDIR%\bin

mkdir %INSDIR%\include
copy /y zconf.h %INSDIR%\include
copy /y zlib.h %INSDIR%\include

mkdir %INSDIR%\lib
copy /y zlib.lib %INSDIR%\lib
@rem copy /y zdll.lib %INSDIR%\lib

mkdir %INSDIR%\licenses\zlib
copy /y LICENSE %INSDIR%\licenses\zlib
copy /y README %INSDIR%\licenses\zlib

if "%1"=="install" goto EXIT

:EXIT
cd %BUILDROOT%
