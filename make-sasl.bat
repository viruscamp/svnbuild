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
@rem some old VC like VC2010 do not treat include paths priority correct, it may use include\md5global.h 
copy /y win32\include\md5global.h include\
if "%1"=="unpack" goto EXIT

:COMPILE
if "%VER_DB%"=="DB4" set SASL_DB_ARGS=DB_INCLUDE=%INSDIR%\include\db-4 DB_LIB=libdb48.lib DB_LIBPATH=%INSDIR%\lib
if "%VER_DB%"=="DB5" set SASL_DB_ARGS=DB_INCLUDE=%INSDIR%\include\db-5 DB_LIB=libdb53.lib DB_LIBPATH=%INSDIR%\lib
set SASL_OPENSSL_ARGS=OPENSSL_INCLUDE=%INSDIR%\include OPENSSL_LIBPATH=%INSDIR%\lib
nmake -f NTMakefile NTLM=1 SRP=1 OTP=1 PASSDSS=1 %SASL_DB_ARGS% %SASL_OPENSSL_ARGS% prefix=%INSDIR%
if "%1"=="compile" goto EXIT

:INSTALL
nmake -f NTMakefile NTLM=1 SRP=1 OTP=1 PASSDSS=1 %SASL_DB_ARGS% %SASL_OPENSSL_ARGS% prefix=%INSDIR% install
mkdir %INSDIR%

mkdir %INSDIR%\include

mkdir %INSDIR%\lib

mkdir %INSDIR%\bin

if "%1"=="install" goto EXIT

:EXIT
cd %BUILDROOT%
