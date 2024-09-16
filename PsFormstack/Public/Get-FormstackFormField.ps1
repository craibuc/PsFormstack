function Get-FormstackFormField {
  param (
    [Parameter(Mandatory)]
    [string]$AccessToken,

    [Parameter(Mandatory)]
    [int]$FormId
  )
  
  $Uri = 'https://www.formstack.com/api/v2/form/{0}/field.json' -f $FormId
  Write-Debug "Uri: $Uri"

  $Headers = @{
    Authorization="Bearer $AccessToken"
    Accept='application/json'
  }

  $Response = Invoke-WebRequest -Uri $Uri -Method Get -Headers $Headers

  if ($Response.Content) {
    $Content = $Response.Content | ConvertFrom-Json
    $Content
  }

}