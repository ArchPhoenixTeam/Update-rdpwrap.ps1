$rdpwrappath = "C:\Program Files\RDP Wrapper\rdpwrap.ini"
$termsrvpath = "$env:windir\System32\termsrv.dll"
If (Test-Path -Path $rdpwrappath){

    $Daterdpwrap = (Get-Item $rdpwrappath).LastWriteTime
    Echo $Daterdpwrap
    $Datetermsrv = (Get-Item $termsrvpath).LastWriteTime
    Echo $Datetermsrv

    If ((Get-Date $Datetermsrv) -lt (Get-Date $Daterdpwrap)){
        Start-BitsTransfer -Source "https://raw.githubusercontent.com/ArchPhoenixTeam/Update-rdpwrap.ps1/main/rdpwrap.ini" -Destination $env:temp/rdpwrap.ini
        Echo "dl ok"
        $Daterdpwrap = select-string -Path $env:temp/rdpwrap.ini -Pattern 'Updated=' -Raw
        Echo $Daterdpwrap rdpwrap tmp
        $Datetermsrv = select-string -Path $rdpwrappath -Pattern 'Updated=' -Raw
        Echo $Datetermsrv rdpwrap
        $DateUpdatedrdpwrapTmp = [DateTime]$Daterdpwrap.Substring($Daterdpwrap.IndexOf("=")+1)
        Echo $DateUpdatedrdpwrapTmp
        $DateUpdatedrdpwrap = [DateTime]$Datetermsrv.Substring($Datetermsrv.IndexOf("=")+1)
        Echo $DateUpdatedrdpwrap
        If ((Get-Date $DateUpdatedrdpwrap) -lt (Get-Date $DateUpdatedrdpwrapTmp)){
            Echo Yes
            Stop-Service -Force TermService
            Copy-Item $env:temp/rdpwrap.ini -Destination "$rdpwrappath" -Force
            Start-Service TermService
        }
    }
}
