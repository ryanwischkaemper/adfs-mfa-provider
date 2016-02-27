[cmdletbinding()]
param([string]$targetdir)

# First create all the strong key file
& 'C:\Program Files (x86)\Microsoft SDKs\Windows\v8.1A\bin\NETFX 4.5.1 Tools\sn.exe' -k "$($targetdir)DemoAuthenticationProvider.snk" > $null
& 'C:\Program Files (x86)\Microsoft SDKs\Windows\v8.1A\bin\NETFX 4.5.1 Tools\sn.exe' -k "$($targetdir)Twilio.Api.snk" > $null
& 'C:\Program Files (x86)\Microsoft SDKs\Windows\v8.1A\bin\NETFX 4.5.1 Tools\sn.exe' -k "$($targetdir)RestSharp.snk" > $null


# decompile the DLLS to IL so we can add strong names
& 'C:\Program Files (x86)\Microsoft SDKs\Windows\v8.1A\bin\NETFX 4.5.1 Tools\ildasm.exe' /all /out="$($targetdir)DemoAuthenticationProvider.il" "$($targetdir)DemoAuthenticationProvider.dll" > $null
& 'C:\Program Files (x86)\Microsoft SDKs\Windows\v8.1A\bin\NETFX 4.5.1 Tools\ildasm.exe' /all /out="$($targetdir)Twilio.Api.il" "$($targetdir)Twilio.Api.dll" > $null
& 'C:\Program Files (x86)\Microsoft SDKs\Windows\v8.1A\bin\NETFX 4.5.1 Tools\ildasm.exe' /all /out="$($targetdir)RestSharp.il" "$($targetdir)RestSharp.dll" > $null

# delete the dll files so we can compile them
Remove-Item -Path "$($targetdir)Twilio.Api.dll"
Remove-Item -Path "$($targetdir)RestSharp.dll"

#recompile the dlls with strong names
& 'C:\Windows\Microsoft.NET\Framework\v4.0.30319\ilasm.exe' /dll /Resource="$($targetdir)DemoAuthenticationProvider.res" /out="$($targetdir)DemoAuthenticationProvider.dll" /Key="$($targetdir)DemoAuthenticationProvider.snk" "$($targetdir)DemoAuthenticationProvider.il" > $null
& 'C:\Windows\Microsoft.NET\Framework\v4.0.30319\ilasm.exe' /dll /Resource="$($targetdir)Twilio.Api.res" /out="$($targetdir)Twilio.Api.dll" /Key="$($targetdir)Twilio.Api.snk" "$($targetdir)Twilio.Api.il" > $null
& 'C:\Windows\Microsoft.NET\Framework\v4.0.30319\ilasm.exe' /dll /Resource="$($targetdir)RestSharp.res" /out="$($targetdir)RestSharp.dll" /Key="$($targetdir)RestSharp.snk" "$($targetdir)RestSharp.il" > $null

#cleanup
Remove-Item -Path "$($targetdir)*" -Exclude *.dll,*.Resources.resources -Recurse -Force



