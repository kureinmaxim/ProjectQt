@echo off

REM Укажите пути
set QTDIR=C:\Qt\Qt5.12.4\5.12.4\msvc2017_64
set NSISDIR=C:\Program Files (x86)\NSIS
set PROJECT_DIR=C:\Project\ProjectQt\UprQT_TL7
set BUILD_DIR=%PROJECT_DIR%\build-TL7-Desktop_Qt_5_12_4_MinGW_64_bit-Release
set RELEASE_DIR=%BUILD_DIR%\release

REM Переход в директорию проекта
cd %PROJECT_DIR%

REM Сборка проекта через qmake
echo Building project...
%QTDIR%\bin\qmake -config release
nmake clean
nmake

REM Копирование зависимостей через windeployqt
echo Deploying Qt dependencies...
%QTDIR%\bin\windeployqt %RELEASE_DIR%\TL7.exe

REM Проверка содержимого папки release
echo Checking release directory...
dir %RELEASE_DIR%
if not exist "%RELEASE_DIR%\TL7.exe" (
    echo Error: TL7.exe not found in release directory!
    pause
    exit /b 1
)

REM Создание инсталлятора через NSIS
echo Creating installer...
"%NSISDIR%\makensis.exe" %PROJECT_DIR%\TL7_Installer.nsi

echo Installation build completed!
pause
