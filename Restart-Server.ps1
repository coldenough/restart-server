<#
v.1.0
#>
$ErrorLogPreference = 'c:\Restart-Server-Log.txt'
Write-Verbose "$ErrorLogPreference file created"

function restart-server {
  [CmdletBinding()]
  param (
    [parameter (Mandatory=$true,
                ValueFromPipeline=$true,
                ValueFromPipelineByPropertyName =$true,
                HelpMessage="Computer name to query via WMI") ]
    [string[]]$computerName,
    [parameter()]
    [string]$ErrorLogFilePath = $ErrorLogPreference
  )
  BEGIN {
    $cred = Get-Credential
    del $ErrorLogFilePath -ErrorAction SilentlyContinue  
  }
  PROCESS {
    foreach ($computer in $computerName) {
      $comp = Get-WmiObject Win32_OperatingSystem -ComputerName $computer `
                                                -Credential $cred
      Write-Verbose "Connecting via WMI to $computer"
      $ret = $comp.Reboot()
      Write-Verbose "Finished with $computer"
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

Restart-Server -computerName nimbletest,pull01 -Verbose