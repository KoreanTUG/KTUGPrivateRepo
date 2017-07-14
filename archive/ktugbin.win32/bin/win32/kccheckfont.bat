@echo off
if .%1.==.. goto USAGE
if .%1.==.-c. goto ARGCHECK
set TEXENGINE=xelatex
set FJOBFILENAME=%1
goto PREPARESTART

:ARGCHECK
set TEXENGINE=%2
set FJOBFILENAME=%3
goto PREPARESTART

:PREPARESTART
if exist missfont.log del missfont.log

:START
%TEXENGINE% --interaction=nonstopmode %FJOBFILENAME% 2>_can
if exist missfont.log (
sed "s/^\(.*\)dpi //g;s/mktextfm //g" <missfont.log >_can
sed "s/^\(.*\) //g" <_can >__can
sed "s/^/set TMPFNT=/g" <__can >_can.bat
todos _can.bat
call _can.bat
goto TRYINST
)

type _can | find "Unable to find TFM"
if .%errorlevel%.==.0. (
type _can | find "Unable to find TFM" >__can
sed "s/^\(.*\)TFM file \"//g;s/\"\.$//g" <__can >___can
sed "s/^/set TMPFNT=/g" <___can >_can.bat
todos _can.bat
if exist _can.bat call _can.bat
goto TRYINST
)

goto END

:TRYINST
if not exist _can.bat goto END
call tlmgr search --global --file %TMPFNT% >tmp
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
if not exist _tmp.bat (
goto END
) else (
call _tmp.bat
)
if exist missfont.log del missfont.log
if exist _tmp.bat del tmp _tmp __tmp ___tmp ____tmp _____tmp _tmp.bat
if exist _can.bat del _can __can ___can ____can __can.bat _can.bat
goto START

:USAGE
echo %0 filename
goto END

:END
if exist tmp del tmp _tmp __tmp ___tmp ____tmp _____tmp _tmp.bat
if exist _can del _can __can ___can ____can __can.bat _can.bat
set TMPFNT=
set TEXENGINE=
set FJOBFILENAME=
