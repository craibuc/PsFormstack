BeforeAll {

  $ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
  $PublicPath = Join-Path $ProjectDirectory "/PsFormstack/Public/"

  $SUT = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'
  . (Join-Path $PublicPath $SUT)

}

Describe 'New-FormstackFormSubmission' {

  BeforeAll {
      $BaseUri = 'https://www.formstack.com/api/v2'
      $AccessToken = (New-Guid).Guid
  }

    Context "Parameter validation" {

        BeforeAll {
            $Command = Get-Command 'New-FormstackFormSubmission'
        } 

        $Parameters = @(
            @{ParameterName='AccessToken'; Type='[string]'; Mandatory=$true}
            @{ParameterName='FormId'; Type='[int]'; Mandatory=$true}
            @{ParameterName='Body'; Type='[object]'; Mandatory=$true}
        )

        Context 'Data type' {

            It "<ParameterName> is a <Type>" -TestCases $Parameters {
                param ($ParameterName, $Type)
                $Command | Should -HaveParameter $ParameterName -Type $Type
            }

        }

        Context "Mandatory" {
            it "<ParameterName> Mandatory is <Mandatory>" -TestCases $Parameters {
                param($ParameterName, $Mandatory)
                
                if ($Mandatory) { $Command | Should -HaveParameter $ParameterName -Mandatory }
                else { $Command | Should -HaveParameter $ParameterName -Not -Mandatory }
            }    
        }

    }

    Context 'Request' {

        BeforeEach {
            $FormId = 123456
            $Body = @{
                "field_159247686" = "craig.buchanan@lorenzbus.com"
            }

            Mock Invoke-WebRequest {
                $Content = @{
                    "id" = "1265951945"
                    "form" = "5601719"
                    "data" = @(
                        @{
                            "field" = "159247686"
                            "value" = "craig.buchanan@lorenzbus.com"
                        }
                    )
                } | ConvertTo-Json
                $Response = New-MockObject -Type  Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject
                $Response | Add-Member -Type NoteProperty -Name 'Content' -Value $Content -Force
                $Response
            }

            New-FormstackFormSubmission -AccessToken $AccessToken -FormId $FormId -Body $Body
        }

        It 'uses the correct URI' {
            # assert
            Assert-MockCalled -CommandName Invoke-WebRequest -ParameterFilter {
                $Uri -eq ("$BaseUri/form/{0}/submission.json" -f $FormId)
            }
        }

        It 'uses the correct Method' {
            # assert
            Assert-MockCalled -CommandName Invoke-WebRequest -ParameterFilter {
                $Method -eq 'Post'
            }
        }

    }

}