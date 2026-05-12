# Inveris Digital — one-click deploy
# Stages, commits, and pushes any local changes to GitHub. Vercel auto-deploys.
#
# How to run:
#   1. Edit any file in this folder
#   2. Right-click here -> Open in Terminal
#   3. Run:  .\deploy.ps1
#   4. Enter a short message describing your change when prompted
#   5. Done. Live on inverisdigital.com in ~30 seconds.

$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

Write-Host ""
Write-Host "=== Deploy to inverisdigital.com ===" -ForegroundColor Cyan

# 1. Check there's something to deploy
$changes = git status --porcelain
if (-not $changes) {
    Write-Host "Nothing changed since last deploy. Exiting." -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "Files changed:" -ForegroundColor White
git status --short
Write-Host ""

# 2. Prompt for commit message
$message = Read-Host "Describe the change (e.g. 'Enlarge logo in nav')"
if (-not $message) {
    Write-Host "No message entered. Aborting." -ForegroundColor Red
    exit 1
}

# 3. Stage, commit, push
git add .
git commit -m "$message" | Out-Null
Write-Host ""
Write-Host "Pushing to GitHub..." -ForegroundColor Cyan
git push

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "=== PUSHED ===" -ForegroundColor Green
    Write-Host "Vercel is now deploying. Check status at:" -ForegroundColor Green
    Write-Host "  https://vercel.com/dashboard"
    Write-Host ""
    Write-Host "Live on https://inverisdigital.com in ~30 seconds." -ForegroundColor Green
    Write-Host "Hard refresh your browser (Ctrl+F5) once it lands to see the change." -ForegroundColor DarkGray
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "Push failed. See output above. Common fix:" -ForegroundColor Red
    Write-Host "  git pull --rebase" -ForegroundColor White
    Write-Host "  .\deploy.ps1" -ForegroundColor White
    Write-Host ""
}
