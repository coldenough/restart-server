function restart-server {
  [CmdletBinding()]
  param (
    [parameter (Mandatory=$true,
                ValueFromPipeline=$true,
                ValueFromPipelineByPropertyName =$true,
                HelpMessage="Computer name to query via WMI") ]
    [string[]]$computerName= ""
  )
  BEGIN {
    $cred = Get-Credential  
  }
  PROCESS {
    foreach ($computer in $computerName) {
      $comp = Get-WmiObject Win32_OperatingSystem -ComputerName $computer `
                                                -Credential $cred
      $ret = $comp.Reboot()
      if ($ret.ReturnValue -eq 0){
        Write-Host "Restarting $computer succeeded."
      }
      else {
      Write-Host "Restarting $computer failed"
      }
    }
  }
  END{}
} 

Restart-Server -computerName nimbletest,pull01