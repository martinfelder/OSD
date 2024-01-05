# Set Workshpace Folder
$WorkingDir = "D:\OSDCloud"
New-Item -ItemType Directory $WorkingDir -Force
Set-OSDCloudWorkspace -WorkspacePath $WorkingDir

#Create OSD Cloud Template en-us with Swiss Inpute locale
New-OSDCloudTemplate -SetInputLocale de-CH -Name 'Template EN-US - InputLocal de-CH' -WinRE -Verbose

$Startnet = @'
start /wait PowerShell -NoL -C Install-Module OSD -Force -Verbose
start /wait PowerShell -NoL -C Start-OSDCloud -OSVersion 'Windows 11' -OSBuild 23H2 -OSEdition Pro -OSLanguage en-us -OSLicense Retail
'@
Edit-OSDCloudWinPE -Startnet $Startnet -StartOSDCloudGUI -Brand 'OSD by Martin' -Wallpaper "D:\OneDrivePrivat\OneDrive\_b41d5361-7e1f-4abd-823e-c5f43da6e67c.jpg" -CloudDriver * -DriverPath "D:\OneDrivePrivat\OneDrive\Drivers"

Edit-OSDCloudWinPE -CloudDriver * -StartOSDCloud "-OSVersion 'Windows 11' -OSBuild 23H2 -OSEdition Pro -OSLanguage en-us -OSLicense Retail" -UpdateUSB -Wallpaper "D:\OneDrivePrivat\OneDrive\_b41d5361-7e1f-4abd-823e-c5f43da6e67c.jpg" -Brand "MFLAB OSDCloud" -DriverPath "D:\OneDrivePrivat\OneDrive\Drivers"

Edit-OSDCloudWinPE -startosdpad "-RepoOwner martinfelder -RepoName OSD -RepoFolder CloudOSD -BrandingTitle 'MFLAB OSD Cloud Deployment' -Hide Script"
