@echo off
rem Public domain
rem http://unlicense.org/
rem Created by Grigore Stefan <g_stefan@yahoo.com>

call build.config.cmd

echo -^> make %PRODUCT_NAME%

if exist build\ rmdir /Q /S build
if exist release\ rmdir /Q /S release

mkdir build
mkdir release
mkdir release\bin

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

set RELEASE_PATH="release"
if "%1" == "perl" set RELEASE_PATH="release\opt\perl"
if "%1" == "httpd" set RELEASE_PATH="release\opt\httpd"
if "%1" == "llvm" set RELEASE_PATH="release\opt\llvm"
if not exist "%RELEASE_PATH%\" mkdir "%RELEASE_PATH%"
call :cmdX 7z x -aoa -obuild vendor/%2.7z
xcopy /Y /S /E "build\%2\*" %RELEASE_PATH%
rmdir /Q /S build\%2

goto:eof
:extractReleaseDefined

goto extractReleaseBinDefined
:extractReleaseBin
set RELEASE_PATH="release\bin"
if "%1" == "perl" set RELEASE_PATH="release\opt\perl"
if "%1" == "httpd" set RELEASE_PATH="release\opt\httpd"
if "%1" == "llvm" set RELEASE_PATH="release\opt\llvm"
if not exist "%RELEASE_PATH%\" mkdir "%RELEASE_PATH%"
call :cmdX 7z x -aoa -obuild vendor/%2.7z
xcopy /Y /S /E "build\%2\*" %RELEASE_PATH%
rmdir /Q /S build\%2

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

rmdir /Q /S build

copy /Y /B source\license.txt release\license.txt
copy /Y /B source\xyo.ico release\xyo.ico
