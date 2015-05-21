# Comment
function restart-server {
  [CmdletBinding() ]
  param (
    [parameter (Mandatory=$true,
                ValueFromPipeline=$true,
                ValueFromPipelineByPropertyName =$true,
                HelpMessage="Computer name to query via WMI") ]
    [string[]]$computerName= ""
  )
  PROCESS {
    $cred = Get-Credential
    $comp = Get-WmiObject Win32_OperatingSystem -ComputerName $computerName `
                                                -Credential $cred
    $ret = $comp. Reboot()
    if ($ret.ReturnValue -eq 0){
      Write-Host "Restarting $computerName succeeded."
    }
    else {
      Write-Host "Restarting $computerName failed"
    }
  }
} 

Restart-Server