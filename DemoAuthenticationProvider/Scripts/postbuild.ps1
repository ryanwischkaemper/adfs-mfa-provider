[Cmdletbinding()]
param(
	[string]$targetdir,
	[string]$providerAssemblyName
)

function Format-FileExtension{
    [cmdletbinding()]
    param(
		[Parameter(Position=1,Mandatory=$true)]
		[string]$FilePath,
		[Parameter(Position=2,Mandatory=$true)]
		[string]$NewExtension
    )
    
    $result = '{0}\{1}.{2}' -f [System.IO.Directory]::GetParent($FilePath).FullName, [System.IO.Path]::GetFileNameWithoutExtension($FilePath), $NewExtension
    $result 
}

function Format-DllPaths{
	[Cmdletbinding()]
	param(
		[Parameter(Position=0,Mandatory=$true, ValueFromPipeline=$true)]
		[string[]]$DllPaths
	)

	process {
		foreach($dllpath in $DllPaths){
			$obj = New-Object -TypeName PSObject
			$obj | Add-Member -MemberType NoteProperty -Name DllPath -Value $dllpath
			$obj | Add-Member -MemberType NoteProperty -Name SnkPath -Value (Format-FileExtension $dllpath 'snk')
			$obj | Add-Member -MemberType NoteProperty -Name IlPath -Value (Format-FileExtension $dllpath 'il')
			$obj | Add-Member -MemberType NoteProperty -Name ResPath -Value (Format-FileExtension $dllpath 'res')

			Write-Output $obj
		}
	}
}

function Invoke-Sn{
	<#
		.SYNOPSIS
		Create strong key file(s) for assembly(s)
	#>
	[Cmdletbinding()]
	param(
		[Parameter(Mandatory=$true, ValueFromPipeline=$true)]
		[psobject[]]$Assemblies
	)

    begin { $snTool = 'C:\Program Files (x86)\Microsoft SDKs\Windows\v8.1A\bin\NETFX 4.5.1 Tools\sn.exe' }

	process {
		foreach($assembly in $Assemblies){
			& $snTool -k "$($assembly.SnkPath)" > $null
			Write-Output $assembly
		}
	}
}

function Invoke-Ildasm{
	<#
		.SYNOPSIS
		Decompile the assembly(s) to IL so we can add strong names
	#>
	[Cmdletbinding()]
	param(
		[Parameter(Mandatory=$true, ValueFromPipeline=$true)]
		[psobject[]]$Assemblies
	)

	begin { $ildasmTool = 'C:\Program Files (x86)\Microsoft SDKs\Windows\v8.1A\bin\NETFX 4.5.1 Tools\ildasm.exe' }

	process {
		foreach($assembly in $Assemblies){
			& $ildasmTool /all /out="$($assembly.IlPath)" "$($assembly.DllPath)" > $null
			Write-Output $assembly
		}
	}
}

function Invoke-Ilasm{
	<#
		.SYNOPSIS
		Recompile the assembly(s) with strong names
	#>
	[Cmdletbinding()]
	param(
		[Parameter(Mandatory=$true, ValueFromPipeline=$true)]
		[psobject[]]$Assemblies
	)

	begin { $ilasmTool = 'C:\Windows\Microsoft.NET\Framework\v4.0.30319\ilasm.exe' }

	process {
		foreach($assembly in $Assemblies){
			& $ildasmTool /all /out="$($assembly.IlPath)" "$($assembly.DllPath)" > $null
			& $ilasmTool /dll /Resource="$($assembly.ResPath)" /out="$($assembly.DllPath)" /Key="$($assembly.SnkPath)" "$($assembly.IlPath)" > $null
			Write-Output $assembly
		}
	}
}

# Dissasemble, sign, and recompile all 3rd party assemblies
Get-Childitem -Path $targetdir -Include *.dll -Recurse | Where-Object {	$_.Name -ne "$($providerAssemblyName).dll"} | 
Select-Object -ExpandProperty FullName | Format-DllPaths | Invoke-Sn | Invoke-Ildasm | Invoke-Ilasm > $null 

#cleanup
Remove-Item -Path "$($targetdir)*" -Exclude *.dll,*.Resources.resources -Recurse -Force > $null





