# 本地预览：优先用仓库自带的 Hugo，找不到再退回 PATH 里的 hugo。
# 用法：.\scripts\preview.ps1
$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$hugoPath = $null

$command = Get-Command hugo -ErrorAction SilentlyContinue
if ($command) {
    $hugoPath = $command.Source
}

if (-not $hugoPath) {
    $bundled = Join-Path $root '..\tools\hugo\hugo.exe'
    if (Test-Path $bundled) {
        $hugoPath = (Resolve-Path $bundled).Path
    }
}

if (-not $hugoPath) {
    throw '没有找到 Hugo。请先安装 hugo extended，或把 hugo.exe 放到 ..\tools\hugo\ 下。'
}

Push-Location $root
try {
    & $hugoPath server -D --renderToMemory
}
finally {
    Pop-Location
}
