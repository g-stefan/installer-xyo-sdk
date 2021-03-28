@echo off
rem Public domain
rem http://unlicense.org/
rem Created by Grigore Stefan <g_stefan@yahoo.com>

call build\build.config.cmd

echo -^> make %PRODUCT_NAME%

if exist temp\ rmdir /Q /S temp
if exist output\ rmdir /Q /S output

mkdir temp
mkdir output
mkdir output\bin

goto cmdXDefined
:cmdX
%*
if errorlevel 1 goto cmdXError
goto :eof
:cmdXError
echo "Error: %ACTION%"
exit 1
:cmdXDefined

goto extractReleaseDefined
:extractRelease

set RELEASE_PATH="output"
if "%1" == "perl" set RELEASE_PATH="output\opt\perl"
if "%1" == "httpd" set RELEASE_PATH="output\opt\httpd"
if "%1" == "llvm" set RELEASE_PATH="output\opt\llvm"
if "%1" == "llvm" goto:eof
if not exist "%RELEASE_PATH%\" mkdir "%RELEASE_PATH%"
call :cmdX 7z x -aoa -otemp vendor/%2.7z
xcopy /Y /S /E "temp\%2\*" %RELEASE_PATH%
rmdir /Q /S temp\%2

goto:eof
:extractReleaseDefined

goto extractReleaseBinDefined
:extractReleaseBin
set RELEASE_PATH="output\bin"
if "%1" == "perl" set RELEASE_PATH="output\opt\perl"
if "%1" == "httpd" set RELEASE_PATH="output\opt\httpd"
if "%1" == "llvm" set RELEASE_PATH="output\opt\llvm"
if "%1" == "llvm" goto:eof
if not exist "%RELEASE_PATH%\" mkdir "%RELEASE_PATH%"
call :cmdX 7z x -aoa -otemp vendor/%2.7z
xcopy /Y /S /E "temp\%2\*" %RELEASE_PATH%
rmdir /Q /S temp\%2

goto:eof
:extractReleaseBinDefined

goto prepareReleaseDefined
:prepareRelease

if "%1"=="" goto:eof
if "%2"=="" goto:eof
echo %1-%2

SET PROJECT=%1
SET PROJECT_VENDOR=%PROJECT:vendor-=%
if exist vendor\%1-%2-win64-msvc-2019-dev.7z call :extractRelease %1 %1-%2-win64-msvc-2019-dev && goto:eof
if exist vendor\%1-%2-win64-msvc-2019.7z call :extractReleaseBin %1 %1-%2-win64-msvc-2019 && goto:eof
if "%PROJECT_VENDOR%"=="%1" goto:eof
if exist vendor\%PROJECT_VENDOR%-%2-win64-msvc-2019-dev.7z call :extractRelease %PROJECT_VENDOR% %PROJECT_VENDOR%-%2-win64-msvc-2019-dev && goto:eof
if exist vendor\%PROJECT_VENDOR%-%2-win64-msvc-2019.7z call :extractReleaseBin %PROJECT_VENDOR% %PROJECT_VENDOR%-%2-win64-msvc-2019 && goto:eof

goto:eof
:prepareReleaseDefined

set PROJECT=xyo-sdk-%PRODUCT_VERSION%.csv
echo %PROJECT%
if not exist vendor\%PROJECT% curl --insecure --location https://github.com/g-stefan/xyo-sdk/releases/download/v%PRODUCT_VERSION%/%PROJECT% --output vendor\%PROJECT%

for /F "eol=# delims=, tokens=1,2" %%i in (vendor\%PROJECT%) do call :prepareRelease %%i %%j

rmdir /Q /S temp

copy /Y /B source\xyo-sdk.license.txt output\license.txt
copy /Y /B source\xyo.ico output\xyo.ico
