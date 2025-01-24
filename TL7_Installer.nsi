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

