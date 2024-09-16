function New-FormstackFormSubmission {

  [CmdletBinding(SupportsShouldProcess)]
  param (
    [Parameter(Mandatory)]
    [string]$AccessToken,

    [Parameter(Mandatory)]
    [int]$FormId,

    [Parameter(Mandatory,ValueFromPipeline)]
    [object]$Body
  )

  $Headers = @{
    Authorization="Bearer $AccessToken"
    Accept='application/json'
    'Content-Type'='application/json'
  }

  Write-Debug ($Body | ConvertTo-Json)
  
  $Uri = 'https://www.formstack.com/api/v2/form/{0}/submission.json' -f $FormId
  Write-Debug "Uri: $Uri"

  if ($PSCmdlet.ShouldProcess("/form/$FormId/submission.json", "POST")) {

    $Response = Invoke-WebRequest -Uri $Uri -Method Post -Headers $Headers -Body ($Body | ConvertTo-Json)

    if ($Response.Content) {
      $Content = $Response.Content | ConvertFrom-Json
      $Content  
    }

  }

}