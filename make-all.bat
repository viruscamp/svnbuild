set MAKE_DIR=%~dp0

call %MAKE_DIR%\env.bat

call %MAKE_DIR%\make-zlib.bat
call %MAKE_DIR%\make-sqlite.bat
call %MAKE_DIR%\make-libintl.bat

call %MAKE_DIR%\make-openssl.bat

call %MAKE_DIR%\make-serf.bat

if "%VER_DB%"=="DB4" call %MAKE_DIR%\make-db4.bat
if "%VER_DB%"=="DB5" call %MAKE_DIR%\make-db5.bat

call %MAKE_DIR%\make-sasl.bat

call %MAKE_DIR%\make-subversion.bat
