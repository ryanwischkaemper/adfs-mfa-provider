Import-Module "$PSScriptRoot\ADFSProviderPublisher\ADFSProviderPublisher.psm1"

try{
	# To turn on Verbose or Debug outputs, change the corresponding preference to "Continue"
    $WarningPreference = "SilentlyContinue"
    $VerbosePreference = "Continue"
    $DebugPreference = "SilentlyContinue"


	# change these values to suit your needs
	$adfsServer = '11.1.11.11'
	$providerName = 'DemoProvider'
	$builtAssemblyPath = [System.IO.Path]::GetFullPath("$PSScriptRoot\..\bin\DemoAuthenticationProvider.dll")

	if(!(Test-Path $builtAssemblyPath)){
		"DemoAuthenticationProvider.dll not found. Try building the project first. Searched for {0}" -f $builtAssemblyPath | Write-Error
		return
	}

	$publicKeyToken = Get-PublicKeyToken $builtAssemblyPath
	$version = Get-AssemblyVersion $builtAssemblyPath
	$fullTypeName = "DemoAuthenticationProvider.DemoAdapter, DemoAuthenticationProvider, Version={0}, Culture=neutral, PublicKeyToken={1}" -f $version, $publicKeyToken
	


	$cred = Get-Credential
	$sourcePath = [System.IO.Path]::GetFullPath("$PSScriptRoot\..\bin")
	$assemblies =  Get-ChildItem "$sourcePath\" -Include *.dll -Recurse | Select-Object -ExpandProperty Name

	$adfsProviderParams = @{
		FullTypeName = $fullTypeName
		ProviderName = $providerName
		ComputerName = $adfsServer
		Credential = $cred
		SourcePath = $sourcePath
		Assemblies = $assemblies
	}

	"Uninstalling {0} on {1}" -f $providerName,$adfsServer | Write-Verbose
	Uninstall-AuthProvider @adfsProviderParams

	"Copying locally built {0} artifacts to {1}" -f $providerName,$adfsServer | Write-Verbose
	Copy-AuthProvider @adfsProviderParams

	"Installing {0} on {1}" -f $providerName,$adfsServer | Write-Verbose
	Install-AuthProvider @adfsProviderParams

	"Finished publishing {0} to {1}" -f $providerName,$adfsServer | Write-Verbose
}catch {
	"An error occurred while publishing {0}. `n{1}` " -f $providerName,$_.Exception.Message | Write-Error
}




