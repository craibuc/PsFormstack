function Get-FormstackFormSubmission {

  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [string]$AccessToken,

    [Parameter(Mandatory)]
    [string]$EncryptionKey,

    [Parameter(Mandatory)]
    [int]$FormId
  )

  $Headers = @{
    Authorization="Bearer $AccessToken"
    Accept='application/json'
    'X-FS-ENCRYPTION-PASSWORD'=$EncryptionKey
  }

  $Params = @{
    data = 'true'
    expand_data = 'true'
    per_page = 100
    page = 1
  }

  $Uri = 'https://www.formstack.com/api/v2/form/{0}/submission.json?{1}' -f $FormId, $QS
  Write-Debug "Uri: $Uri"

  $Response = Invoke-WebRequest -Uri $Uri -Method Get -Headers $Headers
  $Content = $Response.Content | ConvertFrom-Json
  $Content.submissions

}