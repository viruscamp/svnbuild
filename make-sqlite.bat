if "%VER_SQLITE%"=="" set VER_SQLITE=3380500
if "%VER_SQLITE_SNAPSHOT%"=="" set VER_SQLITE_SNAPSHOT=202206101641

if "%1"=="" goto UNPACK
if "%1"=="unpack" goto UNPACK
if not exist sqlite-%VER_SQLITE% goto UNPACK
cd sqlite-%VER_SQLITE%
if "%1"=="compile" goto COMPILE
if "%1"=="install" goto INSTALL

:UNPACK
rmdir /s /q sqlite-snapshot-%VER_SQLITE_SNAPSHOT%
rmdir /s /q sqlite-amalgamation-%VER_SQLITE%
rmdir /s /q sqlite-%VER_SQLITE%
7z x %SOURCES_DIR%\sqlite-amalgamation-%VER_SQLITE%.zip -aoa -tzip -o.
7z x %SOURCES_DIR%\sqlite-snapshot-%VER_SQLITE_SNAPSHOT%.tar.gz -so | 7z x -aoa -si -ttar -o.
mkdir sqlite-%VER_SQLITE%
copy /y sqlite-snapshot-%VER_SQLITE_SNAPSHOT%\Makefile.msc sqlite-%VER_SQLITE%\
copy /y sqlite-snapshot-%VER_SQLITE_SNAPSHOT%\Replace.cs sqlite-%VER_SQLITE%\
copy /y sqlite-snapshot-%VER_SQLITE_SNAPSHOT%\sqlite3.rc sqlite-%VER_SQLITE%\
copy /y sqlite-snapshot-%VER_SQLITE_SNAPSHOT%\sqlite3rc.h sqlite-%VER_SQLITE%\
copy /y sqlite-amalgamation-%VER_SQLITE%\*.*  sqlite-%VER_SQLITE%\
rmdir /s /q sqlite-snapshot-%VER_SQLITE_SNAPSHOT%
rmdir /s /q sqlite-amalgamation-%VER_SQLITE%
cd sqlite-%VER_SQLITE%
if "%1"=="unpack" goto EXIT

:COMPILE
nmake -f Makefile.msc DYNAMIC_SHELL=1
if "%1"=="compile" goto EXIT

:INSTALL
mkdir %INSDIR%

mkdir %INSDIR%\include
copy /y sqlite3.h %INSDIR%\include
copy /y sqlite3ext.h %INSDIR%\include

mkdir %INSDIR%\lib
copy /y sqlite3.lib %INSDIR%\lib
copy /y sqlite3.lo %INSDIR%\lib

mkdir %INSDIR%\bin
copy /y sqlite3.dll %INSDIR%\bin
copy /y sqlite3.pdb %INSDIR%\bin
copy /y sqlite3.exe %INSDIR%\bin
copy /y sqlite3sh.pdb %INSDIR%\bin
if "%1"=="install" goto EXIT

:EXIT
cd %BUILDROOT%
