if "%VER_SASL%"=="" set VER_SASL=2.1.28

if "%1"=="" goto UNPACK
if "%1"=="unpack" goto UNPACK
if not exist cyrus-sasl-%VER_SASL% goto UNPACK
cd cyrus-sasl-%VER_SASL%
if "%1"=="compile" goto COMPILE
if "%1"=="install" goto INSTALL

:UNPACK
rmdir /s /q cyrus-sasl-%VER_SASL%
7z x %SOURCES_DIR%\cyrus-sasl-%VER_SASL%.tar.gz -so | 7z x -aoa -si -ttar -o.
cd cyrus-sasl-%VER_SASL%
patch -d . -p 1 --binary -f -i %SOURCES_DIR%\patches\cyrus-sasl-2.1.28-pull-732.patch
@rem see https://github.com/cyrusimap/cyrus-sasl/issues/751
@rem patch -d . -p 1 --binary -f -i %SOURCES_DIR%\patches\cyrus-sasl-2.1.28-rc4-1-887dbc0.patch
@rem patch -d . -p 1 --binary -f -i %SOURCES_DIR%\patches\cyrus-sasl-2.1.28-rc4-2-dfaa623.patch
@rem patch -d . -p 1 --binary -f -i %SOURCES_DIR%\patches\cyrus-sasl-2.1.28-rc4-3-c2bd3af.patch
@rem patch -d . -p 1 --binary -f -i %SOURCES_DIR%\patches\cyrus-sasl-2.1.28-rc4-4-54f6988.patch
@rem patch -d . -p 1 --binary -f -i %SOURCES_DIR%\patches\cyrus-sasl-2.1.28-rc4-5-725df6c.patch

patch -d . -p 1 --binary -f -i %SOURCES_DIR%\patches\cyrus-sasl-2.1.28-windllmain.patch
@rem some old VC like VC2010 do not treat include paths priority correct, it may use include\md5global.h 
copy /y win32\include\md5global.h include\
if "%1"=="unpack" goto EXIT

:COMPILE
set SASL_DB_ARGS=
if "%USE_DB%"=="DB4" set SASL_DB_ARGS=DB_INCLUDE=%INSDIR%\include DB_LIBPATH=%INSDIR%\lib DB_LIB=libdb48.lib
if "%USE_DB%"=="DB5" set SASL_DB_ARGS=DB_INCLUDE=%INSDIR%\include DB_LIBPATH=%INSDIR%\lib DB_LIB=libdb53.lib
if "%USE_DB%"=="LMDB" set SASL_DB_ARGS=SASLDB=LMDB DB_INCLUDE=%BUILDROOT%\liblmdb DB_LIBPATH=%BUILDROOT%\liblmdb DB_LIB=liblmdb.lib
set SASL_OPENSSL_ARGS=OPENSSL_INCLUDE=%INSDIR%\include OPENSSL_LIBPATH=%INSDIR%\lib
nmake -f NTMakefile NTLM=1 SRP=1 OTP=1 PASSDSS=1 %SASL_DB_ARGS% %SASL_OPENSSL_ARGS% prefix=%INSDIR%
if "%1"=="compile" goto EXIT

:INSTALL
nmake -f NTMakefile NTLM=1 SRP=1 OTP=1 PASSDSS=1 %SASL_DB_ARGS% %SASL_OPENSSL_ARGS% prefix=%INSDIR% install

move /y %INSDIR%\bin\sasl2\* %INSDIR%\bin\
rmdir %INSDIR%\bin\sasl2

mkdir %INSDIR%\licenses\cyrus-sasl
copy /y COPYING %INSDIR%\licenses\cyrus-sasl
copy /y README %INSDIR%\licenses\cyrus-sasl
copy /y AUTHORS %INSDIR%\licenses\cyrus-sasl

if "%1"=="install" goto EXIT

:EXIT
cd %BUILDROOT%
