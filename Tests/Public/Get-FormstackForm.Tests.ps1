BeforeAll {

  $ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
  $PublicPath = Join-Path $ProjectDirectory "/PsFormstack/Public/"

  $SUT = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'
  . (Join-Path $PublicPath $SUT)

}

Describe 'Get-FormstackForm' {

  BeforeAll {
      $BaseUri = 'https://www.formstack.com/api/v2'
      $AccessToken = (New-Guid).Guid
  }

    Context "Parameter validation" {

        BeforeAll {
            $Command = Get-Command 'Get-FormstackForm'
        } 

        $Parameters = @(
            @{ParameterName='AccessToken'; Type='[string]'; Mandatory=$true}
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
            Mock Invoke-WebRequest

            Get-FormstackForm -AccessToken $AccessToken
        }

        It 'uses the correct URI' {
            # assert
            Assert-MockCalled -CommandName Invoke-WebRequest -ParameterFilter {
                $Uri -eq "$BaseUri/form.json?folders=false"
            }
        }

        It 'uses the correct Method' {
            # assert
            Assert-MockCalled -CommandName Invoke-WebRequest -ParameterFilter {
                $Method -eq 'Get'
            }
        }

    }

}