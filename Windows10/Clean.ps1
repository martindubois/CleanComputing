
# Author    KMS - Martin Dubois, P. Eng.
# Copyright (C) 2022-2024 KMS
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

function RemoveFile
{
    param ( $File )

    if ( Test-Path $File -PathType Leaf )
    {
        Write-Output( '===== ' + $File + ' : Present =====' )
        Remove-Item $File
    }
    else
    {
        Write-Output( '===== ' + $File + ' : Not present =====' )
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
    if ( "" -eq $Line )
    {}
    elseif ( $Line -match '^#s*' )
    {}
    elseif ( $Line -match '^(?<Action>\d+);(?<Id>\S+)\s*;(?<Name>.+)' )
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
    elseif ( $Line -match '^(?<Action>\d+);(?<Id>.+)' )
    {
        switch ( $Matches.Action )
        {
            9 { RemoveFile -File $Matches.Id }
        }
    }
    else
    {
        Write-Output( 'Error in line' )
        Write-Output( $Line )
    }
}

# ===== End =================================================================

Write-Output OK
