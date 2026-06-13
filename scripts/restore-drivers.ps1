#Requires -RunAsAdministrator
<#
Запуск:
.\restore-drivers.ps1 -DriversRoot "C:\DriverBackups\MYPC\2026-04-13_12-00\drivers"

С авто-перезагрузкой при необходимости:
.\restore-drivers.ps1 -DriversRoot "C:\DriverBackups\MYPC\2026-04-13_12-00\drivers" -AllowReboot
#>

param(
    [Parameter(Mandatory = $false)]
    [string]$DriversRoot = 'C:\DriverBackups\HOSTNAME\YYYY-MM-DD_HH-mm\drivers',

    [switch]$AllowReboot
)

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($DriversRoot)) {
    throw 'Параметр DriversRoot не должен быть пустым.'
}

if ($DriversRoot -like '*HOSTNAME*' -or $DriversRoot -like '*YYYY-MM-DD_HH-mm*') {
    throw 'Укажи фактический путь к папке drivers из своей резервной копии вместо шаблонного значения.'
}

if (-not (Test-Path -LiteralPath $DriversRoot -PathType Container)) {
    throw "Папка не найдена: $DriversRoot"
}

$infFiles = Get-ChildItem -LiteralPath $DriversRoot -Recurse -Filter '*.inf' -File
if (-not $infFiles) {
    throw "В папке нет .inf-файлов: $DriversRoot"
}

$pnputil = Join-Path $env:WINDIR 'System32\pnputil.exe'
if (-not (Test-Path -LiteralPath $pnputil -PathType Leaf)) {
    throw "Не найден pnputil: $pnputil"
}

$logFile = Join-Path $DriversRoot ('restore_' + (Get-Date -Format 'yyyy-MM-dd_HH-mm-ss') + '.log')

$args = @(
    '/add-driver'
    "$DriversRoot\*.inf"
    '/subdirs'
    '/install'
)

if ($AllowReboot) {
    $args += '/reboot'
}

Write-Host "Восстановление драйверов из: $DriversRoot"
Write-Host "Найдено INF-файлов: $($infFiles.Count)"
Write-Host "Лог: $logFile"

& $pnputil @args 2>&1 | Tee-Object -FilePath $logFile

if ($LASTEXITCODE -ne 0) {
    throw "pnputil завершился с кодом $LASTEXITCODE. Смотри лог: $logFile"
}

Write-Host 'Готово. Если часть устройств не поднялась, перезагрузи систему.'
