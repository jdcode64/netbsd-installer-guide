$imgPath = "C:\proyectos\netbsd\iso\NetBSD-11.0-amd64-install.img"
$diskNumber = 1

# 1. Doble comprobacion de seguridad
$targetDisk = Get-Disk -Number $diskNumber
if ($targetDisk.BusType -ne "USB" -or $targetDisk.Size -gt 64GB -or $targetDisk.Size -lt 14GB) {
    throw "ABORTADO POR SEGURIDAD: El disco $diskNumber no coincide con la memoria USB esperada."
}
Write-Host "Dispositivo verificado: $($targetDisk.FriendlyName) ($([math]::Round($targetDisk.Size / 1GB, 2)) GB)"

# 2. Desmontar volumenes y limpiar particiones
Write-Host "Limpiando particiones anteriores de la memoria USB..."
Clear-Disk -Number $diskNumber -RemoveData -RemoveOEM -Confirm:$false

# 3. Escritura cruda (raw write) por bloques de 4MB
Write-Host "Escribiendo NetBSD-11.0-amd64-install.img directamente en \\.\PhysicalDrive$diskNumber..."
$imgStream = [System.IO.File]::OpenRead($imgPath)
$diskPath = "\\.\PhysicalDrive$diskNumber"

# Abrir PhysicalDrive con FileAccess.Write y FileShare.ReadWrite
$diskStream = New-Object System.IO.FileStream(
    $diskPath,
    [System.IO.FileMode]::Open,
    [System.IO.FileAccess]::Write,
    [System.IO.FileShare]::ReadWrite
)

$buffer = New-Object byte[] (4 * 1024 * 1024) # Buffer 4MB
$totalBytes = $imgStream.Length
$writtenBytes = 0

while (($read = $imgStream.Read($buffer, 0, $buffer.Length)) -gt 0) {
    $diskStream.Write($buffer, 0, $read)
    $writtenBytes += $read
    $percent = [math]::Round(($writtenBytes / $totalBytes) * 100, 1)
    Write-Progress -Activity "Escribiendo NetBSD en USB" -Status "$percent% completado" -PercentComplete $percent
}

$diskStream.Flush()
$diskStream.Close()
$imgStream.Close()

Write-Host "Escritura completada exitosamente al 100%."
Update-Disk -Number $diskNumber
