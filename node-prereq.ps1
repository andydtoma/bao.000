function script:exec {
	[CmdletBinding()]

	param(
		[Parameter(Position=0,Mandatory=1)][scriptblock]$cmd,
		[Parameter(Position=1,Mandatory=0)][string]$errorMessage = ("Error executing command: {0}" -f $cmd)
	)

	$allOutput = & $cmd 2>&1

	$allOutput |
	% -Begin {
		$errors = @()
		$cleanOutput = @()
	} -Process {
		if ($_.GetType().Name -eq 'ErrorRecord') {
			$errors += $_
		} else {
			$cleanOutput += $_
		}
	}
	
	$cleanOutput

	if ($lastexitcode -ne 0)
	{
		throw $errors
	}

}

function script:Set-BaoObject {
	[CmdletBinding()]

	param(
		[Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true)]
		[PSObject]$InputObject,

		[Parameter(Position=1, Mandatory=$true)]
		[string]$Property,

		[Parameter(Position=2, Mandatory=$true)]
		$Value,

		[switch]$PassThru
	)

	Process {
		try
		{
			$didIt = $false
			$InputObject.$Property = $Value
			$didIt = $true
		}
		catch {}
		finally
		{
			if (!$didIt -and !($InputObject|Get-Member -Name $Property))
			{
				$InputObject | Add-Member -MemberType NoteProperty -Name $Property -Value $Value
			}
		}
		if ($PassThru) {$InputObject}
	}
}


$BaoStatusString = [environment]::GetEnvironmentVariable('BaoSolutionStatus','User'), [string]::Empty | Select -First 1

try
{
	$BaoStatus = ConvertFrom-Json -InputObject $BaoStatusString 
}
catch {}
finally
{
	if ($BaoStatus -eq $null) {$BaoStatus = New-Object PsCustomObject}
}

$BaoStatus | Set-BaoObject -Property NodePrerequisite -Value 'NotChecked'
[environment]::SetEnvironmentVariable('BaoSolutionStatus', ($BaoStatus | ConvertTo-Json -Compress), 'User')

$IsNode = $false
try
{
	exec { node nodeinstalled.js }
	$IsNode =$true
}
catch
{
	$_.Exception
	'!!!!!!!!!!!!!!!'
}
if (!$IsNode)
{
	"Node is not functional on this system !"
	exit 1
}
try
{
	$NpmVersion = exec { npm -v }
}
catch
{
	$_.Exception
	'!!!!!!!!!!!!!!!'
}
if ( [string]::IsNullOrWhiteSpace($NpmVersion) )
{
	"npm is not available in this context"
	exit 1
}
'npm available, version: {0}' -f $NpmVersion

$BaoStatus | Set-BaoObject -Property NodePrerequisite -Value 'Checked'
[environment]::SetEnvironmentVariable('BaoSolutionStatus', ($BaoStatus | ConvertTo-Json -Compress), 'User')

