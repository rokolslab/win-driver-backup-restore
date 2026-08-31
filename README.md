[English](README.md) | [Русский](README.ru.md)

# win-driver-backup-restore

> Minimal PowerShell utility for backing up and restoring Windows 11 drivers with built-in Windows tools.

This open-source repository provides two ready-to-use scripts: one exports installed drivers before a Windows reinstall, and the other restores them after the system is installed again.

Author: `RokolsLab`

## Who It Is For

- Windows 11 users preparing for a clean reinstall.
- Anyone who wants to preserve installed drivers without third-party software.
- Anyone who needs a simple driver restore workflow after reinstalling Windows.

## What It Does

- Exports third-party drivers with `Export-WindowsDriver`.
- Stores them in `C:\DriverBackups\<COMPUTERNAME>\<timestamp>\drivers`.
- Saves metadata into a `meta` folder.
- Restores drivers from a specific `drivers` folder through `pnputil`.

## Download Scripts

- `https://raw.githubusercontent.com/RokolsLab/win-driver-backup-restore/main/scripts/backup-drivers.ps1`
- `https://raw.githubusercontent.com/RokolsLab/win-driver-backup-restore/main/scripts/restore-drivers.ps1`

If you publish a fork under another account, replace `RokolsLab` with your GitHub username.

```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/RokolsLab/win-driver-backup-restore/main/scripts/backup-drivers.ps1" -OutFile ".\backup-drivers.ps1"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/RokolsLab/win-driver-backup-restore/main/scripts/restore-drivers.ps1" -OutFile ".\restore-drivers.ps1"
```

After download, you may need to unblock the files:

```powershell
Unblock-File .\backup-drivers.ps1
Unblock-File .\restore-drivers.ps1
```

## Quick Start

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
.\backup-drivers.ps1
.\restore-drivers.ps1 -DriversRoot "C:\DriverBackups\HOSTNAME\YYYY-MM-DD_HH-mm\drivers"
```

Run the scripts from an elevated PowerShell session.

## Default Backup Location

```text
C:\DriverBackups\<COMPUTERNAME>\<timestamp>\
```

## Restore

`restore-drivers.ps1` uses the built-in Windows utility `pnputil` to install drivers from the selected `drivers` folder.

## Limitations

- Only third-party drivers are exported.
- This does not replace a full system image.
- GPU and chipset drivers are sometimes better installed fresh from the vendor website.
- Old drivers may not work after major hardware changes.

## Security

- Run the scripts as administrator.
- Read `.ps1` files before running them.
- Do not run scripts from untrusted sources.

## Documentation

| Guide | Description |
|-------|-------------|
| [Execution Policy](docs/en/execution-policy.md) | How to allow PowerShell scripts safely |

## License

MIT. See [`LICENSE`](LICENSE).
