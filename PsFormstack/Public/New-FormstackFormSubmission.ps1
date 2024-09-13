function New-FormstackFormSubmission {

  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [string]$AccessToken,

    [Parameter(Mandatory)]
    [int]$FormId,

    [Parameter(Mandatory)]
    [object]$Body
  )

  $Headers = @{
    Authorization="Bearer $AccessToken"
    Accept='application/json'
    'Content-Type'='application/json'
  }

  $Uri = 'https://www.formstack.com/api/v2/form/{0}/submission.json' -f $FormId
  Write-Debug "Uri: $Uri"

  $Response = Invoke-WebRequest -Uri $Uri -Method Post -Headers $Headers -Body ($Body | ConvertTo-Json)
  $Content = $Response.Content | ConvertFrom-Json
  $Content

}