@echo off
SET top=%~dp0
%top%pharo-vm/Pharo.exe wbt.image --interactive wbt %*
