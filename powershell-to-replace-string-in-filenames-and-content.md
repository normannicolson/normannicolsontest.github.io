# Powershell to Replace String in Filenames & Content

Mar 2018

> Script to replace string in filenames & file content useful for renaming namespaces.

Get all files in folder

```
```

What is CmtLet

How get all properties from object 

```
$object | Select-Object -Property *
```

Script to rename project

```
$path = "C:\projects\project\src"
$orgString = "Nlist.Org"
$orgStringFilter = "Nlist.New*"
$newString = "Nlist.New"

cd $path

$orgFiles = Get-ChildItem $path -recurse | Select-String -pattern $orgString | Group-Object -Property Path | Where-Object { ($_).Name -ne 'InputStream' } 

#Replace string in files 
foreach ($file in $orgFiles)
{
     (Get-Content ($file).Name) | Foreach-Object { $_ -replace $orgString, $newString } | Set-Content ($file).Name
}

#Replace string in filenames 
Get-ChildItem -Filter orgStringFilter -Recurse | % { Rename-Item -Path $_.PSPath -NewName $_.Name.replace($orgString, $newString)}
```