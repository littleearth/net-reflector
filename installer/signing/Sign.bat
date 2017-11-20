@echo off
SET ProgFiles86Root=%ProgramFiles(x86)%
IF NOT "%ProgFiles86Root%"=="" GOTO win64
SET ProgFiles86Root=%ProgramFiles%
:win64

set kSignCMD=%ProgFiles86Root%\kSign\kSignCMD.exe
set PFXPass=PassNet
set PFXCert=%ProgFiles86Root%\kSign\certs\Little Earth Solutions.pfx


echo Signing NetReflector.exe...
"%kSignCMD%" /f "%PFXCert%" /p %PFXPass% "..\..\source\server\bin\win32\release\NetReflector.exe"
echo Signing NetReflectorConfig.exe...
"%kSignCMD%" /f "%PFXCert%" /p %PFXPass% "..\..\source\config\bin\win32\release\NetReflectorConfig.exe"

