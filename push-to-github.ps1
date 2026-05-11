# Inveris Digital — one-shot deploy script
# Pushes this folder to https://github.com/chinmay686/inverisdigital-com
#
# How to run:
#   1. Open File Explorer to this folder
#   2. Shift + right-click in empty space → "Open PowerShell window here"
#      (or on Windows 11: right-click → "Open in Terminal")
#   3. If PowerShell warns about execution policy, paste this first:
#         Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
#   4. Then run:
#         .\push-to-github.ps1

$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

Write-Host ""
Write-Host "=== Inveris Digital -> GitHub ===" -ForegroundColor Cyan
Write-Host "Repo folder: $PSScriptRoot"
Write-Host ""

# 1. Sanity-check git is installed
try {
    $gitVersion = git --version
    Write-Host "OK  Found $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "ERR git is not installed. Install from https://git-scm.com/download/win and re-run." -ForegroundColor Red
    exit 1
}

# 2. Clean any partial .git folder (the staging step on Linux left a stub)
if (Test-Path ".git") {
    Write-Host "Cleaning partial .git folder from staging..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force ".git"
}

# 3. Initialize the repo
Write-Host ""
Write-Host "Initializing git repo..." -ForegroundColor Cyan
git init -b main | Out-Null

# 4. Configure identity if not already set globally
$existingEmail = git config --global user.email 2>$null
if (-not $existingEmail) {
    Write-Host "Setting local git identity (you can change later with: git config --global user.name '...')"
    git config user.email "chinmay.pradhan@gmail.com"
    git config user.name "Chinmay"
}

# 5. Stage and commit
Write-Host "Staging files..." -ForegroundColor Cyan
git add .
$status = git status --short
Write-Host $status
git commit -m "Initial production site v1" | Out-Null
Write-Host "OK  Initial commit created." -ForegroundColor Green

# 6. Add the remote
Write-Host ""
Write-Host "Adding remote origin -> https://github.com/chinmay686/inverisdigital-com" -ForegroundColor Cyan
git remote add origin https://github.com/chinmay686/inverisdigital-com.git

# 7. Push
Write-Host ""
Write-Host "Pushing to GitHub..." -ForegroundColor Cyan
Write-Host "(If this is your first push from this PC, Windows will pop up a browser to sign in to GitHub.)" -ForegroundColor DarkGray
git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "=== DONE ===" -ForegroundColor Green
    Write-Host "Visit https://github.com/chinmay686/inverisdigital-com to confirm." -ForegroundColor Green
    Write-Host ""
    Write-Host "Next step (LAUNCH.md Step 3): go to https://vercel.com, click Add New > Project, and import this repo."
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "=== PUSH FAILED ===" -ForegroundColor Red
    Write-Host "Most common cause: the repo on GitHub already has commits (e.g., an initial README)." -ForegroundColor Yellow
    Write-Host "Fix it with these two commands, then push again:" -ForegroundColor Yellow
    Write-Host "    git pull origin main --allow-unrelated-histories" -ForegroundColor White
    Write-Host "    git push -u origin main" -ForegroundColor White
    Write-Host ""
}
