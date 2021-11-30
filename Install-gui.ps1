$ErrorActionPreference = "Stop"

if ($null -eq (Get-ChildItem env:VIRTUAL_ENV -ErrorAction SilentlyContinue))
{
    Write-Output "This script requires that the Chives Python virtual environment is activated."
    Write-Output "Execute '.\venv\Scripts\Activate.ps1' before running."
    Exit 1
}

if ($null -eq (Get-Command node -ErrorAction SilentlyContinue))
{
    Write-Output "Unable to find Node.js"
    Exit 1
}

Write-Output "Running 'git submodule update --init --recursive'."
Write-Output ""
git submodule update --init --recursive
git submodule update

Push-Location
try {
    Set-Location chives-blockchain-gui
	git fetch
	git checkout main
    git pull

    $ErrorActionPreference = "SilentlyContinue"
    npm install --loglevel=error
    npm audit fix --force
    npm run build
    py ..\installhelper.py

    Write-Output ""
    Write-Output "Chives blockchain Install-gui.ps1 completed."
    Write-Output ""
    Write-Output "Type 'cd chives-blockchain-gui' and then 'npm run electron' to start the GUI."
} finally {
    Pop-Location
}

