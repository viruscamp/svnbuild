setlocal
set MAKE_DIR=%~dp0

call %MAKE_DIR%\env.bat

call %MAKE_DIR%\make-subversion.bat test sasl

endlocal
