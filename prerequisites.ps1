try
{
 $r = gulp1 -v
}
catch [System.Exception]
{
    Write-Host "<!<SnippetOtherException>!>"
}
finally
{
	'>>>{0}<<<' -f $r
}

