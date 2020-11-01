@echo off
rem Public domain
rem http://unlicense.org/
rem Created by Grigore Stefan <g_stefan@yahoo.com>

echo -^> vendor xyo-sdk

call build.config.cmd

setlocal

if not exist vendor\ mkdir vendor

goto getSizeDefined
:getSize
set FILE_SIZE=%~z1
goto:eof
:getSizeDefined

goto downloadDefined
:download
if "%1"=="" goto:eof
if "%2"=="" goto:eof
echo %1-%2

SET PROJECT=%1
SET PROJECT_VENDOR=%PROJECT:vendor-=%
if exist vendor\%1-%2-win64-msvc-2019-dev.7z goto:eof
if exist vendor\%1-%2-win64-msvc-2019.7z goto:eof
if exist vendor\%PROJECT_VENDOR%-%2-win64-msvc-2019-dev.7z goto:eof
if exist vendor\%PROJECT_VENDOR%-%2-win64-msvc-2019.7z goto:eof

curl --insecure --location https://github.com/g-stefan/%1/releases/download/v%2/%1-%2-win64-msvc-2019-dev.7z --output vendor\%1-%2-win64-msvc-2019-dev.7z
call :getSize "vendor\%1-%2-win64-msvc-2019-dev.7z"
if %FILE_SIZE% GTR 16 goto:eof
del /F /Q vendor\%1-%2-win64-msvc-2019-dev.7z
curl --insecure --location https://github.com/g-stefan/%1/releases/download/v%2/%1-%2-win64-msvc-2019.7z --output vendor\%1-%2-win64-msvc-2019.7z
call :getSize "vendor\%1-%2-win64-msvc-2019.7z"
if %FILE_SIZE% GTR 16 goto:eof
del /F /Q vendor\%1-%2-win64-msvc-2019.7z

if "%PROJECT_VENDOR%"=="%1" goto downloadError

curl --insecure --location https://github.com/g-stefan/%1/releases/download/v%2/%PROJECT_VENDOR%-%2-win64-msvc-2019-dev.7z --output vendor\%PROJECT_VENDOR%-%2-win64-msvc-2019-dev.7z
call :getSize "vendor\%PROJECT_VENDOR%-%2-win64-msvc-2019-dev.7z"
if %FILE_SIZE% GTR 16 goto:eof
del /F /Q vendor\%PROJECT_VENDOR%-%2-win64-msvc-2019-dev.7z
curl --insecure --location https://github.com/g-stefan/%1/releases/download/v%2/%PROJECT_VENDOR%-%2-win64-msvc-2019.7z --output vendor\%PROJECT_VENDOR%-%2-win64-msvc-2019.7z
call :getSize "vendor\%PROJECT_VENDOR%-%2-win64-msvc-2019.7z"
if %FILE_SIZE% GTR 16 goto:eof
del /F /Q vendor\%PROJECT_VENDOR%-%2-win64-msvc-2019.7z

:downloadError
echo Error: %1-%2-win64-msvc-2019 not found!
exit 1
:downloadDefined

set PROJECT=xyo-sdk-%PRODUCT_VERSION%.csv
echo %PROJECT%
if not exist vendor\%PROJECT% curl --insecure --location https://github.com/g-stefan/xyo-sdk/releases/download/v%PRODUCT_VERSION%/%PROJECT% --output vendor\%PROJECT%

for /F "eol=# delims=, tokens=1,2" %%i in (vendor\%PROJECT%) do call :download %%i %%j
