@echo off
setlocal

pushd %~dp0

for /f "delims=" %%x in (version) do set VERSION=%%x

docker build --build-arg VERSION=%VERSION% -t dcjulian29/openssl:%VERSION% .

if %errorlevel% neq 0 GOTO FINAL

docker tag dcjulian29/openssl:%VERSION% dcjulian29/openssl:latest

:FINAL

goreleaser --snapshot --clean

popd

endlocal
