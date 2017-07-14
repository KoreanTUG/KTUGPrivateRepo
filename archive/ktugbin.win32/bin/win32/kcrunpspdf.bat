@echo off
set BASEFILENAME=%~n1
if .%2.==.. goto SINGLE
goto DOUBLE

:SINGLE
latex -synctex=1 "%BASEFILENAME%"
dvips "%BASEFILENAME%"
call ps2pdf "%BASEFILENAME%.ps"
goto EXIT

:DOUBLE
latex -synctex=1 "%BASEFILENAME%"
dvips %2 "%BASEFILENAME%"
call ps2pdf "%BASEFILENAME%.ps"
goto EXIT

:EXIT
set BASEFILENAME=
