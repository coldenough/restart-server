function restart-server {
  [CmdletBinding() ]
  param (
    [parameter (ValueFromPipeline=$true ,
    ValueFromPipelineByPropertyName =$true) ]
    [string ]$computer= ""
  )
  PROCESS {
    $cred = Get-Credential
    $comp = Get-WmiObject Win32_OperatingSystem -ComputerName $computer 
                                                -Credential $cred
    $ret = $comp. Reboot()
    if ($ret.ReturnValue -eq 0){
      Write-Host "Restarting $computer succeeded."
    }
    else {
      Write-Host "Restarting $computer failed"
    }
  }
} 
