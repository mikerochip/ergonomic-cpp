if ( -not (Test-Path -Path "build/bin") )
{
    & $PSScriptRoot/build.ps1
}

Set-Location "$PSScriptRoot/build/bin"
Start-Process -FilePath CMakeTest
