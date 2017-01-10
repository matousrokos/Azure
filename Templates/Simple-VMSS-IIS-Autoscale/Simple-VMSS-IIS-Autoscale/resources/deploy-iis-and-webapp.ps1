param(
    [Parameter(Mandatory = $true)] 
    [string]$FileName,
    [Parameter(Mandatory = $true)] 
    [string]$FileLocation
)

function ExitWithExitCode 
{ 
    param 
    ( 
        $ExitCode 
    ) 

    $host.SetShouldExit($ExitCode) 
    exit 
} 


if ($FileLocation.EndsWith('/'))
{
    $zipfilesource = "$FileLocation$FileName"
}
else
{
    $zipfilesource = "$FileLocation/$FileName"
}

try
{
    Import-Module ServerManager
    Install-WindowsFeature web-server,web-common-http,web-app-dev,web-asp-net45,web-appinit

    $guid=[system.guid]::NewGuid().Guid
    $folder="$env:temp\$guid"
    New-Item -Path $folder -ItemType Directory

    $zipfilelocal = "$folder\$filename"
    $zipextracted="$folder\extracted"

    Invoke-WebRequest $zipfilesource -OutFile $zipfilelocal

    Add-Type -assembly "system.io.compression.filesystem"
    [io.compression.zipfile]::ExtractToDirectory($zipfilelocal, $zipextracted)

    copy-item $zipextracted\* c:\inetpub\wwwroot -Force -Recurse
    ExitWithExitCode -ExitCode 0
}
catch
{
    Write-Error $_
    ExitWithExitCode -ExitCode 1
}