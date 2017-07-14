@echo off
rem TeXCompilyOntheFly batch file
rem written by Nova De hi, 2012-08-01
rem version 4, 2012-08-05

if .%1.==.. goto HELPSCREEN
if .%1.==.-h. goto HELPSCREEN
if .%1.==.--help. goto HELPSCREEN

if .%1.==.-f. goto FORCEFONTCHECK
if .%1.==.-c. goto SETFIRSTARG
set FORCEFONTCHECKSTATUS=0
set LATEXENGINE=xelatex
set JOBFILENAME=%1
goto MAINSTART

:SETFIRSTARG
set FORCEFONTCHECKSTATUS=0
if .%2.==.. goto HELPSCREEN
set LATEXENGINE=%2
if .%3.==.. goto HELPSCREEN
set JOBFILENAME=%3
goto MAINSTART

:FORCEFONTCHECK
set FORCEFONTCHECKSTATUS=1
if .%2.==.. goto HELPSCREEN
if .%2.==.-c. goto SubCheckVar
set LATEXENGINE=xelatex
set JOBFILENAME=%2
:SubCheckEnd
goto MAINSTART
:SubCheckVar
if .%3.==.. goto HELPSCREEN
set LATEXENGINE=%3
if .%4.==.. goto HELPSCREEN
set JOBFILENAME=%4
goto SubCheckEnd

:MAINSTART
sed --version >%TEMP%\null
if .%errorlevel%.==.0. goto RUN
goto SEDERROR

:RUN
if .%FORCEFONTCHECKSTATUS%.==.1. call kccheckfont -c %LATEXENGINE% %JOBFILENAME%
%LATEXENGINE% -interaction=nonstopmode %JOBFILENAME%
rem echo %errorlevel%
if .%errorlevel%.==.0. goto FIN
if .%errorlevel%.==.1. goto START

:START
%LATEXENGINE% -interaction=nonstopmode %JOBFILENAME% | find "not found" >out
if .%errorlevel%.==.0. goto NOTFOUND
:STARTTWO
%LATEXENGINE% -interaction=nonstopmode %JOBFILENAME% | find "can't find file" >>out
if .%errorlevel%.==.0. goto CANTFIND
goto CALLTHAT

:NOTFOUND
sed "s/\! LaTeX Error\: File `//g" <out >_out
sed "s/' not found\.$//g" <_out >__out
type __out | find "font not found" 
if .%errorlevel%.==.0. goto FONTERROR
type __out | find /v "mktextfm" >____out
sed "s/^/set TMPMISF=/g" <____out >__out.bat
goto STARTTWO

:CANTFIND
type out | find /v "I can't find file"
if .%errorlevel%.==.0. goto FONTERROR
sed "s/\! I can't find file `//g" <out >_out
sed "s/'\.$//g" <_out >__out
type __out | find /v "mktextfm" >____out
sed "s/^/set TMPMISF=/g" <____out >__out.bat
goto CALLTHAT

:CALLTHAT
todos __out.bat >%TEMP%\null
if not exist __out.bat (
goto FIN 
) else (
call __out.bat
)
echo try to install %TMPMISF%

call tlmgr search --global --file %TMPMISF% >tmp
type tmp | find /v "tlmgr" >_tmp
type _tmp | find /v "http" >__tmp
type __tmp | find /v "texmf-dist" >___tmp
type ___tmp | find /v "tlpkg" > ____tmp
type ____tmp | find /v "installed font not found" >_____tmp
type _____tmp | find /v "texmf" >_tmp
type _tmp | find /v "bin/" > __tmp
sed "s/\://g" <__tmp >_tmp
sed "s/^/call tlmgr install /g" <_tmp >_tmp.bat
todos _tmp.bat >%TEMP%\null
type _tmp.bat | find "tlmgr" >%TEMP%\null
if .%errorlevel%.==.1. goto ERROR
call _tmp.bat

if exist out del out _out __out __out.bat ___out ____out
if exist tmp del tmp _tmp __tmp ___tmp ____tmp _tmp.bat _____tmp

goto RUN

:ERROR
echo cannot install %TMPMISF%
echo perhaps no package %TMPMISF% in TeX Live
goto FIN

:SEDERROR
echo there is no 'sed'.
echo I'll quit.
goto FIN

:FONTERROR
echo.
echo font uninstalled error occurred.
echo I'll quit.
goto FIN

:HELPSCREEN
echo %0, Batch version emulating texliveonfly
echo  (c) Karnes 2012
echo Usage: %0 [-f] [-c compiler] filename
echo.       -f: force missing fonts check first
echo        -c: latex compiler
goto FIN

:FIN
rem clear all temporary files
if exist out del out _out __out __out.bat ___out ____out
if exist tmp del tmp _tmp __tmp ___tmp ____tmp _tmp.bat _____tmp

set TMPMISF=
set LATEXENGINE=
set JOBFILENAME=
set FORCEFONTCHECKSTATUS=