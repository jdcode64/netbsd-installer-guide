$ErrorActionPreference = 'Stop'
$baseUrl = "https://cdn.NetBSD.org/pub/NetBSD/NetBSD-11.0/amd64/binary/sets/"
$destDir = "C:\proyectos\netbsd\sets_11.0"

New-Item -ItemType Directory -Force -Path $destDir | Out-Null

$files = @(
    "SHA512",
    "base.tar.xz",
    "base32.tar.xz",
    "etc.tar.xz",
    "kern-GENERIC.tar.xz",
    "kern-GENERIC_KASLR.tar.xz",
    "modules.tar.xz",
    "gpufw.tar.xz",
    "man.tar.xz",
    "manhtml.tar.xz",
    "misc.tar.xz",
    "text.tar.xz",
    "comp.tar.xz",
    "rescue.tar.xz",
    "games.tar.xz",
    "xbase.tar.xz",
    "xetc.tar.xz",
    "xfont.tar.xz",
    "xserver.tar.xz",
    "xcomp.tar.xz"
)

foreach ($f in $files) {
    $targetPath = Join-Path $destDir $f
    if (-not (Test-Path $targetPath)) {
        Write-Host "Descargando $f..."
        $url = $baseUrl + $f
        curl.exe --http1.1 -sSL -o $targetPath $url
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Fallo descargando $f"
        }
    } else {
        Write-Host "Ya existe $f"
    }
}
Write-Host "Descarga de sets 11.0 completada exitosamente."
