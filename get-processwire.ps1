# This script does the following...

#1. Downloads latest processwire code straight from github.
#2. Copies the Dev branch into the src folder
#3. Deletes the .git folder 

if (!(Test-Path src -PathType Container)) {
    new-item -itemtype Directory -force -path src
}
git clone https://github.com/processwire/processwire.git;
cd processwire;
git checkout dev;
cd ..;

Write-Host "Moving processwire core files to src folder"
Get-childitem -Path processwire -Exclude ".git"  | Move-Item -Destination src;


Write-Host "Downloading Foundation 6 profile"
git clone https://github.com/flydev-fr/site-fdn6.git; #foundation 6 profile
cd site-fdn6;
git checkout precompiled;
cd ..;

Write-Host "Moving foundation 6 profile to src folder"
Get-childitem -Path site-fdn6 -Exclude ".git"  | Move-Item -Destination "src/site-foundation6";

Remove-Item -Path processwire -Recurse -Force
Remove-Item -Path site-fdn6 -Recurse -Force
