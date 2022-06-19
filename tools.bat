rem perl portable
wget https://strawberryperl.com/download/5.32.1.1/strawberry-perl-5.32.1.1-32bit-portable.zip

if "%PY_SETUP%"=="PY2XPGREEN" goto PY2XPGREEN
if "%PY_SETUP%"=="PY2XP" goto PY2XP
if "%PY_SETUP%"=="PY3XP" goto PY3XP
if "%PY_SETUP%"=="PY3X64EMBE" goto PY3X64EMBE

:PY2XPGREEN
rem python-2.x portable for xp, using 7zip to extract
wget https://master.dl.sourceforge.net/project/portable-python/Portable%20Python%202.7/Portable%20Python%202.7.15%20Basic.exe?viasf=1
7zip
rename
set PYTHONHOME=%CD%\PortablePython27\App\Python
set PYTHONPATH=%PYTHONHOME%
set PYTHONSTARTUP=%PYTHONPATH%\Lib\ppp.py
set PATH=%PYTHONPATH%;%PYTHONPATH%\Scripts;%PATH%
python -m pip install pywin32
rem https://files.pythonhosted.org/packages/4a/78/d0065741617ee422e403ec92019346cf442f2ed65de8964c65ea98406bb5/pywin32-228-cp27-cp27m-win32.whl (6.9MB)
goto PY_SETUP_END

:PY2XP
rem python-2.x installer for xp
wget https://www.python.org/ftp/python/2.7.18/python-2.7.18.msi
wget https://nchc.dl.sourceforge.net/project/pywin32/pywin32/Build%20221/pywin32-221.win32-py2.7.exe
goto PY_SETUP_END

:PY3XP
rem python-3.x installer for xp
wget https://www.python.org/ftp/python/3.4.4/python-3.4.4.msi
wget https://jaist.dl.sourceforge.net/project/pywin32/pywin32/Build%20221/pywin32-221.win32-py3.4.exe
goto PY_SETUP_END

:PY3X64EMBE
rem python embeddable package (64-bit) not for xp
wget https://www.python.org/ftp/python/3.10.5/python-3.10.5-embed-amd64.zip
rem TODO
goto PY_SETUP_END

:PY_SETUP_END

if "%SCONS_SETUP%"=="SCONS_PIP" goto SCONS_PIP
if "%SCONS_SETUP%"=="SCONS_LOCAL" goto SCONS_LOCAL

:SCONS_PIP
python -m pip install scons
goto SCONS_SETUP_END

:SCONS_LOCAL
rem scons-local or pip install scons
https://master.dl.sourceforge.net/project/scons/scons-local/3.1.2/scons-local-3.1.2.zip?viasf=1
goto SCONS_SETUP_END

:SCONS_SETUP_END
