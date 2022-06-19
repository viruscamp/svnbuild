Download sources\* as sources\list.txt

Place tools\* as tools\list.txt, select 32bit or 64bit.

Open a vs develop command here:

mkdir work
copy /y conf.bat.template work\conf.bat
cd work
edit conf.bat
call conf.bat
call ..\make-all.bat
