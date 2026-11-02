param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^[A-Za-z0-9](?:[A-Za-z0-9-]{0,37}[A-Za-z0-9])?$')]
    [string]$Username
)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$utf8 = New-Object System.Text.UTF8Encoding($false)

$configPath = Join-Path $root 'hugo.toml'
$config = [System.IO.File]::ReadAllText($configPath)
$config = $config.Replace('https://duplicatename10086.github.io/', "https://$Username.github.io/")
$config = $config.Replace('https://github.com/duplicatename10086', "https://github.com/$Username")
[System.IO.File]::WriteAllText($configPath, $config, $utf8)

$aboutPath = Join-Path $root 'content/about.md'
if (Test-Path $aboutPath) {
    $about = [System.IO.File]::ReadAllText($aboutPath)
    $about = $about.Replace('https://github.com/duplicatename10086', "https://github.com/$Username")
    $about = $about.Replace('[@duplicatename10086]', "[@$Username]")
    [System.IO.File]::WriteAllText($aboutPath, $about, $utf8)
}

Write-Host ''
Write-Host "已把站点地址改为 https://$Username.github.io/" -ForegroundColor Green
Write-Host "已把 GitHub 链接改为 https://github.com/$Username" -ForegroundColor Green
Write-Host ''
Write-Host '接下来：' -ForegroundColor Cyan
Write-Host "1. 在 GitHub 新建公开仓库 $Username.github.io"
Write-Host '2. 用 GitHub Desktop 把当前目录推上去'
Write-Host '3. 仓库 Settings → Pages → Source 选择 GitHub Actions'
