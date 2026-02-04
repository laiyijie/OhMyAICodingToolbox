# OhMyAICodingToolbox Install Script (Windows)
# Usage: .\scripts\install.ps1 [-Tool] <Cursor|Claude> [-Scope] <User|Project> [-Lang] <zh|en>

param(
    [ValidateSet('Cursor', 'Claude')]
    [string]$Tool,

    [ValidateSet('User', 'Project')]
    [string]$Scope,

    [ValidateSet('zh', 'en')]
    [string]$Lang = 'en'
)

# Get script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RootDir = Split-Path -Parent $ScriptDir

# Memory path mapping for different tools
$MemoryPaths = @{
    Claude = 'CLAUDE.md'
    Cursor = '.cursor/rules/memory.mdc'
}

# Interactive tool selection if not provided
if (-not $Tool) {
    Write-Host "`nSelect AI coding tool:" -ForegroundColor Cyan
    Write-Host "  [1] Claude Code" -ForegroundColor White
    Write-Host "  [2] Cursor" -ForegroundColor White
    Write-Host ""

    $choice = Read-Host "Enter choice (1 or 2)"

    switch ($choice) {
        '1' { $Tool = 'Claude' }
        '2' { $Tool = 'Cursor' }
        default {
            Write-Host "Invalid choice. Exiting." -ForegroundColor Red
            exit 1
        }
    }
    Write-Host ""
}

# Interactive scope selection if not provided
if (-not $Scope) {
    Write-Host "Select installation scope:" -ForegroundColor Cyan
    Write-Host "  [1] User    - Global, available for all projects" -ForegroundColor White
    Write-Host "  [2] Project - Current project only" -ForegroundColor White
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
    App = Join-Path $RootDir "app\$Lang"
    E2E = Join-Path $RootDir "e2e\$Lang"
}

function Install-Commands {
    param(
        [string]$ToolName,
        [string]$TargetDir
    )

    $LangLabel = if ($Lang -eq 'zh') { 'Chinese' } else { 'English' }
    $MemoryPath = $MemoryPaths[$ToolName]

    Write-Host "Installing $ToolName commands ($LangLabel) to $TargetDir ..." -ForegroundColor Cyan
    Write-Host "  Memory path: $MemoryPath" -ForegroundColor Gray

    # Create target directory
    $CommandsDir = Join-Path $TargetDir 'commands'
    if (-not (Test-Path $CommandsDir)) {
        New-Item -ItemType Directory -Path $CommandsDir -Force | Out-Null
        Write-Host "  Created directory: $CommandsDir" -ForegroundColor Green
    }

    # Copy and process app commands
    if (Test-Path $SourceDirs.App) {
        Get-ChildItem -Path $SourceDirs.App -Filter '*.md' | ForEach-Object {
            $DestPath = Join-Path $CommandsDir $_.Name

            # Read content and replace placeholder
            $Content = Get-Content $_.FullName -Raw -Encoding UTF8
            $Content = $Content -replace '\{\{MEMORY_PATH\}\}', $MemoryPath

            # Write to destination
            Set-Content -Path $DestPath -Value $Content -Encoding UTF8 -NoNewline
            Write-Host "  Installed: $($_.Name)" -ForegroundColor Green
        }
    } else {
        Write-Host "  Warning: Source directory not found: $($SourceDirs.App)" -ForegroundColor Yellow
    }

    # Copy and process e2e commands (if exists)
    if (Test-Path $SourceDirs.E2E) {
        Get-ChildItem -Path $SourceDirs.E2E -Filter '*.md' -ErrorAction SilentlyContinue | ForEach-Object {
            $DestPath = Join-Path $CommandsDir $_.Name

            $Content = Get-Content $_.FullName -Raw -Encoding UTF8
            $Content = $Content -replace '\{\{MEMORY_PATH\}\}', $MemoryPath

            Set-Content -Path $DestPath -Value $Content -Encoding UTF8 -NoNewline
            Write-Host "  Installed: $($_.Name)" -ForegroundColor Green
        }
    }

    Write-Host "  Done! Installed to: $CommandsDir" -ForegroundColor Green
}

function Install-Tool {
    param(
        [string]$ToolName
    )

    $TargetDir = $ToolDirs[$ToolName][$Scope]

    Write-Host "`n========================================" -ForegroundColor Magenta
    Write-Host "Installing for $ToolName ($Scope level)" -ForegroundColor Magenta
    Write-Host "========================================`n" -ForegroundColor Magenta

    # Create target root directory
    if (-not (Test-Path $TargetDir)) {
        New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
        Write-Host "Created directory: $TargetDir`n" -ForegroundColor Green
    }

    # Install commands
    Install-Commands -ToolName $ToolName -TargetDir $TargetDir
}

# Main flow
Write-Host "`nOhMyAICodingToolbox Installer" -ForegroundColor Yellow
Write-Host "============================`n" -ForegroundColor Yellow
Write-Host "Configuration:" -ForegroundColor White
Write-Host "  Tool: $Tool" -ForegroundColor White
Write-Host "  Scope: $Scope" -ForegroundColor White
Write-Host "  Language: $Lang" -ForegroundColor White
Write-Host "  Memory Path: $($MemoryPaths[$Tool])`n" -ForegroundColor White

# Install for selected tool
Install-Tool -ToolName $Tool

Write-Host "`n========================================" -ForegroundColor Magenta
Write-Host "Installation Complete!" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Magenta

# Show usage tips
Write-Host "Usage Tips:" -ForegroundColor Cyan
if ($Tool -eq 'Cursor') {
    Write-Host "  Application: oh.specify.app / oh.plan.app / oh.implement.app" -ForegroundColor White
    Write-Host "  E2E Testing: oh.specify.e2e / oh.plan.e2e / oh.implement.e2e" -ForegroundColor White
} else {
    Write-Host "  Application: /oh.specify.app / /oh.plan.app / /oh.implement.app" -ForegroundColor White
    Write-Host "  E2E Testing: /oh.specify.e2e / /oh.plan.e2e / /oh.implement.e2e" -ForegroundColor White
}
Write-Host ""
