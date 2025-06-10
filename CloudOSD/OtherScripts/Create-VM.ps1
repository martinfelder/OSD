# Command: .\Create-VM.ps1 -AnzahlVMs 15 -VMNamePrefix VM -StartIndex 13 -RAMInMB 8 -VHDPath 'G:\Hyper-V' -VHDSizeInGB 120 -VMCPUCount 4 -SwitchName 'External' -ISOFilePath "D:\OSDCloud\OSDCloud.iso"
# Skript zum Erstellen von Hyper-V-VMs mit anpassbaren Einstellungen
param (
    [Parameter(Mandatory=$true)]
    [int]$AnzahlVMs,  # Anzahl der zu erstellenden VMs

    [Parameter(Mandatory=$true)]
    [string]$VMNamePrefix,  # Präfix für den VM-Namen

    [Parameter(Mandatory=$true)]
    [int]$StartIndex,  # Startindex für den Hostnamen

    [Parameter(Mandatory=$true)]
    [int]$RAMInMB,  # RAM in MB

    [Parameter(Mandatory=$true)]
    [string]$VHDPath,  # Pfad zum Speichern der virtuellen Festplatten

    [Parameter(Mandatory=$true)]
    [int]$VHDSizeInGB,  # Größe der virtuellen Festplatte in GB

    [Parameter(Mandatory=$true)]
    [int]$VMCPUCount,  # Anzahl der virtuellen CPU Cores

    [Parameter(Mandatory=$true)]
    [string]$SwitchName,  # Name des virtuellen Switches

    [Parameter(Mandatory=$true)]
    [string]$ISOFilePath  # Pfad zur ISO-Datei
)

# Schleife zum Erstellen der VMs
for ($i = $StartIndex; $i -le ($StartIndex + $AnzahlVMs - 1); $i++) {
    $VMName = "$VMNamePrefix" + "00$i"
    New-VM -Name $VMName -BootDevice VHD -NewVHDPath "$VHDPath\$VMName\$VMName.vhdx" -Path "$VHDPath\$VMName" -NewVHDSizeBytes ($VHDSizeInGB * 1GB) -Generation 2 -SwitchName $SwitchName
    Set-VM -VMName $VMName -ProcessorCount $VMCPUCount -AutomaticCheckpointsEnabled $false -CheckpointType Disabled
    Set-VMMemory -VMName $VMName -StartupBytes ($RAMInMB * 1GB) -MinimumBytes 512MB -MaximumBytes 1048576MB -DynamicMemoryEnabled $true
    Set-VMSecurity -VMName $VMName -VirtualizationBasedSecurityOptOut $false
    Set-VMKeyProtector -VMName $VMName -NewLocalKeyProtector
    Enable-VMTPM -VMName $VMName
    Add-VMDvdDrive -VMName $VMName -ControllerNumber 0 -ControllerLocation 1
    Set-VMDvdDrive -VMName $VMName -Path $ISOFilePath
    $bootorder = (Get-VMFirmware -VMName $VMName).BootOrder
    Set-VMFirmware -VMName $VMName -BootOrder $bootorder[2],$bootorder[0],$bootorder[1]
    Enable-VMIntegrationService -VMName $VMName -Name "Guest Service Interface" 
    Write-Host "VM '$VMName' wurde erfolgreich erstellt."
}
