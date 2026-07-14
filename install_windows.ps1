$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
$script = Join-Path $dir 'meddial.py'

$py = (Get-Command pythonw.exe -ErrorAction SilentlyContinue).Source
if (-not $py) { $py = (Get-Command python.exe -ErrorAction SilentlyContinue).Source }
if (-not $py) { Write-Host 'Python not found. Install it from python.org with "Add to PATH" checked.'; exit 1 }

pip install pyserial

$cmd = '"' + $py + '" "' + $script + '" "%1"'

New-Item -Path 'HKCU:\Software\Classes\meddial' -Force | Out-Null
Set-ItemProperty -Path 'HKCU:\Software\Classes\meddial' -Name '(default)' -Value 'URL:MedDial Protocol'
Set-ItemProperty -Path 'HKCU:\Software\Classes\meddial' -Name 'URL Protocol' -Value ''
New-Item -Path 'HKCU:\Software\Classes\meddial\shell\open\command' -Force | Out-Null
Set-ItemProperty -Path 'HKCU:\Software\Classes\meddial\shell\open\command' -Name '(default)' -Value $cmd

Write-Host 'Done. Test dialing:  start meddial:1234567'
