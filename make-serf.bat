if "%VER_SERF%"=="" set VER_SERF=1.3.9

if "%1"=="" goto UNPACK
if "%1"=="unpack" goto UNPACK
if not exist serf-%VER_SERF% goto UNPACK
cd serf-%VER_SERF%
if "%1"=="compile" goto COMPILE
if "%1"=="install" goto INSTALL
if "%1"=="test" goto TEST

:UNPACK
rmdir /s /q serf-%VER_SERF%
7z x %SOURCES_DIR%\serf-%VER_SERF%.tar.bz2 -so | 7z x -aoa -si -ttar -o.
cd serf-%VER_SERF%
patch -d . -p 1 --binary -f -i %SOURCES_DIR%\patches\serf-1.3.9-openssl1-init.patch
patch -d . -p 1 --binary -f -i %SOURCES_DIR%\patches\serf-1.3.9-scons.patch
:UNPACK_DONE
if "%1"=="unpack" goto EXIT

:COMPILE
@rem _CL_ _LINK_ are invalid for scons
if "%TARGET_WIN32_WINNT%"=="" (set MY_CFLAGS=) else (set MY_CFLAGS=-D_WIN32_WINNT=%TARGET_WIN32_WINNT%)
if "%TARGET_SUBSYSTEM%"=="" (set MY_LDFLAGS=) else (set MY_LDFLAGS=-subsystem:console,%TARGET_SUBSYSTEM%)
%SCONSCMD% PREFIX=%INSDIR% LIBDIR=%INSDIR%\lib APR=%APDIR% APU=%APDIR% OPENSSL=%INSDIR% ZLIB=%INSDIR% CFLAGS="%MY_CFLAGS% /I%INSDIR%\include" LINKFLAGS="%MY_LDFLAGS% /LIBPATH:%INSDIR%\lib /LIBPATH:%APDIR%\lib" TARGET_ARCH=%TARGET_ARCH%
set MY_CFLAGS=
set MY_LDFLAGS=
:COMPILE_DONE
if "%1"=="compile" goto EXIT

:INSTALL
%SCONSCMD% install

del /f %INSDIR%\lib\libserf-*.dll %INSDIR%\lib\libserf-*.pdb

mkdir %INSDIR%\bin
copy /y libserf-*.dll %INSDIR%\bin
copy /y libserf-*.pdb %INSDIR%\bin

mkdir %INSDIR%\licenses\serf
copy /y LICENSE %INSDIR%\licenses\serf
copy /y README %INSDIR%\licenses\serf
copy /y NOTICE %INSDIR%\licenses\serf

if "%1"=="install" goto EXIT

goto EXIT
:TEST
setlocal
set PATH=%INSDIR%\bin\;%PATH%
%SCONSCMD% check
endlocal
goto EXIT

:EXIT
cd %BUILDROOT%
