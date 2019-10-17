function Invoke-PaCommitAll {
    [CmdletBinding(SupportsShouldProcess = $True)]
    Param (
        [Parameter(Mandatory = $False)]
        [switch]$Force,

        [Parameter(Mandatory = $False)]
        [switch]$Wait,

        [Parameter(Mandatory = $False)]
        [switch]$ShowProgress
		
        [Parameter(Mandatory = $True, Position = 0)]
        [string]$Name
    )

    BEGIN {
        $VerbosePrefix = "Invoke-PaCommitAll:"
        $Cmd = '<commit-all><shared-policy><device-group><entry name="$Name"/>'
        if ($Force) {
            $Cmd += '<force/>'
        }
        $Cmd += '</device-group></shared-policy></commit-all>&action=all'
    }

    PROCESS {
        $CommandBeingRun = [regex]::split($Cmd, '[<>\/]+') | Select-Object -Unique | Where-Object { $_ -ne "" }
        if ($PSCmdlet.ShouldProcess("Running Operational Command: $CommandBeingRun")) {
            $Response = $global:PaDeviceObject.invokeCommitQuery($Cmd)
            if ($Wait -or $ShowProgress) {
                Get-PaJob -JobId $Response.response.result.job -Wait:$Wait -ShowProgress:$ShowProgress
            }
        }
    }
}
