# Script tự động Build, Test & Publish bản Release cho Server/VPS (Windows IIS / Linux)
param(
    [string]$ProjectPath = "..\SOF1022_NHOM1_SD2003_Ver2\SOF1022_NHOM1_SD2003_Ver2\SOF1022_NHOM1_SD2003_Ver2.csproj",
    [string]$OutputDir = ".\publish"
)

Write-Host "=== 1. Restore & Build Release ===" -ForegroundColor Cyan
dotnet restore $ProjectPath
dotnet build $ProjectPath -c Release --no-restore

Write-Host "=== 2. Publish Application to $OutputDir ===" -ForegroundColor Cyan
dotnet publish $ProjectPath -c Release -o $OutputDir --no-build

Write-Host "=== 3. Hoan tat! Copy thu muc $OutputDir len IIS hoac Linux VPS ===" -ForegroundColor Green
