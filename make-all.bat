setlocal
set MAKE_DIR=%~dp0

call %MAKE_DIR%\env.bat

@rem static lib
call %MAKE_DIR%\make-zlib.bat
@rem source
call %MAKE_DIR%\make-sqlite.bat unpack

call %MAKE_DIR%\make-libintl.bat

call %MAKE_DIR%\make-openssl.bat

call %MAKE_DIR%\make-apache.bat

if "%VER_SERF%" geq "2.0.0" ( call %MAKE_DIR%\make-serf2.bat ) else ( call %MAKE_DIR%\make-serf.bat )

if "%USE_DB%"=="DB4" call %MAKE_DIR%\make-db4.bat
if "%USE_DB%"=="DB5" call %MAKE_DIR%\make-db5.bat

if not "%VER_SASL%"=="" call %MAKE_DIR%\make-sasl.bat

call %MAKE_DIR%\make-subversion.bat
endlocal