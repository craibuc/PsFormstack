function Get-FormstackForm {
  param (
    [Parameter(Mandatory)]
    [string]$AccessToken
  )
  
  $Uri = 'https://www.formstack.com/api/v2/form.json?folders=false'
  $Headers = @{
    Authorization="Bearer $AccessToken"
    Accept='application/json'
  }

  $Response = Invoke-WebRequest -Uri $Uri -Method Get -Headers $Headers
  $Content = $Response.Content | ConvertFrom-Json
  $Content.forms

}