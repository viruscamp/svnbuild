if "%VER_DB5%"=="" set VER_DB5=4.8.30

if "%1"=="" goto UNPACK
if "%1"=="unpack" goto UNPACK
if not exist db-%VER_DB5% goto UNPACK
cd db-%VER_DB5%
if "%1"=="compile" goto COMPILE
if "%1"=="install" goto INSTALL

:UNPACK
rmdir /s /q db-%VER_DB5%
7z x %SOURCES_DIR%\db-%VER_DB5%.tar.gz -so | 7z x -aoa -si -ttar -o.
cd db-%VER_DB5%
patch -d . -p 1 --binary -f -i %SOURCES_DIR%\patches\db5-cxx-vc.patch
if "%1"=="unpack" goto EXIT

:COMPILE
if not "%MSVC_VERSION%" geq "2010" goto VCBUILD

:MSBUILD
msbuild build_windows\VS10\db.vcxproj /p:PlatformToolset=%MSVC_PLATFORMTOOLSET% /p:Platform=%TARGET_ARCH% /p:Configuration=Release
goto COMPILE_DONE

:VCBUILD
@rem something goes wrong when upgrade in vs2008
@rem vcbuild /upgrade build_windows\VS8\db.vcproj
@rem vcbuild build_windows\VS8\db.vcproj "Release|%TARGET_ARCH%"
vcbuild build_windows\Berkeley_DB.sln "Release|%TARGET_ARCH%"

:COMPILE_DONE
if "%1"=="compile" goto EXIT

:INSTALL
mkdir %INSDIR%
mkdir out

mkdir %INSDIR%\include
copy /y build_windows\*.h %INSDIR%\include
mkdir out\include
copy /y build_windows\*.h out\include

mkdir %INSDIR%\lib
copy /y build_windows\%TARGET_ARCH%\Release\libdb*.lib %INSDIR%\lib
copy /y build_windows\%TARGET_ARCH%\Release\libdb*.exp %INSDIR%\lib
mkdir out\lib
copy /y build_windows\%TARGET_ARCH%\Release\libdb*.lib out\lib
copy /y build_windows\%TARGET_ARCH%\Release\libdb*.exp out\lib

mkdir %INSDIR%\bin
copy /y build_windows\%TARGET_ARCH%\Release\libdb*.dll %INSDIR%\bin
copy /y build_windows\%TARGET_ARCH%\Release\libdb*.pdb %INSDIR%\bin
mkdir out\bin
copy /y build_windows\%TARGET_ARCH%\Release\libdb*.dll out\bin
copy /y build_windows\%TARGET_ARCH%\Release\libdb*.pdb out\bin

mkdir %INSDIR%\licenses\bdb
copy /y LICENSE %INSDIR%\licenses\bdb
copy /y README %INSDIR%\licenses\bdb

if "%1"=="install" goto EXIT

:EXIT
cd %BUILDROOT%
