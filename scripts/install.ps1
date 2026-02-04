# OhMyAICodingToolbox Install Script (Windows)
# Usage: .\scripts\install.ps1 [-Tool] <Cursor|Claude|All> [-Scope] <User|Project> [-Mode] <Copy|Link> [-Lang] <zh|en>

param(
    [ValidateSet('Cursor', 'Claude', 'All')]
    [string]$Tool = 'All',

    [ValidateSet('User', 'Project')]
    [string]$Scope,

    [ValidateSet('Copy', 'Link')]
    [string]$Mode = 'Link',

    [ValidateSet('zh', 'en')]
    [string]$Lang = 'en'
)

# Get script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RootDir = Split-Path -Parent $ScriptDir

# Interactive scope selection if not provided
if (-not $Scope) {
    Write-Host "`nSelect installation scope:" -ForegroundColor Cyan
    Write-Host "  [1] User   - Global, available for all projects (~/.cursor/, ~/.claude/)" -ForegroundColor White
    Write-Host "  [2] Project - Current project only (./.cursor/, ./.claude/)" -ForegroundColor White
    Write-Host ""

    $choice = Read-Host "Enter choice (1 or 2)"

    switch ($choice) {
        '1' { $Scope = 'User' }
        '2' { $Scope = 'Project' }
        default {
            Write-Host "Invalid choice. Using default: User" -ForegroundColor Yellow
            $Scope = 'User'
        }
    }
    Write-Host ""
}

# Define tool directories
$ToolDirs = @{
    Cursor = @{
        User    = Join-Path $env:USERPROFILE '.cursor'
        Project = Join-Path (Get-Location) '.cursor'
    }
    Claude = @{
        User    = Join-Path $env:USERPROFILE '.claude'
        Project = Join-Path (Get-Location) '.claude'
    }
}

# Source directories (based on language)
$SourceDirs = @{
    Application = Join-Path $RootDir "application\$Lang"
    Testing     = Join-Path $RootDir "test_project\$Lang"
}

function Install-Commands {
    param(
        [string]$ToolName,
        [string]$TargetDir
    )

    $LangLabel = if ($Lang -eq 'zh') { 'Chinese' } else { 'English' }
    Write-Host "Installing $ToolName commands ($LangLabel) to $TargetDir ..." -ForegroundColor Cyan

    # Create target directory
    $CommandsDir = Join-Path $TargetDir 'commands'
    if (-not (Test-Path $CommandsDir)) {
        New-Item -ItemType Directory -Path $CommandsDir -Force | Out-Null
        Write-Host "  Created directory: $CommandsDir" -ForegroundColor Green
    }

    # Copy or link application commands
    if (Test-Path $SourceDirs.Application) {
        Get-ChildItem -Path $SourceDirs.Application -Filter '*.md' | ForEach-Object {
            $DestPath = Join-Path $CommandsDir $_.Name

            if ($Mode -eq 'Link') {
                # Remove existing file/link
                if (Test-Path $DestPath) {
                    Remove-Item $DestPath -Force -Recurse
                }
                # Create symbolic link
                New-Item -ItemType SymbolicLink -Path $DestPath -Target $_.FullName | Out-Null
                Write-Host "  Linked: $($_.Name)" -ForegroundColor Green
            } else {
                # Copy file
                Copy-Item $_.FullName $DestPath -Force
                Write-Host "  Copied: $($_.Name)" -ForegroundColor Green
            }
        }
    } else {
        Write-Host "  Warning: Source directory not found: $($SourceDirs.Application)" -ForegroundColor Yellow
    }

    # Copy or link testing commands (if exists)
    if (Test-Path $SourceDirs.Testing) {
        Get-ChildItem -Path $SourceDirs.Testing -Filter '*.md' -ErrorAction SilentlyContinue | ForEach-Object {
            $DestPath = Join-Path $CommandsDir $_.Name

            if ($Mode -eq 'Link') {
                if (Test-Path $DestPath) {
                    Remove-Item $DestPath -Force -Recurse
                }
                New-Item -ItemType SymbolicLink -Path $DestPath -Target $_.FullName | Out-Null
                Write-Host "  Linked: $($_.Name)" -ForegroundColor Green
            } else {
                Copy-Item $_.FullName $DestPath -Force
                Write-Host "  Copied: $($_.Name)" -ForegroundColor Green
            }
        }
    }

    Write-Host "  Done! Installed to: $CommandsDir" -ForegroundColor Green
}

function Install-Skills {
    param(
        [string]$ToolName,
        [string]$TargetDir
    )

    Write-Host "Installing $ToolName skills to $TargetDir ..." -ForegroundColor Cyan

    # Create target directory
    $SkillsDir = Join-Path $TargetDir 'skills'
    if (-not (Test-Path $SkillsDir)) {
        New-Item -ItemType Directory -Path $SkillsDir -Force | Out-Null
        Write-Host "  Created directory: $SkillsDir" -ForegroundColor Green
    }

    # TODO: Install skills (none currently)

    Write-Host "  Done!" -ForegroundColor Green
}

function Install-Tool {
    param(
        [string]$ToolName
    )

    $TargetDir = $ToolDirs[$ToolName][$Scope]

    Write-Host "`n========================================" -ForegroundColor Magenta
    Write-Host "Installing $ToolName ($Scope level)" -ForegroundColor Magenta
    Write-Host "========================================`n" -ForegroundColor Magenta

    # Create target root directory
    if (-not (Test-Path $TargetDir)) {
        New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
        Write-Host "Created directory: $TargetDir`n" -ForegroundColor Green
    }

    # Install commands and skills
    Install-Commands -ToolName $ToolName -TargetDir $TargetDir
    Install-Skills -ToolName $ToolName -TargetDir $TargetDir
}

# Main flow
Write-Host "`nOhMyAICodingToolbox Installer" -ForegroundColor Yellow
Write-Host "============================`n" -ForegroundColor Yellow
Write-Host "Configuration:" -ForegroundColor White
Write-Host "  Tool: $Tool" -ForegroundColor White
Write-Host "  Scope: $Scope" -ForegroundColor White
Write-Host "  Mode: $Mode" -ForegroundColor White
Write-Host "  Language: $Lang`n" -ForegroundColor White

# Check if admin privileges needed (for symbolic links)
if ($Mode -eq 'Link') {
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if (-not $isAdmin) {
        Write-Host "Warning: Creating symbolic links requires administrator privileges." -ForegroundColor Yellow
        Write-Host "If installation fails, run PowerShell as Administrator, or use -Mode Copy.`n" -ForegroundColor Yellow
    }
}

# Install based on selection
if ($Tool -eq 'All' -or $Tool -eq 'Cursor') {
    Install-Tool -ToolName 'Cursor'
}

if ($Tool -eq 'All' -or $Tool -eq 'Claude') {
    Install-Tool -ToolName 'Claude'
}

Write-Host "`n========================================" -ForegroundColor Magenta
Write-Host "Installation Complete!" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Magenta

# Show usage tips
Write-Host "Usage Tips:" -ForegroundColor Cyan
Write-Host "  Cursor:   Type oh.specify / oh.plan / oh.implement in chat" -ForegroundColor White
Write-Host "  Claude:   Type /oh.specify / /oh.plan / /oh.implement in chat`n" -ForegroundColor White
