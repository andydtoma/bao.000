<#.Synopsis
<!<SnippetShortDescription>!>
.DESCRIPTION
<!<SnippetLongDescription>!>
.EXAMPLE
<!<SnippetExample>!>
.EXAMPLE
<!<SnippetAnotherExample>!>
#>
function Get-BaoService
{
    [CmdletBinding()]
    [OutputType([int])]
    param
    (
        # <!<SnippetParam1Help>!>
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)]
        $parameter1,

        # <!<SnippetParam2Help>!>
        [int]$parameter2)

        Begin
        {
          
        }

        Process
        {
          'coucou bau'
        }

        End
        {

        }
}

Export-ModuleMember -Function Get-BaoService -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
