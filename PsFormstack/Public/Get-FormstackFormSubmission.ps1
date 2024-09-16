function Get-FormstackFormSubmission {

  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [string]$AccessToken,

    [Parameter(Mandatory)]
    [string]$EncryptionKey,

    [Parameter(Mandatory)]
    [int]$FormId,

    [Parameter()]
    [object[]]$Filter

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

  $Filter.ForEach({ 
    $Params += $_
  })
  
  do {

    Write-Verbose ("Fetching page {0}..." -f $Params.page)

    # convert to querystring
    $QS = ($Params.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join '&'

    $Uri = 'https://www.formstack.com/api/v2/form/{0}/submission.json?{1}' -f $FormId, $QS
    Write-Debug "Uri: $Uri"

    $Response = Invoke-WebRequest -Uri $Uri -Method Get -Headers $Headers

    if ($Response.Content) {
      $Content = $Response.Content | ConvertFrom-Json
      $Content.submissions  
    }

    $Params.page+=1

  } while ( $Content.submissions.count -gt 0 )

}