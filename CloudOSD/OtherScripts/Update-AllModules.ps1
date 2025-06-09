# TLS 1.2 aktivieren für PSGallery-Verbindung
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Logdatei-Pfad definieren
$logPath = "C:\ProgramData\KSB\Logs\Update-PSModules.log"
New-Item -ItemType File -Path $logPath -Force | Out-Null

# Logging-Funktion
function Write-Log {
    param ([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $logPath -Value "$timestamp`t$Message"
}

Write-Log "== Modulupdate gestartet =="

# Alle installierten Module auflisten
$installedModules = Get-InstalledModule -ErrorAction SilentlyContinue

foreach ($module in $installedModules) {
    $moduleName = $module.Name
    $oldVersion = $module.Version.ToString()

    Write-Log "Modul '$moduleName' wird verarbeitet"

    try {
        # Entladen, falls aktiv
        if (Get-Module -Name $moduleName) {
            Write-Log "Modul '$moduleName' ist aktuell geladen – wird entladen"
            Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue
        }

        Write-Log "Installierte Version von '$moduleName': $oldVersion"

        # Modul aktualisieren
        Update-Module -Name $moduleName -Force -ErrorAction Stop

        # Neue Version ermitteln nach Update
        $updatedModule = Get-InstalledModule -Name $moduleName -AllVersions |
                         Sort-Object Version -Descending |
                         Select-Object -First 1
        $newVersion = $updatedModule.Version.ToString()

        Write-Log "Neue Version von '$moduleName': $newVersion"

        # Ältere Versionen löschen
        $allVersions = Get-InstalledModule -Name $moduleName -AllVersions
        foreach ($ver in $allVersions) {
            if ($ver.Version -ne $newVersion) {
                Write-Log "Entferne alte Version: $($ver.Version) von '$moduleName'"
                Uninstall-Module -Name $moduleName -RequiredVersion $ver.Version -Force -ErrorAction Stop
            }
        }

        Write-Log "Modul '$moduleName' Update abgeschlossen"

    } catch {
        Write-Log "Fehler bei Modul '$moduleName': $_"
    }
}

Write-Log "== Modulupdate abgeschlossen =="