# install-tools.ps1
# Skrypt instalujący PowerShell Core i Azure CLI na Windows

Write-Host "Installing PowerShell Core..."
$pwshInstaller = "https://github.com/PowerShell/PowerShell/releases/download/v7.4.2/PowerShell-7.4.2-win-x64.msi"
$pwshMsi = "$env:TEMP\\PowerShell-7.4.2-win-x64.msi"
Invoke-WebRequest -Uri $pwshInstaller -OutFile $pwshMsi
Start-Process msiexec.exe -Wait -ArgumentList "/I $pwshMsi /quiet /norestart"
Remove-Item $pwshMsi

Write-Host "Installing Azure CLI..."
$azInstaller = "https://aka.ms/installazurecliwindows"
$azMsi = "$env:TEMP\\AzureCLI.msi"
Invoke-WebRequest -Uri $azInstaller -OutFile $azMsi
Start-Process msiexec.exe -Wait -ArgumentList "/I $azMsi /quiet /norestart"
Remove-Item $azMsi

Write-Host "Verifying installations..."
pwsh -Command '$PSVersionTable.PSVersion'
az --version
