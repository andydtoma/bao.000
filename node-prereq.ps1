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


#$env:BaoNodePrerequisite = $false
[environment]::SetEnvironmentVariable('BaoNodePrerequisite',$false,'User')
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

#$env:BaoNodePrerequisite
[environment]::SetEnvironmentVariable('BaoNodePrerequisite',$true, 'User')
