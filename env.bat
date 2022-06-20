set PATH=%SEVENZIPPATH%;%PATH%

if "%TARGET_ARCH%"=="x86" set TARGET_ARCH=win32

if "%MSVC_VERSION%"=="7.0" set MSVC_VERSION=2002
if "%MSVC_VERSION%"=="7.1" set MSVC_VERSION=2003
if "%MSVC_VERSION%"=="8.0" set MSVC_VERSION=2005
if "%MSVC_VERSION%"=="9.0" set MSVC_VERSION=2008
if "%MSVC_VERSION%"=="10.0" set MSVC_VERSION=2010
if "%MSVC_VERSION%"=="11.0" set MSVC_VERSION=2012
if "%MSVC_VERSION%"=="12.0" set MSVC_VERSION=2013
if "%MSVC_VERSION%"=="14.0" set MSVC_VERSION=2015
if "%MSVC_VERSION%"=="14.1" set MSVC_VERSION=2017
if "%MSVC_VERSION%"=="14.2" set MSVC_VERSION=2019
if "%MSVC_VERSION%"=="14.3" set MSVC_VERSION=2022

if not "%MSVC_PLATFORMTOOLSET%"=="" goto MSVC_PLATFORMTOOLSET_DONE
if "%MSVC_VERSION%"=="2010" set MSVC_PLATFORMTOOLSET=v100
if "%MSVC_VERSION%"=="2012" set MSVC_PLATFORMTOOLSET=v110
if "%MSVC_VERSION%"=="2013" set MSVC_PLATFORMTOOLSET=v120
if "%MSVC_VERSION%"=="2015" set MSVC_PLATFORMTOOLSET=v140
if "%MSVC_VERSION%"=="2017" set MSVC_PLATFORMTOOLSET=v141
if "%MSVC_VERSION%"=="2019" set MSVC_PLATFORMTOOLSET=v142
if "%MSVC_VERSION%"=="2022" set MSVC_PLATFORMTOOLSET=v143
:MSVC_PLATFORMTOOLSET_DONE

rem gettext
set PATH=%TOOLS_DIR%\gettext-0.14.4-bin\bin;%PATH%

rem other tools wget awk nasm patch
set PATH=%TOOLS_DIR%\bin;%PATH%

set PATH=%TOOLS_DIR%\perl\perl\bin;%PATH%
@rem set PATH=C:\Strawberry\perl\bin;%PATH%

set PY_SETUP=PY2XP
set SCONS_SETUP=SCONS_LOCAL

if "%PY_SETUP%"=="PY2XPGREEN" goto PY2XPGREEN
if "%PY_SETUP%"=="PY2XP" goto PY2XP
if "%PY_SETUP%"=="PY3X64EMBE" goto PY3X64EMBE

:PY2XP
set PATH=c:\Python27;%PATH%
goto PY_SETUP_END

:PY2XPGREEN
set PYTHONHOME=%TOOLS_DIR%\PortablePython27\App\Python
set PYTHONPATH=%PYTHONHOME%
set PATH=%PYTHONPATH%;%PYTHONPATH%\Scripts;%PATH%
goto PY_SETUP_END

:PY3X64EMBE
set PYTHONHOME=%TOOLS_DIR%\Python
set PYTHONPATH=%PYTHONHOME%
set PYTHONSTARTUP=%PYTHONPATH%\Lib\ppp.py
set PATH=%PYTHONPATH%;%PYTHONPATH%\Scripts;%PATH%
set SCONSCMD="%PYTHONPATH%\Scripts\scons"
goto SCONS_SETUP_END

:PY_SETUP_END

if "%SCONS_SETUP%"=="SCONS_PIP" goto SCONS_PIP
if "%SCONS_SETUP%"=="SCONS_LOCAL" goto SCONS_LOCAL

:SCONS_LOCAL
set PATH=%TOOLS_DIR%\scons-local;%PATH%
set SCONSCMD=python "%TOOLS_DIR%\scons-local\scons.py"
goto SCONS_SETUP_END

:SCONS_PIP
set SCONSCMD=python "%PYTHONPATH%\Scripts\scons"
goto SCONS_SETUP_END

:SCONS_SETUP_END
