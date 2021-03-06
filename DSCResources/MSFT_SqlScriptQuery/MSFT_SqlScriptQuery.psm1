$script:resourceModulePath = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
$script:modulesFolderPath = Join-Path -Path $script:resourceModulePath -ChildPath 'Modules'

$script:localizationModulePath = Join-Path -Path $script:modulesFolderPath -ChildPath 'DscResource.LocalizationHelper'
Import-Module -Name (Join-Path -Path $script:localizationModulePath -ChildPath 'DscResource.LocalizationHelper.psm1')

$script:resourceHelperModulePath = Join-Path -Path $script:modulesFolderPath -ChildPath 'DscResource.Common'
Import-Module -Name (Join-Path -Path $script:resourceHelperModulePath -ChildPath 'DscResource.Common.psm1')

<#
    .SYNOPSIS
        Returns the current state of the SQL Server features.

    .PARAMETER ServerInstance
        The name of an instance of the Database Engine. For a default instance, only specify the computer name. For a named instances,
        use the format ComputerName\InstanceName.

    .PARAMETER GetQuery
        The full query that will perform the Get Action
        Any values returned by the T-SQL queries will also be returned by the cmdlet Get-DscConfiguration through the `GetResult` property.

    .PARAMETER TestQuery
        The full query that will perform the Test Action
        Any script that does not throw an error or returns null is evaluated to true.
        The cmdlet Invoke-Sqlcmd treats T-SQL Print statements as verbose text, and will not cause the test to return false.

    .PARAMETER SetQuery
        The full query that will perform the Set Action

    .PARAMETER Credential
        The credentials to authenticate with, using SQL Authentication. To authenticate using Windows Authentication, assign the credentials
        to the built-in parameter `PsDscRunAsCredential`. If both parameters `Credential` and `PsDscRunAsCredential` are not assigned,
        then SYSTEM account will be used to authenticate using Windows Authentication.

    .PARAMETER Variable
        Specifies, as a string array, a Invoke-Sqlcmd scripting variable for use in the Invoke-Sqlcmd script, and sets a value for the variable.
        Use a Windows PowerShell array to specify multiple variables and their values. For more information how to use this,
        please go to the help documentation for [Invoke-Sqlcmd](https://technet.microsoft.com/en-us/library/mt683370.aspx).

    .PARAMETER QueryTimeout
        Specifies, as an integer, the number of seconds after which the T-SQL script execution will time out.
        In some SQL Server versions there is a bug in Invoke-Sqlcmd where the normal default value 0 (no timeout) is not respected and the default value is incorrectly set to 30 seconds.

    .OUTPUTS
        Hash table containing key 'GetResult' which holds the value of the result from the SQL script that was ran from the parameter 'GetQuery'.
#>
function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ServerInstance,

        [Parameter(Mandatory = $true)]
        [System.String]
        $GetQuery,

        [Parameter(Mandatory = $true)]
        [System.String]
        $TestQuery,

        [Parameter(Mandatory = $true)]
        [System.String]
        $SetQuery,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [Parameter()]
        [System.UInt32]
        $QueryTimeout,

        [Parameter()]
        [System.String[]]
        $Variable
    )

    $invokeParameters = @{
        Query          = $GetQuery
        ServerInstance = $ServerInstance
        Credential     = $Credential
        Variable       = $Variable
        QueryTimeout   = $QueryTimeout
        ErrorAction    = 'Stop'
    }

    $result = Invoke-SqlScript @invokeParameters

    $getResult = Out-String -InputObject $result

    $returnValue = @{
        ServerInstance = [System.String] $ServerInstance
        GetQuery       = [System.String] $GetQuery
        TestQuery      = [System.String] $TestQuery
        SetQuery       = [System.String] $SetQuery
        Credential     = [System.Object] $Credential
        QueryTimeout   = [System.UInt32] $QueryTimeout
        Variable       = [System.String[]] $Variable
        GetResult      = [System.String[]] $getResult
    }

    $returnValue
}

<#
    .SYNOPSIS
        Returns the current state of the SQL Server features.

    .PARAMETER ServerInstance
        The name of an instance of the Database Engine. For a default instance, only specify the computer name. For a named instances,
        use the format ComputerName\InstanceName.

    .PARAMETER GetQuery
        The full query that will perform the Get Action
        Any values returned by the T-SQL queries will also be returned by the cmdlet Get-DscConfiguration through the `GetResult` property.

    .PARAMETER TestQuery
        The full query that will perform the Test Action
        Any script that does not throw an error or returns null is evaluated to true.
        The cmdlet Invoke-Sqlcmd treats T-SQL Print statements as verbose text, and will not cause the test to return false.

    .PARAMETER SetQuery
        The full query that will perform the Set Action

    .PARAMETER Credential
        The credentials to authenticate with, using SQL Authentication. To authenticate using Windows Authentication, assign the credentials
        to the built-in parameter `PsDscRunAsCredential`. If both parameters `Credential` and `PsDscRunAsCredential` are not assigned,
        then SYSTEM account will be used to authenticate using Windows Authentication.

    .PARAMETER QueryTimeout
        Specifies, as an integer, the number of seconds after which the T-SQL script execution will time out.
        In some SQL Server versions there is a bug in Invoke-Sqlcmd where the normal default value 0 (no timeout) is not respected and the default value is incorrectly set to 30 seconds.

    .PARAMETER Variable
        Specifies, as a string array, a Invoke-Sqlcmd scripting variable for use in the Invoke-Sqlcmd script, and sets a value for the variable.
        Use a Windows PowerShell array to specify multiple variables and their values. For more information how to use this,
        please go to the help documentation for [Invoke-Sqlcmd](https://technet.microsoft.com/en-us/library/mt683370.aspx).
#>
function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ServerInstance,

        [Parameter(Mandatory = $true)]
        [System.String]
        $GetQuery,

        [Parameter(Mandatory = $true)]
        [System.String]
        $TestQuery,

        [Parameter(Mandatory = $true)]
        [System.String]
        $SetQuery,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [Parameter()]
        [System.UInt32]
        $QueryTimeout,

        [Parameter()]
        [System.String[]]
        $Variable
    )

    $invokeParameters = @{
        Query          = $SetQuery
        ServerInstance = $ServerInstance
        Credential     = $Credential
        Variable       = $Variable
        QueryTimeout   = $QueryTimeout
        ErrorAction    = 'Stop'
    }

    Invoke-SqlScript @invokeParameters
}

<#
    .SYNOPSIS
        Returns the current state of the SQL Server features.

    .PARAMETER ServerInstance
        The name of an instance of the Database Engine. For a default instance, only specify the computer name. For a named instances,
        use the format ComputerName\InstanceName.

    .PARAMETER GetQuery
        The full query that will perform the Get Action
        Any values returned by the T-SQL queries will also be returned by the cmdlet Get-DscConfiguration through the `GetResult` property.

    .PARAMETER TestQuery
        The full query that will perform the Test Action
        Any script that does not throw an error or returns null is evaluated to true.
        The cmdlet Invoke-Sqlcmd treats T-SQL Print statements as verbose text, and will not cause the test to return false.

    .PARAMETER SetQuery
        The full query that will perform the Set Action

    .PARAMETER Credential
        The credentials to authenticate with, using SQL Authentication. To authenticate using Windows Authentication, assign the credentials
        to the built-in parameter `PsDscRunAsCredential`. If both parameters `Credential` and `PsDscRunAsCredential` are not assigned,
        then SYSTEM account will be used to authenticate using Windows Authentication.

    .PARAMETER QueryTimeout
        Specifies, as an integer, the number of seconds after which the T-SQL script execution will time out.
        In some SQL Server versions there is a bug in Invoke-Sqlcmd where the normal default value 0 (no timeout) is not respected and the default value is incorrectly set to 30 seconds.

    .PARAMETER Variable
        Specifies, as a string array, a Invoke-Sqlcmd scripting variable for use in the Invoke-Sqlcmd script, and sets a value for the variable.
        Use a Windows PowerShell array to specify multiple variables and their values. For more information how to use this,
        please go to the help documentation for [Invoke-Sqlcmd](https://technet.microsoft.com/en-us/library/mt683370.aspx).

#>
function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ServerInstance,

        [Parameter(Mandatory = $true)]
        [System.String]
        $GetQuery,

        [Parameter(Mandatory = $true)]
        [System.String]
        $TestQuery,

        [Parameter(Mandatory = $true)]
        [System.String]
        $SetQuery,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [Parameter()]
        [System.UInt32]
        $QueryTimeout,

        [Parameter()]
        [System.String[]]
        $Variable
    )

    try
    {
        $invokeParameters = @{
            Query          = $TestQuery
            ServerInstance = $ServerInstance
            Credential     = $Credential
            Variable       = $Variable
            QueryTimeout   = $QueryTimeout
            ErrorAction    = 'Stop'
        }

        $result = Invoke-SqlScript @invokeParameters

        if ($null -eq $result)
        {
            return $true
        }
        else
        {
            return $false
        }
    }
    catch [Microsoft.SqlServer.Management.PowerShell.SqlPowerShellSqlExecutionException]
    {
        Write-Verbose $_
        return $false
    }
}

Export-ModuleMember -Function *-TargetResource
