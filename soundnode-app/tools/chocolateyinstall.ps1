$ErrorActionPreference = 'Stop';

$exe          = 'Soundnode.exe'
$iconUrl      = 'https://cdn.rawgit.com/Soundnode/soundnode-app/master/app/soundnode.ico'
$packageName  = 'soundnode-app'
$shortcutPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Soundnode App.lnk"
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$target       = Join-Path $toolsDir $exe
$url          = 'https://soundnode.github.io/soundnode-website/src/downloads/win/Soundnode.zip'
$zipFileList  =  New-Object System.Text.StringBuilder
$zipLogPath   = Join-Path $env:ChocolateyPackageFolder "${packageName}Install.zip.txt"

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  url           = $url

  registryUninstallerKey = 'soundnode-app'
  checksum      = '3b17d7e5c454b711eddc33b802016174'
  checksumType  = 'md5'
}

# Install from zip file
Install-ChocolateyZipPackage @packageArgs

# Don't create shim
New-Item "$target.ignore" -type file -force | Out-Null
$zipFileList.AppendLine("$target.ignore") | Out-Null

# Get icon from repository
Get-ChocolateyWebFile -packageName $packageName -fileFullPath "$toolsDir\soundnode.ico" -url $iconUrl
$zipFileList.AppendLine("$toolsDir\soundnode.ico") | Out-Null

# Create shortcut in Programs Start Menu
Install-ChocolateyShortcut -shortcutFilePath $shortcutPath -targetPath "$target" -workingDirectory "$toolsDir" -iconLocation "$toolsDir\soundnode.ico" -description "Soundcloud desktop client"
$zipFileList.Append("$shortcutPath") | Out-Null

Add-Content $zipLogPath $zipFileList.ToString()
