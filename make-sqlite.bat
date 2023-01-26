if "%VER_SQLITE%"=="" set VER_SQLITE=3380500

if "%1"=="" goto UNPACK
if "%1"=="unpack" goto UNPACK
if not exist sqlite-amalgamation-%VER_SQLITE% goto UNPACK
cd sqlite-%VER_SQLITE%
if "%1"=="compile" goto COMPILE
if "%1"=="install" goto INSTALL

:UNPACK
rmdir /s /q sqlite-amalgamation-%VER_SQLITE%
7z x %SOURCES_DIR%\sqlite-amalgamation-%VER_SQLITE%.zip -aoa -tzip -o.
copy /y %SOURCES_DIR%\sqlite3-winmakefiles\Makefile.msc sqlite-amalgamation-%VER_SQLITE%\
copy /y %SOURCES_DIR%\sqlite3-winmakefiles\Replace.cs sqlite-amalgamation-%VER_SQLITE%\
copy /y %SOURCES_DIR%\sqlite3-winmakefiles\sqlite3.rc sqlite-amalgamation-%VER_SQLITE%\
copy /y %SOURCES_DIR%\sqlite3-winmakefiles\sqlite3rc.h sqlite-amalgamation-%VER_SQLITE%\
cd sqlite-amalgamation-%VER_SQLITE%
if "%1"=="unpack" goto EXIT

:COMPILE
nmake -f Makefile.msc DYNAMIC_SHELL=1
if "%1"=="compile" goto EXIT

:INSTALL
mkdir %INSDIR%

mkdir %INSDIR%\bin
copy /y sqlite3.dll %INSDIR%\bin
copy /y sqlite3.pdb %INSDIR%\bin
copy /y sqlite3.exe %INSDIR%\bin
copy /y sqlite3sh.pdb %INSDIR%\bin

mkdir %INSDIR%\include
copy /y sqlite3.h %INSDIR%\include
copy /y sqlite3ext.h %INSDIR%\include

mkdir %INSDIR%\lib
copy /y sqlite3.lib %INSDIR%\lib
copy /y sqlite3.lo %INSDIR%\lib

if "%1"=="install" goto EXIT

:EXIT
cd %BUILDROOT%
