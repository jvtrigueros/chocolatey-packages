$ErrorActionPreference = 'Stop';

$exe          = 'Soundnode.exe'
$iconUrl      = 'https://cdn.rawgit.com/Soundnode/soundnode-app/master/app/soundnode.ico'
$packageName  = 'soundnode-app'
$shortcutPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Soundnode App.lnk"
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$target       = Join-Path $toolsDir $exe
$url          = 'http://www.soundnodeapp.com/downloads/win/Soundnode-App.zip'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  url           = $url

  registryUninstallerKey = 'soundnode-app'
  checksum      = '3873B3DD5175421BFA4FFDE0D1779EDD'
  checksumType  = 'md5'
}

# Install from zip file
Install-ChocolateyZipPackage @packageArgs

# Don't create shim
New-Item "$target.ignore" -type file -force | Out-Null

# Get icon from repository
Get-ChocolateyWebFile -packgeName $packageName -fileFullPath "$toolsDir\soundnode.ico" -url $iconUrl

# Create shortcut in Programs Start Menu
Install-ChocolateyShortcut -shortcutFilePath $shortcutPath -targetPath "$target" -workingDirectory "$toolsDir" -iconLocation "$toolsDir\soundnode.ico" -description "Soundcloud desktop client"
