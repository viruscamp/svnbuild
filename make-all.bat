setlocal
set MAKE_DIR=%~dp0

call %MAKE_DIR%\env.bat

echo make-zlib %VER_ZLIB% >> %BUILDROOT%\build.log
time /t >> %BUILDROOT%\build.log
@rem static lib
call %MAKE_DIR%\make-zlib.bat
time /t >> %BUILDROOT%\build.log

echo make-sqlite %VER_SQLITE% >> %BUILDROOT%\build.log
time /t >> %BUILDROOT%\build.log
@rem source
call %MAKE_DIR%\make-sqlite.bat unpack
time /t >> %BUILDROOT%\build.log

echo make-libintl %VER_LIBINTL% >> %BUILDROOT%\build.log
time /t >> %BUILDROOT%\build.log
call %MAKE_DIR%\make-libintl.bat
time /t >> %BUILDROOT%\build.log

echo make-openssl %VER_OPENSSL% >> %BUILDROOT%\build.log
time /t >> %BUILDROOT%\build.log
call %MAKE_DIR%\make-openssl.bat
time /t >> %BUILDROOT%\build.log

echo make-apache >> %BUILDROOT%\build.log
call %MAKE_DIR%\make-apache.bat

echo make-serf %VER_SERF% >> %BUILDROOT%\build.log
time /t >> %BUILDROOT%\build.log
if "%VER_SERF%" geq "2.0.0" ( call %MAKE_DIR%\make-serf2.bat ) else ( call %MAKE_DIR%\make-serf.bat )
time /t >> %BUILDROOT%\build.log

if "%USE_DB%"=="DB4" (echo make-db4 %VER_DB4%) >> %BUILDROOT%\build.log
if "%USE_DB%"=="DB5" (echo make-db5 %VER_DB5%) >> %BUILDROOT%\build.log
time /t >> %BUILDROOT%\build.log
if "%USE_DB%"=="DB4" call %MAKE_DIR%\make-db4.bat
if "%USE_DB%"=="DB5" call %MAKE_DIR%\make-db5.bat
time /t >> %BUILDROOT%\build.log

echo make-sasl %VER_SASL% >> %BUILDROOT%\build.log
time /t >> %BUILDROOT%\build.log
if not "%VER_SASL%"=="" call %MAKE_DIR%\make-sasl.bat
time /t >> %BUILDROOT%\build.log

echo make-subversion %VER_SUBVERSION% >> %BUILDROOT%\build.log
time /t >> %BUILDROOT%\build.log
call %MAKE_DIR%\make-subversion.bat
time /t >> %BUILDROOT%\build.log
endlocal