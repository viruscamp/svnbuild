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
if "%USE_DB%"=="DB4" (set VER_DB=%VER_DB4%)
if "%USE_DB%"=="DB5" (set VER_DB=%VER_DB5%)
set SVN_APACHE_DEPS=--with-httpd=%APDIR% --with-apr=%APDIR% --with-apr-util=%APDIR% --with-apr-iconv=%APDIR%
set SVN_DEPS_SHARED=--with-openssl=%INSDIR% --with-libintl=%INSDIR% --with-serf=%BUILDROOT%\serf-%VER_SERF%
set SVN_DEPS_STATIC=--with-zlib=%BUILDROOT%\zlib-%VER_ZLIB% --with-sqlite=%BUILDROOT%\sqlite-amalgamation-%VER_SQLITE%
if "%VER_SASL%"=="" (set SVN_SASL_DEPS=) else set SVN_SASL_DEPS=--with-sasl=%INSDIR%
if "%USE_DB%"=="" (set SVN_DB_DEPS=) else set SVN_DB_DEPS=--with-berkeley-db=%BUILDROOT%\db-%VER_DB%\out
if "%USE_SHARED_SERF%"=="" (set SVN_SHARED_SERF=) else (set SVN_SHARED_SERF=--with-shared-serf)
python gen-make.py --vsnet-version=%MSVC_VERSION% %SVN_APACHE_DEPS% %SVN_DEPS_SHARED% %SVN_DEPS_STATIC% %SVN_DB_DEPS% %SVN_SASL_DEPS% %SVN_SHARED_SERF%
if "%1"=="configure" goto EXIT

:COMPILE
if not "%MSVC_VERSION%" geq "2010" goto VCBUILD
if not "%MSVC_PLATFORMTOOLSET%"=="" goto MSBUILD
@echo fail to build with MSVC_VERSION=%MSVC_VERSION% MSVC_PLATFORMTOOLSET=%MSVC_PLATFORMTOOLSET%
goto EXIT

:MSBUILD
msbuild subversion_vcnet.sln /p:PlatformToolset=%MSVC_PLATFORMTOOLSET% /p:Platform=%TARGET_ARCH% /p:Configuration=Release /t:__MORE__
goto COMPILE_DONE

:VCBUILD
vcbuild subversion_vcnet.sln "Release|%TARGET_ARCH%"
goto COMPILE_DONE

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
xcopy package\dist\lib\svn*.pdb %INSDIR%\bin\ /s /e /q /h /r /y
xcopy package\dist\lib\libsvn*.lib %INSDIR%\lib\ /s /e /q /h /r /y
xcopy package\dist\lib\libsvn*.pdb %INSDIR%\bin\ /s /e /q /h /r /y

mkdir %INSDIR%\licenses\svn
copy /y LICENSE %INSDIR%\licenses\svn
copy /y README %INSDIR%\licenses\svn
copy /y NOTICE %INSDIR%\licenses\svn

if "%1"=="install" goto EXIT

goto EXIT
:TEST
setlocal
xcopy /S /Y %INSDIR%\bin\libapriconv*.dll Release\
xcopy /S /Y %INSDIR%\bin\libcrypto*.dll Release\
xcopy /S /Y %INSDIR%\bin\libssl*.dll Release\
xcopy /S /Y %INSDIR%\bin\sasl*.dll Release\

if "%2"=="" (set TEST_METHOD=local) else (set TEST_METHOD=%2)
set TEST_ARGS=

if not "%TEST_METHOD%"=="local" goto TEST_METHOD_LOCAL_DONE
set TEST_ARGS=
set TEST_LOG=tests.log
set TEST_FAIL=fails.log
goto TEST_START
:TEST_METHOD_LOCAL_DONE

if not "%TEST_METHOD%"=="http" goto TEST_METHOD_HTTP_DONE
set TEST_ARGS=--httpd-dir=%APDIR%
set TEST_LOG=dav-tests.log
set TEST_FAIL=dav-fails.log
goto TEST_START
:TEST_METHOD_HTTP_DONE

if not "%TEST_METHOD%"=="https" goto TEST_METHOD_HTTPS_DONE
set TEST_ARGS=--httpd-dir=%APDIR% --https
set TEST_LOG=dav-tests.log
set TEST_FAIL=dav-fails.log
goto TEST_START
:TEST_METHOD_HTTPS_DONE

if not "%TEST_METHOD%"=="svnserve" goto TEST_METHOD_SVNSERVE_DONE
set TEST_ARGS=--url=svn://localhost
set TEST_LOG=svn-tests.log
set TEST_FAIL=svn-fails.log
goto TEST_START
:TEST_METHOD_SVNSERVE_DONE

if not "%TEST_METHOD%"=="sasl" goto TEST_METHOD_SASL_DONE
set TEST_ARGS=--enable-sasl
set TEST_LOG=svn-tests.log
set TEST_FAIL=svn-fails.log
goto TEST_START
:TEST_METHOD_SASL_DONE

echo unknown TEST_METHOD="%TEST_METHOD%"
goto TEST_END

:TEST_START
echo. >> %BUILDROOT%\build.log
echo svn test %TEST_METHOD% >> %BUILDROOT%\build.log
time /t >> %BUILDROOT%\build.log
del /f Release\%TEST_LOG% Release\%TEST_FAIL%
python win-tests.py -c -r -v %TEST_ARGS%
time /t >> %BUILDROOT%\build.log
copy /y Release\%TEST_LOG% %BUILDROOT%\svn-tests-%TEST_METHOD%.log
copy /y Release\%TEST_FAIL% %BUILDROOT%\svn-fails-%TEST_METHOD%.log

:TEST_END
endlocal
goto EXIT

:EXIT
cd %BUILDROOT%
