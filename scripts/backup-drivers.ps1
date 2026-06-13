#Requires -RunAsAdministrator
<#
Запуск:
.\backup-drivers.ps1

По умолчанию драйверы сохраняются в:
C:\DriverBackups\<COMPUTERNAME>\<yyyy-MM-dd_HH-mm>\drivers

Что создаётся:
drivers\              - экспортированные драйверы
meta\devices.csv      - список PnP-устройств
meta\drivers_versions.csv
meta\system.json
meta\hashes.csv
#>

$ErrorActionPreference = 'Stop'

# ===== CONFIG =====
$baseDir = 'C:\DriverBackups'
$timestamp = Get-Date -Format 'yyyy-MM-dd_HH-mm'
$computerName = $env:COMPUTERNAME

if ([string]::IsNullOrWhiteSpace($computerName)) {
    throw 'Не удалось определить имя компьютера через переменную окружения COMPUTERNAME.'
}

$backupDir = Join-Path -Path $baseDir -ChildPath "$computerName\$timestamp"
$driversDir = Join-Path -Path $backupDir -ChildPath 'drivers'
$metaDir = Join-Path -Path $backupDir -ChildPath 'meta'

Write-Host "Создаю папки резервной копии в: $backupDir"
New-Item -ItemType Directory -Path $driversDir -Force | Out-Null
New-Item -ItemType Directory -Path $metaDir -Force | Out-Null

# ===== EXPORT DRIVERS =====
Write-Host 'Exporting drivers...'
Export-WindowsDriver -Online -Destination $driversDir | Out-Null

# ===== DEVICE INVENTORY =====
Write-Host 'Collecting device list...'
Get-PnpDevice |
    Sort-Object Class, FriendlyName |
    Select-Object Status, Class, FriendlyName, InstanceId |
    Export-Csv -Path (Join-Path $metaDir 'devices.csv') -NoTypeInformation -Encoding UTF8

# ===== DRIVER DETAILS =====
Write-Host 'Collecting driver versions...'
Get-CimInstance -ClassName Win32_PnPSignedDriver |
    Select-Object DeviceName, DriverVersion, Manufacturer, DriverDate, InfName, DriverProviderName |
    Export-Csv -Path (Join-Path $metaDir 'drivers_versions.csv') -NoTypeInformation -Encoding UTF8

# ===== SYSTEM INFO =====
Write-Host 'Collecting system info...'
Get-ComputerInfo |
    Select-Object WindowsProductName, WindowsVersion, OsBuildNumber, CsManufacturer, CsModel |
    ConvertTo-Json -Depth 3 |
    Set-Content -Path (Join-Path $metaDir 'system.json') -Encoding UTF8

# ===== HASHES =====
Write-Host 'Generating hashes...'
Get-ChildItem -Path $driversDir -Recurse -File |
    Get-FileHash -Algorithm SHA256 |
    Export-Csv -Path (Join-Path $metaDir 'hashes.csv') -NoTypeInformation -Encoding UTF8

# ===== DONE =====
Write-Host "Backup completed: $backupDir"
