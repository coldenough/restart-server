<#
v.1.0
#>
$ErrorLogPreference = 'c:\temp\Restart-Server-Log.txt'
New-Item -Path $ErrorLogPreference -ItemType file -Verbose -ErrorAction SilentlyContinue

if (Test-Path $ErrorLogPreference) {
  Clear-Content $ErrorLogPreference
} else {
  Write-Warning "$ErrorLogPreference does not exist"
  exit
}

$DateShortFormat = Get-Date -Format g

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
      if (Test-Connection $computer -Quiet) {
        Write-Host "$computer is pingable"
        $comp = Get-WmiObject Win32_OperatingSystem -ComputerName $computer `
                                                    -Credential $cred
        Write-Verbose "Connecting via WMI to $computer"
        $ret = $comp.Reboot()
        Write-Verbose "Finished with $computer"
        if ($ret.ReturnValue -eq 0){
          Write-Host "Restarting $computer succeeded."
        } else {
          Write-Warning "Restarting $computer failed"
          Write-Output "Restarting $computer failed" |
              Out-File $ErrorLogFilePath
         }
      } else {
        Write-Warning "Computer $computer is unreachable"
        Write-Output "$DateShortFormat - $computer is unreachable" |
            Out-File $ErrorLogFilePath -Append
      }
    }
  }
  END{}
}

# -----------------------------------------------------------------------------
# Script: Test-IsInRole.ps1
# Author: ed wilson, msft
# Date: 08/24/2013 20:20:25
# Keywords: Security
# comments: Security Requirements
# Windows PowerShell 4.0 Best Practices, Microsoft Press, 2013
# Chapter 4
# -----------------------------------------------------------------------------
Function Test-Isinrole
{
<#
.Synopsis
Tests if the user is in a specific role
.Description
Returns true if a user is the role, false if the user is not in the role        
.Example
Test-Isinrole -role Guest
#>
Param($roleName)
  $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
  $principal = New-Object Security.Principal.WindowsPrincipal $identity
  $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::$roleName)
}

Test-Isinrole -roleName "Administrator" 

Restart-Server -computerName nimbletest,pull01,noname -Verbose