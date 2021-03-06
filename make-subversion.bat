if "%VER_SUBVERSION%"=="" set VER_SUBVERSION=1.14.2

if "%1"=="" goto UNPACK
if "%1"=="unpack" goto UNPACK
if not exist subversion-%VER_SUBVERSION% goto UNPACK
cd subversion-%VER_SUBVERSION%
if "%1"=="configure" goto CONFIGURE
if "%1"=="compile" goto COMPILE
if "%1"=="install" goto INSTALL
if "%1"=="test" goto TEST

:UNPACK
rmdir /s /q subversion-%VER_SUBVERSION%
7z x %SOURCES_DIR%\subversion-%VER_SUBVERSION%.tar.bz2 -so | 7z x -aoa -si -ttar -o.
cd subversion-%VER_SUBVERSION%
patch -d . -p 1 --binary -f -i %SOURCES_DIR%\patches\subversion-db-without-apu.patch
patch -d . -p 1 --binary -f -i %SOURCES_DIR%\patches\subversion-gen-make-win-dep.patch
patch -d . -p 1 --binary -f -i %SOURCES_DIR%\patches\subversion-win32-make-dist.patch
if "%1"=="unpack" goto EXIT

:CONFIGURE
set SVN_APACHE_DEPS=--with-httpd=%APDIR% --with-apr=%APDIR% --with-apr-util=%APDIR% --with-apr-iconv=%APDIR%
set SVN_DEPS=--with-openssl=%INSDIR% --with-zlib=%INSDIR% --with-libintl=%INSDIR% --with-serf=%INSDIR% --with-sqlite=%INSDIR%
if "%VER_SASL%"=="" (set SVN_SASL_DEPS=) else set SVN_SASL_DEPS=--with-sasl=%INSDIR%
if "%USE_DB%"=="" (set SVN_DB_DEPS=) else set SVN_DB_DEPS=--with-berkeley-db=%INSDIR%
if "%USE_SHARED_SERF%"=="1" (set SVN_SHARED_SERF=--with-shared-serf) else (set SVN_SHARED_SERF=)
python gen-make.py --vsnet-version=%MSVC_VERSION% %SVN_APACHE_DEPS% %SVN_DEPS% %SVN_DB_DEPS% %SVN_SASL_DEPS% %SVN_SHARED_SERF%
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
@rem make dist
copy /y build\win32\make_dist.conf.template build\win32\make_dist.conf
python build\win32\make_dist.py dist package
xcopy package\dist\bin\* %INSDIR%\bin\ /s /e /q /h /r /y
mkdir %INSDIR%\share\locale
xcopy package\dist\share\locale %INSDIR%\share\locale /s /e /q /h /r /y
xcopy package\dist\lib\svn*.lib %INSDIR%\lib\ /s /e /q /h /r /y
xcopy package\dist\lib\svn*.pdb %INSDIR%\lib\ /s /e /q /h /r /y
xcopy package\dist\lib\libsvn*.lib %INSDIR%\lib\ /s /e /q /h /r /y
xcopy package\dist\lib\libsvn*.pdb %INSDIR%\lib\ /s /e /q /h /r /y

if "%1"=="install" goto EXIT

goto EXIT
:TEST
setlocal
set PATH=%INSDIR%\bin\;%PATH%
mkdir Release\subversion\tests\cmdline
xcopy /S /Y subversion\tests\cmdline Release\subversion\tests\cmdline
python win-tests.py -c -r -v --httpd-dir=%APDIR%
endlocal
goto EXIT

:EXIT
cd %BUILDROOT%
