if "%VER_DB4%"=="" set VER_DB4=4.8.30

if "%1"=="" goto UNPACK
if "%1"=="unpack" goto UNPACK
if not exist db-%VER_DB4% goto UNPACK
cd db-%VER_DB4%
if "%1"=="compile" goto COMPILE
if "%1"=="install" goto INSTALL

:UNPACK
rmdir /s /q db-%VER_DB4%
7z x %SOURCES_DIR%\db-%VER_DB4%.tar.gz -so | 7z x -aoa -si -ttar -o.
patch -d . -p 1 --binary -f -i %SOURCES_DIR%\patches\db4-cxx-vc.patch
7z x %SOURCES_DIR%\db-4.8.30-build_windows_vcxproj.zip -aoa -tzip -o.\db-%VER_DB4%\build_windows\
cd db-%VER_DB4%
if "%1"=="unpack" goto EXIT

:COMPILE
if not "%MSVC_VERSION%" geq "2010" goto VCBUILD
msbuild build_windows\db.vcxproj /p:PlatformToolset=%MSVC_PLATFORMTOOLSET% /p:Platform=%TARGET_ARCH% /p:Configuration=Release
goto COMPILE_DONE
:VCBUILD
set VCBUILD_DEFAULT_CFG=Release|%TARGET_ARCH%
vcbuild build_windows\db.vcproj
set VCBUILD_DEFAULT_CFG=
:COMPILE_DONE
if "%1"=="compile" goto EXIT

:INSTALL
mkdir %INSDIR%

mkdir %INSDIR%\include
copy /y build_windows\*.h %INSDIR%\include

mkdir %INSDIR%\lib
copy /y build_windows\%TARGET_ARCH%\Release\libdb*.lib %INSDIR%\lib

mkdir %INSDIR%\bin
copy /y build_windows\%TARGET_ARCH%\Release\libdb*.dll %INSDIR%\bin
copy /y build_windows\%TARGET_ARCH%\Release\libdb*.pdb %INSDIR%\bin
if "%1"=="install" goto EXIT

:EXIT
cd %BUILDROOT%
