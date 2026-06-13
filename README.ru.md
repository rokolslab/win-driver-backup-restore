[English](README.md) | [Русский](README.ru.md)

# win-driver-backup-restore

> Минимальная PowerShell-утилита для резервного копирования и восстановления драйверов Windows 11 штатными средствами Windows.

Небольшой open-source репозиторий с двумя скриптами: один сохраняет установленные драйверы перед переустановкой Windows, второй помогает восстановить их после установки системы.

Автор: `RoKols`

## Для кого это

- Для пользователей Windows 11 перед переустановкой системы.
- Для тех, кто хочет сохранить установленные драйверы без сторонних программ.
- Для случаев, когда нужно быстро вернуть драйверы после чистой установки Windows.

## Что делает

- Экспортирует сторонние драйверы через `Export-WindowsDriver`.
- Сохраняет их по пути `C:\DriverBackups\<COMPUTERNAME>\<timestamp>\drivers`.
- Сохраняет метаданные в папку `meta`.
- Восстанавливает драйверы из конкретной папки `drivers` через `pnputil`.

## Скачать скрипты

- `https://raw.githubusercontent.com/RoKols2017/win-driver-backup-restore/main/scripts/backup-drivers.ps1`
- `https://raw.githubusercontent.com/RoKols2017/win-driver-backup-restore/main/scripts/restore-drivers.ps1`

Если вы публикуете fork в другом аккаунте, замените `RoKols2017` на имя своего GitHub-аккаунта.

```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/RoKols2017/win-driver-backup-restore/main/scripts/backup-drivers.ps1" -OutFile ".\backup-drivers.ps1"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/RoKols2017/win-driver-backup-restore/main/scripts/restore-drivers.ps1" -OutFile ".\restore-drivers.ps1"
```

После скачивания может понадобиться:

```powershell
Unblock-File .\backup-drivers.ps1
Unblock-File .\restore-drivers.ps1
```

## Быстрый старт

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
.\backup-drivers.ps1
.\restore-drivers.ps1 -DriversRoot "C:\DriverBackups\HOSTNAME\YYYY-MM-DD_HH-mm\drivers"
```

Скрипты нужно запускать из PowerShell от имени администратора.

## Где сохраняются драйверы

```text
C:\DriverBackups\<COMPUTERNAME>\<timestamp>\
```

## Восстановление

`restore-drivers.ps1` использует встроенную утилиту Windows `pnputil` и устанавливает драйверы из указанной папки `drivers`.

## Ограничения

- Экспортируются сторонние драйверы.
- Это не заменяет полноценный образ системы.
- Драйверы GPU и chipset иногда лучше ставить свежими с сайта производителя.
- Старые драйверы могут не подойти после смены железа.

## Безопасность

- Скрипты должны запускаться от администратора.
- Перед запуском стоит прочитать `.ps1`-файлы.
- Не запускайте скрипты из непроверенных источников.

## Документация

| Документ | Описание |
|----------|----------|
| [Execution Policy](docs/ru/execution-policy.md) | Как разрешить запуск PowerShell-скриптов безопасным способом |

## License

MIT. См. файл [`LICENSE`](LICENSE).
