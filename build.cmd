@echo off
setlocal

pushd %~dp0

for /f "delims=" %%x in (version) do set IMAGE_VERSION=%%x

docker build --progress plain --build-arg VERSION=%IMAGE_VERSION% -t dcjulian29/openssl:%IMAGE_VERSION% .

if %errorlevel% neq 0 GOTO FINAL

docker tag dcjulian29/openssl:%IMAGE_VERSION% dcjulian29/openssl:latest

:FINAL

goreleaser --snapshot --clean

popd

endlocal
