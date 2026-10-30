$src = "C:\proyectos\netbsd\iso\NetBSD-11.0-amd64-install.img.gz"
$dest = "C:\proyectos\netbsd\iso\NetBSD-11.0-amd64-install.img"

if (Test-Path $dest) { Remove-Item $dest -Force }

$inStream = [System.IO.File]::OpenRead($src)
$gzipStream = New-Object System.IO.Compression.GZipStream($inStream, [System.IO.Compression.CompressionMode]::Decompress)
$outStream = [System.IO.File]::Create($dest)

Write-Host "Descomprimiendo .gz con .NET GZipStream nativo..."
$gzipStream.CopyTo($outStream)

$outStream.Close()
$gzipStream.Close()
$inStream.Close()

Write-Host "Descompresion completada con exito."
Get-Item $dest | Select-Object Name, Length
