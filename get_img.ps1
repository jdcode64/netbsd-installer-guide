$ErrorActionPreference = 'Stop'
$destGz = "C:\proyectos\netbsd\iso\NetBSD-11.0-amd64-install.img.gz"
$url = "https://cdn.NetBSD.org/pub/NetBSD/images/11.0/NetBSD-11.0-amd64-install.img.gz"

if (-not (Test-Path $destGz)) {
    Write-Host "Descargando NetBSD-11.0-amd64-install.img.gz..."
    curl.exe --http1.1 -sSL -o $destGz $url
    if ($LASTEXITCODE -ne 0) { throw "Error al descargar" }
}
Write-Host "Descarga completa. Descomprimiendo con tar.exe..."
tar.exe -xzf $destGz -C "C:\proyectos\netbsd\iso"
Write-Host "Imagen install.img descomprimida con exito."
