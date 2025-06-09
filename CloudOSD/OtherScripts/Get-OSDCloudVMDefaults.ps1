 Get-OSDCloudVMDefaults

Set-OSDCloudVMSettings -Generation 2 -MemoryStartupGB 6 -NamePrefix VM -ProcessorCount 2 -SwitchName External -VHDSizeGB 64 -CheckpointVM $true -StartVM $false

New-OSDCloudVM -Generation 2 -MemoryStartupGB 6 -NamePrefix VM -ProcessorCount 2 -SwitchName External -VHDSizeGB 64 -CheckpointVM $true -StartVM $false 
