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
  Write-Debug "StatusCode: $( $Response.StatusCode )"

  if ($Response.Content) {
    $Content = $Response.Content | ConvertFrom-Json
    $Content.forms  
  }

}