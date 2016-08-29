<#
.EXAMPLE
    This example shows how to ensure that the user account CONTOSO\SQLUser
    has not "setupadmin" SQL server role. 
#>

    Configuration Example 
    {
        param(
            [Parameter(Mandatory = $true)]
            [PSCredential]
            $SysadminAccount
        )
        Import-DscResource -ModuleName xSqlServer

        node localhost {
            xSQLServerRole Add_SqlServerRole_SQLAdmin
            {
                DependsOn = '[xSQLServerLogin]Add_SqlServerLogin_SQLAdmin'
                Ensure = 'Absent'
                Name = 'CONTOSO\SQLUser'
                ServerRole = "setupadmin"
                SQLServer = 'SQLServer'
                SQLInstanceName = 'DSC'
                PsDscRunAsCredential = $SysadminAccount
            }
        }
    }
