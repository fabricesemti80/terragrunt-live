#
# ─── TEST ───────────────────────────────────────────────────────────────────────
#
$admin_folder = 'c:\admin'
if (-not (Test-Path $admin_folder -ErrorAction SilentlyContinue) ) {
    New-Item -Path $admin_folder -ItemType Directory -Force
}
'PowerShell was here' | Out-File "$admin_folder\ps.txt"
#
# # ─── ENSURE WINRM SERVICE IS RUNNING ────────────────────────────────────────────
# #
# Enable-PSRemoting -Force
# Start-Service WinRM
# Set-Service WinRM -StartupType Automatic
# #
# ─── ENSURE WINDOWS FIREWALL IS TURNED ON ───────────────────────────────────────
#
Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled true -Confirm: $false
#
# ─── ENSURE RDP IS ENABLED ──────────────────────────────────────────────────────
#
Set-ItemProperty -Path 'HKLM:/System/CurrentControlSet/Control/Terminal Server' -Name 'fDenyTSConnections' -Value 0 -Verbose -Confirm: $false
try {
    # try PS
    Enable-NetFirewallRule -DisplayGroup 'Remote Desktop'
}
catch {
    Write-Warning $_.Exception.Message
    # fall back to cmd/netsh
    netsh advfirewall firewall add rule name='allow RemoteDesktop' dir=in protocol=TCP localport=3389 action=allow
    Continue
}
#
# ─── SHOW HIDDEEN AND SYSYTEM FILES ─────────────────────────────────────────────
#
$regPath = 'HKCU:Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
# show hidden files.
$splat = @{
    Path  = $regPath
    Name  = 'Hidden'
    Value = 1
}
Set-ItemProperty @splat
# show protected operating system files.
$splat = @{
    Path  = $regPath
    Name  = 'ShowSuperHidden'
    Value = 1
}
Set-ItemProperty @splat
# show file extensions.
$splat = @{
    Path  = $regPath
    Name  = 'HideFileExt'
    Value = 0
}
Set-ItemProperty @splat -Confirm: $false