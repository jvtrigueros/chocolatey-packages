$ErrorActionPreference = 'Stop';

$packageName = 'soundnode-app'
Uninstall-ChocolateyZipPackage -packageName $packageName -zipFileName "${packageName}Install.zip"
