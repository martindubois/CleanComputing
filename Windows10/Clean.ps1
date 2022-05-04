
# Author    KMS - Martin Dubois, P. Eng.
# Copyright (C) 2022 KMS
# License   http://www.apache.org/licenses/LICENSE-2.0
# Product   CleanComputing
# File      Windows10/Clean.ps1

Write-Output 'Executing  Windows10/Clean.ps1  ...'

# ===== Reading data ========================================================

$APPX = Get-Content -Path $PSScriptRoot\Clean_APPX.txt

# ===== Functions ===========================================================

function Remove
{
    param ( $Package )

    Remove-AppXPackage -Package $Package
    if ( $? )
    {
        Write-Output 'Removed'
    }
}

function SuggestRemove
{
    param ( $Package )

    Write-Output 'Recommanded: Remove'
    Write-Output '1.     Keep it'
    Write-Output '2.     Exit'
    Write-Output 'Other  Remove it'

    $Cmd = Read-Host 'Your choice '
    switch ( $Cmd )
    {
        1 { Write-Output 'Kept' }
        2 { exit 0 }
        default { Remove -Package $Package }
    }
}

# ===== Executing ===========================================================

ForEach ( $Line in $APPX )
{
    if ( $Line -match '^(?<Action>\d+);(?<Id>\S+)\s*;(?<Name>.+)' )
    {
        $Package = Get-AppXPackage $Matches.Id
        if ($null -ne $Package)
        {
            Write-Output ( '===== ' + $Matches.Name + ' : Installed =====' )
            switch ( $Matches.Action )
            {
                1 { Remove -Package $Package }
                2 { SuggestRemove -Package $Package }
            }
        }
        else
        {
            Write-Output ( '===== ' + $Matches.Name + ' : Not installed =====' )
        }
    }
}


# ===== End =================================================================

Write-Output OK

