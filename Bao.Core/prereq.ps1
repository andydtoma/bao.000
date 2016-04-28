if (! [bool]::Parse([environment]::GetEnvironmentVariable('BaoNodePrerequisite','User') ))
{
	'Node Prerequisites Failed'
	exit 1
}

	'Node Prerequisites OK'
