
# install-tools.ps1
# Cross-platform script to install PowerShell Core and Azure CLI on Windows and Linux

function Install-Pwsh-Windows {
	Write-Host "Installing PowerShell Core (Windows)..."
	$pwshInstaller = "https://github.com/PowerShell/PowerShell/releases/download/v7.4.2/PowerShell-7.4.2-win-x64.msi"
	$pwshMsi = "$env:TEMP\PowerShell-7.4.2-win-x64.msi"
	Invoke-WebRequest -Uri $pwshInstaller -OutFile $pwshMsi
	Start-Process msiexec.exe -Wait -ArgumentList "/I $pwshMsi /quiet /norestart"
	Remove-Item $pwshMsi
}

function Install-AzCli-Windows {
	Write-Host "Installing Azure CLI (Windows)..."
	$azInstaller = "https://aka.ms/installazurecliwindows"
	$azMsi = "$env:TEMP\AzureCLI.msi"
	Invoke-WebRequest -Uri $azInstaller -OutFile $azMsi
	Start-Process msiexec.exe -Wait -ArgumentList "/I $azMsi /quiet /norestart"
	Remove-Item $azMsi
}

function Install-Pwsh-Linux {
	Write-Host "Installing PowerShell Core (Linux)..."
	wget https://github.com/PowerShell/PowerShell/releases/download/v7.4.2/powershell-7.4.2-linux-x64.tar.gz -O /tmp/powershell.tar.gz
	mkdir -p ~/powershell
	tar -xvf /tmp/powershell.tar.gz -C ~/powershell
	sudo ln -sf ~/powershell/pwsh /usr/bin/pwsh
	rm /tmp/powershell.tar.gz
}

function Install-AzCli-Linux {
	Write-Host "Installing Azure CLI (Linux)..."
	if (Get-Command apt-get -ErrorAction SilentlyContinue) {
		curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
	} elseif (Get-Command yum -ErrorAction SilentlyContinue) {
		sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
		sudo sh -c 'echo -e "[azure-cli]\nname=Azure CLI\nbaseurl=https://packages.microsoft.com/yumrepos/azure-cli\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo'
		sudo yum install -y azure-cli
	} else {
		Write-Host "Unsupported Linux distribution. Please install Azure CLI manually."
	}
}

if ($IsWindows) {
	Install-Pwsh-Windows
	Install-AzCli-Windows
} elseif ($IsLinux) {
	Install-Pwsh-Linux
	Install-AzCli-Linux
} else {
	Write-Host "Unsupported OS. This script supports only Windows and Linux."
}

Write-Host "Verifying installations..."
try {
	pwsh -Command '$PSVersionTable.PSVersion'
} catch { Write-Host "PowerShell Core not found after install." }
try {
	az --version
} catch { Write-Host "Azure CLI not found after install." }

