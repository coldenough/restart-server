<#
v.1.0
#>
$ErrorLogPreference = 'c:\temp\Restart-Server-Log.txt'
New-Item -Path $ErrorLogPreference -ItemType file -Verbose

if (Test-Path $ErrorLogPreference) {
  Write-Output "$ErrorLogPreference file created"
} else {
  Write-Warning "$ErrorLogPreference was not created"
}

function restart-server {
  [CmdletBinding()]
  param (
    [parameter (Mandatory=$true,
                ValueFromPipeline=$true,
                ValueFromPipelineByPropertyName =$true,
                HelpMessage="Computer name to query via WMI") ]
    [Alias('hostname')]
    [string[]]$computerName,
    [parameter()]
    [string]$ErrorLogFilePath = $ErrorLogPreference
  )
  BEGIN {
    $cred = Get-Credential
    #del $ErrorLogFilePath -ErrorAction SilentlyContinue  
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
        Write-Warning "Restarting $computer failed"
        Write-Output "Restarting $computer failed" | Out-File $ErrorLogFilePath
      }
    }
  }
  END{}
} 

Restart-Server -computerName nimbletest,pull01,noname -Verbose