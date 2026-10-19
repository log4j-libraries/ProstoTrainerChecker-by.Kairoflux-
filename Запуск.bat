@echo off
setlocal EnableExtensions
title ProstoTrainer Checker
cd /d "%~dp0"
set "PTC_SELF=%~f0"

rem Портативный запускчик: рядом лежит папка runtime (своя Java), поэтому программу
rem можно носить на флешке и запускать без установленного JDK.
rem Права администратора нужны для USN-журнала, кустов реестра и корзины.
net session >nul 2>&1
if errorlevel 1 (
    echo Запрашиваю права администратора - нажми "Да" в окне UAC...
    powershell -NoProfile -Command "Start-Process -FilePath $env:PTC_SELF -Verb RunAs"
    exit /b
)

set "JAVA=%~dp0runtime\bin\javaw.exe"
if not exist "%JAVA%" set "JAVA=%~dp0runtime\bin\java.exe"
if not exist "%JAVA%" (
    where javaw >nul 2>&1
    if errorlevel 1 (
        echo Не найден runtime\bin\javaw.exe, и в системе Java не установлена.
        echo Скопируй папку целиком вместе с runtime\ или поставь Java 21+.
        pause
        exit /b 1
    )
    set "JAVA=javaw"
)

rem Если бросить на этот bat подозрительный jar - он откроется только на просмотр (Т12),
rem сам файл НЕ исполняется.
if "%~1"=="" (
    start "" "%JAVA%" --enable-native-access=ALL-UNNAMED -Dfile.encoding=UTF-8 -Dstdout.encoding=UTF-8 -Xmx3g -jar "%~dp0ProstoTrainerChecker.jar"
) else (
    start "" "%JAVA%" --enable-native-access=ALL-UNNAMED -Dfile.encoding=UTF-8 -Dstdout.encoding=UTF-8 -Xmx3g -jar "%~dp0ProstoTrainerChecker.jar" --open="%~1"
)
exit /b 0
