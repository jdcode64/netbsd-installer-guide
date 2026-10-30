$shaFile = "C:\proyectos\netbsd\sets_11.0\SHA512"
$lines = Get-Content $shaFile
$files = Get-ChildItem "C:\proyectos\netbsd\sets_11.0" -Filter "*.tar.xz"
$results = @()

foreach ($file in $files) {
    $matchedLine = $lines | Where-Object { $_ -match "SHA512 \($([regex]::Escape($file.Name))\) = ([a-fA-F0-9]+)" }
    if ($matchedLine) {
        $expected = $Matches[1].ToLower()
        $actual = (Get-FileHash -Path $file.FullName -Algorithm SHA512).Hash.ToLower()
        if ($expected -eq $actual) {
            $results += [PSCustomObject]@{ File = $file.Name; Status = "OK" }
        } else {
            $results += [PSCustomObject]@{ File = $file.Name; Status = "HASH_MISMATCH" }
        }
    } else {
        $results += [PSCustomObject]@{ File = $file.Name; Status = "NOT_IN_CHECKSUMS" }
    }
}
$results | Format-Table -AutoSize
