#qt  
[[Qt]]

0. Установить NSIS
1. Подготовить файлы  ==build_installer.bat==
```bat
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

```

и ==TL7_Installer.nsi==
```text
!define PRODUCT_NAME "TL7"
!define PRODUCT_VERSION "1.0"
!define PRODUCT_PUBLISHER "YourCompany"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define INSTALL_DIR "$PROGRAMFILES\TL7"

OutFile "TL7Installer.exe"
InstallDir "${INSTALL_DIR}"

# Начало секции установки
Section "Install"

  # Создаем директорию для установки
  SetOutPath "$INSTDIR"

  # Копируем файлы приложения
  File /r "C:\Project\ProjectQt\UprQT_TL7\build-TL7-Desktop_Qt_5_12_4_MinGW_64_bit-Release\release\*.*"

  # Создаем ярлыки
  CreateShortcut "$DESKTOP\TL7.lnk" "$INSTDIR\TL7.exe"
  CreateShortcut "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall.lnk" "$INSTDIR\uninstall.exe"

  # Сохраняем информацию в реестре
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "DisplayName" "${PRODUCT_NAME} ${PRODUCT_VERSION}"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "UninstallString" "$INSTDIR\uninstall.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "Publisher" "${PRODUCT_PUBLISHER}"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "InstallLocation" "$INSTDIR"

  # Создаем uninstall.exe
  WriteUninstaller "$INSTDIR\uninstall.exe"

SectionEnd

# Секция удаления
Section "Uninstall"

  # Удаляем установленные файлы
  Delete "$INSTDIR\*.*"
  Delete "$DESKTOP\TL7.lnk"
  Delete "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall.lnk"

  # Удаляем директорию
  RMDir "$INSTDIR"

  # Удаляем записи из реестра
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"

SectionEnd
```

1. Сборка проекта
Перед деплоем нужно собрать приложение в Release-режиме (релизной сборке). 
Это можно сделать в **Qt Creator**:

Откройте проект в Qt Creator.
Переключитесь на профиль **Release.**
Соберите проект Сборка (Build), нажав Ctrl + B или выбрав опцию Сборка проекта (Build).
Собранный исполняемый файл будет находиться в директории release вашего проекта 
(например, **project/release/**).

2. На основе содержимого файлов реализован следующий алгоритм для сборки проекта на Qt с использованием NSIS и windeployqt.


- **Подготовка окружения**
- Убедитесь, что установлены:
    - Qt с корректной версией компилятора (например, MinGW или MSVC).
    - NSIS для создания установочных файлов.
- Убедитесь, что пути в вашем `build_installer.bat` указаны верно:
    - `QTDIR` — путь к вашей установке Qt.
    - `NSISDIR` — путь к установке NSIS.
    - `PROJECT_DIR` — путь к вашему проекту Qt.
    - `BUILD_DIR` и `RELEASE_DIR` корректно ссылаются на директорию сборки.
- ### **Сборка проекта**
В файле `build_installer.bat`:
- Запускается сборка проекта:
```
%QTDIR%\bin\qmake -config release
nmake clean
nmake
```
-  **Копирование зависимостей с помощью windeployqt**
   Утилита `windeployqt` копирует необходимые для работы вашего приложения библиотеки Qt в папку `release`.

- **Создание установщика через NSIS**
 Файл `TL7_Installer.nsi` определяет параметры установки:
- Копирование всех файлов из папки `release` в директорию установки.
- Создание ярлыков.
- Запись информации в реестр.
- Создание файла для удаления программы.

- **Алгоритм действий**
     - Проверьте правильность путей в `build_installer.bat` и `TL7_Installer.nsi`.
     - Выполните `build_installer.bat`:
             - Этот файл:
              1. Скомпилирует ваш проект.
              2. Скопирует все зависимости с помощью `windeployqt`.
              3. Создаст инсталлятор через NSIS.
              4. После успешного выполнения скрипта должен появиться файл `TL7Installer.exe`, готовый к распространению.

- **Дополнительные замечания**

- Если в  проекте используются плагины Qt (например, `QtQuick` или `QML`), убедитесь, что `windeployqt` добавил их в папку `release`.
- Перед запуском `build_installer.bat` можно проверить сборку вручную:
    - Выполнить `qmake` и `nmake`.
    - Убедиться, что в папке `release` находится `TL7.exe`.
    - Запустить приложение и проверить его работу.