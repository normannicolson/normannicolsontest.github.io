# Powershell Find All Files with String Contained

Jun 2018

> Script to locate all files contained in folder containing search text.

Script to locate all files contained in folder containing search text. Useful for finding endpoint references within web apps and logic apps.

```
$path = "C:\projects\project\src"
$pattern = "Find"

cd $path

$findFiles = Get-ChildItem $path -recurse | Select-String -pattern $pattern | Group-Object -Property Path | Where-Object { ($_).Name -ne 'InputStream' } 

foreach ($file in $findFiles)
{
    ($file).Name
}
```