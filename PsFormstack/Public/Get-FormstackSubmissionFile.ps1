function Get-FormstackSubmissionFile {

  [CmdletBinding(DefaultParameterSetName = 'File')]
  [OutputType([System.IO.FileInfo])]
  param (
    [Parameter(Mandatory)]
    [string]$AccessToken,

    [Parameter(Mandatory)]
    [string]$EncryptionKey,

    [Parameter(Mandatory)]
    [int]$SubmissionId,

    [Parameter(Mandatory)]
    [int]$FieldId,

    [Parameter(Mandatory, ParameterSetName='File')]
    [string]$OutFile,

    [Parameter(Mandatory, ParameterSetName='Directory')]
    [string]$OutDirectory
  )
 
  $Headers = @{
    Authorization="Bearer $AccessToken"
    Accept='application/json'
    'X-FS-ENCRYPTION-PASSWORD'=$EncryptionKey
  }
  
  $Uri = 'https://www.formstack.com/api/v2/download/{0}/{1}' -f $SubmissionId, $FieldId
  Write-Debug "Uri: $Uri"

  try {
    $response = Invoke-WebRequest -Uri $Uri -Headers $Headers
  }
  catch {
    throw "Failed to download file from Formstack: $_"
  }

  # Extract filename from Content-Disposition header
  $contentDisposition = $response.Headers['Content-Disposition']
  if ($contentDisposition -is [array]) {
    $contentDisposition = $contentDisposition[0]
  }

  if ($contentDisposition -match "filename\*?=['""]?(?:UTF-8'')?([^""';\r\n]+)") {
    $FileName = $Matches[1]
  }
  else {
    throw "Could not determine filename from Content-Disposition header."
  }

  Write-Debug "FileName: $FileName"

  if ($PSCmdlet.ParameterSetName -eq 'Directory') {
    if (-not (Test-Path $OutDirectory)) {
      New-Item -ItemType Directory -Path $OutDirectory -Force | Out-Null
    }
    $OutFile = Join-Path $OutDirectory $FileName
  }

  # Save response body
  [System.IO.File]::WriteAllBytes($OutFile, $response.Content)

  # Return file information
  Get-Item $OutFile

}
