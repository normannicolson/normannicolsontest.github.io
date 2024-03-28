B2c Replace Placeholders in files

Dec 2021

> B2c Replace Placeholders in files

```
[Cmdletbinding()]
Param(
    [Parameter(Mandatory = $true)][string]$folder,
    [Parameter(Mandatory = $true)][string]$placeholder,
    [Parameter(Mandatory = $true)][string]$value
)

try {
    $orgFiles = (Get-ChildItem $folder -Recurse -include *.xml)
    foreach ($file in $orgFiles)
    {
        (Get-Content ($file).FullName) | Foreach-Object { $_ -replace $placeholder, $value } | Set-Content ($file).FullName
    }
}
catch {
    exit 1
}

exit 0
```