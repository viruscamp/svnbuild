if "%TARGET_ARCH%"=="x86" set TARGET_ARCH=win32

@rem we can only compare using year version 
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

@rem explain for MSVC_PLATFORMTOOLSET
@rem *.props *.targets files those define cl, link, crt includes and libs, windows-sdk to use with msbuild and *.vcxproj files
@rem VS2010 VCTargetsPath=C:\Program Files\MSBuild\Microsoft.Cpp\v4.0
@rem VS2019 VCTargetsPath=C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\MSBuild\Microsoft\VC\v160

@rem 0. each VS version from 2010 contains a default toolset like below
@rem 1. there are 4 xp compat toolsets can be installed: v110_xp v120_xp v140_xp v141_xp
@rem 2. there are toolsets from windows sdks like: Windows7.1SDK
@rem  Windows7.1SDK is just v100 that replace WindowsSDK-7.0A with WindowsSDK-7.1
@rem  ${VCTargetsPath}\Platforms\${Arch}\PlatformToolsets\Windows7.1SDK\Microsoft.Cpp.${Arch}.Windows7.1SDK.props
@rem  ${VCTargetsPath}\Platforms\${Arch}\PlatformToolsets\Windows7.1SDK\Microsoft.Cpp.${Arch}.Windows7.1SDK.targets
@rem 3. v90 platform toolset is shipped only with vs2010, with it we can use vc2008 cl with msbuild
@rem  ${VCTargetsPath}\Platforms\${Arch}\PlatformToolsets\v90\Microsoft.Cpp.${Arch}.v90.props
@rem  ${VCTargetsPath}\Platforms\${Arch}\PlatformToolsets\v90\Microsoft.Cpp.${Arch}.v90.targets
@rem 4. you can make v60 v70 v71 v80 toolsets by youself, just copy and modify v90 files
if not "%MSVC_PLATFORMTOOLSET%"=="" goto MSVC_PLATFORMTOOLSET_DONE
if "%MSVC_VERSION%"=="2008" set MSVC_PLATFORMTOOLSET=v90
if "%MSVC_VERSION%"=="2010" set MSVC_PLATFORMTOOLSET=v100
if "%MSVC_VERSION%"=="2012" set MSVC_PLATFORMTOOLSET=v110
if "%MSVC_VERSION%"=="2013" set MSVC_PLATFORMTOOLSET=v120
if "%MSVC_VERSION%"=="2015" set MSVC_PLATFORMTOOLSET=v140
if "%MSVC_VERSION%"=="2017" set MSVC_PLATFORMTOOLSET=v141
if "%MSVC_VERSION%"=="2019" set MSVC_PLATFORMTOOLSET=v142
if "%MSVC_VERSION%"=="2022" set MSVC_PLATFORMTOOLSET=v143
:MSVC_PLATFORMTOOLSET_DONE

@rem gettext
set PATH=%TOOLS_DIR%\gettext-0.14.4-bin\bin;%PATH%

@rem other tools wget awk nasm patch
set PATH=%TOOLS_DIR%\bin;%PATH%

@rem 7zip
set PATH=%SEVENZIPPATH%;%PATH%

@rem perl
set PATH=%PERLHOME%\perl\bin;%PATH%

@rem python and scons
set PYTHONPATH=%PYTHONHOME%
set PATH=%PYTHONPATH%;%PYTHONPATH%\Scripts;%PATH%
set PYTHONSTARTUP=
if exist "%PYTHONPATH%\Lib\ppp.py" set PYTHONSTARTUP="%PYTHONPATH%\Lib\ppp.py"
set SCONSCMD=python "%TOOLS_DIR%\scons-local\scons.py"
