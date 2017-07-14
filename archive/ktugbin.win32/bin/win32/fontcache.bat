@echo off
rem for x86
if ."%ProgramFiles(x86)%".==."". (
set MyProgFiles=%PROGRAMFILES%
) else (
set MyProgFiles="%ProgramFiles(x86)%"
)

xelatex --version >%TEMP%\null
if .%ERRORLEVEL%.==.0. goto GOOD
goto ERROR

:GOOD
rem pushd %TEMP%
rem if exist fonts.conf.pre del fonts.conf.pre
rem if exist fonts.conf.post del fonts.conf.post
rem copy /Y "%USERPROFILE%\.texlive2013\fonts.conf.pre" . >%TEMP%\null
rem copy /Y "%USERPROFILE%\.texlive2013\fonts.conf.post" . >%TEMP%\null

rem kpsewhich --var-value=TEXMFROOT >_tmp
rem sed "s/^/set TMPTLDIR=/g" <_tmp >__tmp.bat
rem sed "s/^/set BSTMPTLDIR=/g" <_tmp >___tmp
rem sed "s/\//\\/g" <___tmp >___tmp.bat
rem todos __tmp.bat >%TEMP%\null
rem todos ___tmp.bat >%TEMP%\null
rem call __tmp.bat
rem call ___tmp.bat
rem del _tmp __tmp ___tmp __tmp.bat ___tmp.bat

rem if .%BSTMPTLDIR%.==.. goto ERROR

rem Check Adobe OpenType
rem set ADOBEFONTSTATUS=0

rem Check texmf-local folder
rem pushd %BSTMPTLDIR%\..\texmf-local
rem if not exist fonts md fonts
rem cd fonts
rem if not exist opentype md opentype
rem popd

rem pushd %BSTMPTLDIR%\..\texmf-local\fonts\opentype
rem if exist MinionPro-Regular.otf (
rem  set ADOBEFONTSTATUS=1
rem ) else (
rem  set ADOBEFONTSTATUS=0
rem )
rem popd
rem if .%ADOBEFONTSTATUS%.==.0. goto ADOBEFONTROUT
rem goto ADOBEFONTROUTEND
rem :ADOBEFONTROUT
rem Adobe Reader 9.0 or 10.0
rem pushd %MyProgFiles%
rem if exist Adobe goto GETFNT
rem :ReturnHere
rem goto Recess
rem :GETFNT
rem cd Adobe
rem if exist "Reader 11.0" goto GETTEN
rem if exist "Reader 10.0" goto GETNINE
rem if exist "Reader 9.0" goto GETEIGHT
rem goto ReturnHere
rem :GETTEN
rem cd Reader 11.0
rem cd Resource\CIDFont
rem if exist AdobeMyungjoStd-Medium.otf (
rem   copy /Y *.otf %BSTMPTLDIR%\..\texmf-local\fonts\opentype\
rem   set ADOBEOKSTATUS=10
rem )
rem cd ..\Font
rem if exist AdobePiStd.otf (
rem   copy /Y AdobePiStd.otf %BSTMPTLDIR%\..\texmf-local\fonts\opentype\
rem   copy /Y Minion*.otf %BSTMPTLDIR%\..\texmf-local\fonts\opentype\
rem   copy /Y Myriad*.otf %BSTMPTLDIR%\..\texmf-local\fonts\opentype\
rem   set ADOBEOKSTATUS=10
rem )
rem goto ReturnHere
rem :GETNINE
rem cd Reader 10.0
rem cd Resource\CIDFont
rem if exist AdobeMyungjoStd-Medium.otf (
rem   copy /Y *.otf %BSTMPTLDIR%\..\texmf-local\fonts\opentype\
rem   set ADOBEOKSTATUS=9
rem )
rem cd ..\Font
rem if exist AdobePiStd.otf (
rem   copy /Y AdobePiStd.otf %BSTMPTLDIR%\..\texmf-local\fonts\opentype\
rem   copy /Y Minion*.otf %BSTMPTLDIR%\..\texmf-local\fonts\opentype\
rem   copy /Y Myriad*.otf %BSTMPTLDIR%\..\texmf-local\fonts\opentype\
rem   set ADOBEOKSTATUS=9
rem )
rem goto ReturnHere
rem :GETEIGHT
rem cd Reader 9.0
rem cd Resource\CIDFont
rem if exist AdobeMyungjoStd-Medium.otf (
rem   copy /Y *.otf %BSTMPTLDIR%\..\texmf-local\fonts\opentype\
rem   set ADOBEOKSTATUS=8
rem )
rem cd ..\Font
rem if exist AdobePiStd.otf (
rem   copy /Y AdobePiStd.otf %BSTMPTLDIR%\..\texmf-local\fonts\opentype\
rem   copy /Y Minion*.otf %BSTMPTLDIR%\..\texmf-local\fonts\opentype\
rem   copy /Y Myriad*.otf %BSTMPTLDIR%\..\texmf-local\fonts\opentype\
rem   set ADOBEOKSTATUS=8
rem )
rem goto ReturnHere

rem :Recess
rem popd
rem :ADOBEFONTROUTEND
rem if .%ADOBEFONTSTATUS%.==.1. echo Adobe Reader Fonts are already installed.

rem generate fonts.conf
rem type fonts.conf.pre >05-kotex-live.conf
rem echo "<dir>%TMPTLDIR%/../texmf-local/fonts/opentype</dir>" >>05-kotex-live.conf
rem echo "<dir>%TMPTLDIR%/../texmf-local/fonts/truetype</dir>" >>05-kotex-live.conf
rem type fonts.conf.post >>05-kotex-live.conf
rem copy fonts.conf to conf dir
rem copy /Y 05-kotex-live.conf "%BSTMPTLDIR%\texmf-var\fonts\conf\conf.d\" >%TEMP%\null

rem run fc-cache
fc-cache -v
goto END

:ERROR
echo.
echo Sorry, something's wrong. I'll quit.
echo.
pause
goto END

:END
rem popd

