function Get-FormstackSubmission {

  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [string]$AccessToken,

    [Parameter(Mandatory)]
    [string]$EncryptionKey,

    [Parameter(Mandatory)]
    [int]$SubmissionId
  )

  $Headers = @{
    Authorization="Bearer $AccessToken"
    Accept='application/json'
    'X-FS-ENCRYPTION-PASSWORD'=$EncryptionKey
  }

  $Uri = 'https://www.formstack.com/api/v2/submission/{0}.json' -f $SubmissionId
  Write-Debug "Uri: $Uri"

  $Response = Invoke-WebRequest -Uri $Uri -Method Get -Headers $Headers

  if ($Response.Content) {
    $Response.Content | ConvertFrom-Json -Depth 10 -AsHashtable
  }

}