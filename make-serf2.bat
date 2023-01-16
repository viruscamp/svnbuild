if "%VER_SERF%"=="" set VER_SERF=2.0.0

if "%1"=="" goto UNPACK
if "%1"=="unpack" goto UNPACK
if not exist serf-%VER_SERF% goto UNPACK
cd serf-%VER_SERF%
if "%1"=="compile" goto COMPILE
if "%1"=="install" goto INSTALL
if "%1"=="test" goto TEST

:UNPACK
rmdir /s /q serf-%VER_SERF%
7z x %SOURCES_DIR%\serf-%VER_SERF%.zip -aoa -tzip -o.
cd serf-%VER_SERF%
:UNPACK_DONE
if "%1"=="unpack" goto EXIT

:COMPILE
%SCONSCMD% PREFIX=%INSDIR% LIBDIR=%INSDIR%\lib APR=%APDIR% APU=%APDIR% OPENSSL=%INSDIR% ZLIB=%INSDIR% CFLAGS="/I%INSDIR%\include" LINKFLAGS="/LIBPATH:%INSDIR%\lib /LIBPATH:%APDIR%\lib" TARGET_ARCH=%TARGET_ARCH%
:COMPILE_DONE
if "%1"=="compile" goto EXIT

:INSTALL
%SCONSCMD% install
mkdir %INSDIR%
mkdir %INSDIR%\bin
copy /y libserf-*.dll %INSDIR%\bin
copy /y libserf-*.pdb %INSDIR%\bin
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
