$ErrorActionPreference = 'Stop'
$dest = "C:\proyectos\netbsd\iso\NetBSD-11.0-amd64.iso"
$shaDest = "C:\proyectos\netbsd\iso\SHA512"
$urlIso = "https://cdn.NetBSD.org/pub/NetBSD/images/11.0/NetBSD-11.0-amd64.iso"
$urlSha = "https://cdn.NetBSD.org/pub/NetBSD/images/11.0/SHA512"

New-Item -ItemType Directory -Force -Path "C:\proyectos\netbsd\iso" | Out-Null

Write-Host "Descargando SHA512 de las imagenes..."
curl.exe --http1.1 -sSL -o $shaDest $urlSha

Write-Host "Descargando NetBSD-11.0-amd64.iso..."
curl.exe --http1.1 -sSL -o $dest $urlIso
if ($LASTEXITCODE -ne 0) {
    Write-Error "Fallo descargando la ISO"
}

Write-Host "Verificando SHA512 de la ISO..."
$lines = Get-Content $shaDest
$match = $lines | Where-Object { $_ -match "SHA512 \(NetBSD-11\.0-amd64\.iso\) = ([a-fA-F0-9]+)" }
if ($match -match "SHA512 \(NetBSD-11\.0-amd64\.iso\) = ([a-fA-F0-9]+)") {
    $expected = $Matches[1].ToLower()
    $actual = (Get-FileHash -Path $dest -Algorithm SHA512).Hash.ToLower()
    if ($expected -eq $actual) {
        Write-Host "ISO VERIFICADA CON EXITO (SHA512 OK)."
    } else {
        Write-Error "Error: El hash SHA512 no coincide."
    }
} else {
    Write-Host "ISO descargada. (Linea de hash no encontrada de forma directa)"
}
