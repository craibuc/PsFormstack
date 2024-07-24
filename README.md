# PsFormstack

## Development

### Create a symlink in PowerShell's "Modules" folder
```pwsh
$ModuleName='PsFormstack'
$Here = Get-Location
$ModulePath = ($ENV:PSModulePath -split ([System.Environment]::OSVersion -eq '' ? ';' : ':'))[0]
Push-Location $ModulePath
ln -s "$Here/$ModuleName" $ModuleName
Pop-Location
```

## Examples

### Get-FormstackForm

```pwsh
Get-FormstackForm -AccessToken $Env:FORMSTACK_ACCESS_TOKEN
```

### Get-FormstackFormField

```pwsh
Get-FormstackFormField -AccessToken $Env:FORMSTACK_ACCESS_TOKEN -FormId 123456 | 
Where-Object {$_.type -ne 'section' -and $_.required -eq 0} |
Select-Object id,required,type,name,label |
Tee-Object -Variable Data | Format-Table -AutoSize

$Data | ConvertTo-Csv | Out-File -FilePath ./Fields.csv
```

###

```pwsh
Get-FormstackFormSubmission -AccessToken $Env:FORMSTACK_ACCESS_TOKEN -EncryptionKey $Env:FORMSTACK_ENCRYPTION_KEY -FormId 123456 | 
  Where-Object { $_.workflow.complete -eq 1 } | 
  Select-Object Id, @{n='Complete';e={[bool][int]$_.workflow.complete}} -ExpandProperty data | 
  Select-Object id, complete, @{n='Applied';e={([datetime]$_.'123098091'.value).ToString('yyyy-MM-dd')}},@{n='Last Name';e={ $_.'123367725'.value.last}},@{n='First Name';e={ $_.'123367725'.value.first}},@{n='Position';e={ $_.'123543204'.value}},@{n='Hired?';e={ [bool]$_.'123099530'.value}} | 
  ForEach-Object {

  $_

} | Tee-Object -Variable Data | Format-Table -AutoSize

$Data | ConvertTo-Csv | Out-File -FilePath ./Submissions.csv
```