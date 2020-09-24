@echo off
rem Public domain
rem http://unlicense.org/
rem Created by Grigore Stefan <g_stefan@yahoo.com>

echo -^> installer xyo-sdk

if exist installer\ rmdir /Q /S installer
mkdir installer

if exist build\ rmdir /Q /S build
mkdir build

makensis.exe /NOCD "util\xyo-sdk-installer.nsi"

call grigore-stefan.sign "XYO SDK" "installer\xyo-sdk-3.0.0-installer.exe"

if exist build\ rmdir /Q /S build
