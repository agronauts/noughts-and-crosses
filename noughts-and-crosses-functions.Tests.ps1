@"
Test suite for noughtsAndCrosses program. MVC approach is taken so functions dedicated to output are not tested due to how often that are tinkered with.
Due to issues with global scope variables between modules, this should only be run in Windows PowerShell ISE
"@

Import-Module Pester

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
Import-Module $here\$sut


Describe "Get-Triplet-State" {

    BeforeEach {
        Reset-Globals
    }

    It "Reports empty row" {
        $(Get-Triplet-State($triplets[0]))[0] | Should Be 4
        $(Get-Triplet-State($triplets[0]))[1] | Should Be $null
        $(Get-Triplet-State($triplets[0]))[2] | Should Be $null
    }
    
    It "Reports row with one entry from P1" {
        $global:r0c0 = 1
        $(Get-Triplet-State($global:triplets[0]))[0] | Should Be 3
        $(Get-Triplet-State($global:triplets[0]))[1] | Should Be 0
        $(Get-Triplet-State($global:triplets[0]))[2] | Should Be 1
    }
    It "Reports row with one entry from P2" {
        $global:r0c0 = 2
        $(Get-Triplet-State($global:triplets[0]))[0] | Should Be 3
        $(Get-Triplet-State($global:triplets[0]))[1] | Should Be 0
        $(Get-Triplet-State($global:triplets[0]))[2] | Should Be 2
    }
    It "Reports row with two entries from P1" {
        $global:r0c0 = 1
        $global:r0c1 = 1
        $(Get-Triplet-State($global:triplets[0]))[0] | Should Be 2
        $(Get-Triplet-State($global:triplets[0]))[1] | Should Be 2
        $(Get-Triplet-State($global:triplets[0]))[2] | Should Be 1
    }
    It "Reports row with two entries from P2" {
        $global:r0c0 = 2
        $global:r0c1 = 2
        $(Get-Triplet-State($global:triplets[0]))[0] | Should Be 2
        $(Get-Triplet-State($global:triplets[0]))[1] | Should Be 2
        $(Get-Triplet-State($global:triplets[0]))[1] | Should Be 2
    }
    
    It "Reports row with three entries from P2" {
        $global:r0c0 = 2
        $global:r0c1 = 2
        $global:r0c2 = 2
        $(Get-Triplet-State($global:triplets[0]))[0] | Should Be 1
        $(Get-Triplet-State($global:triplets[0]))[1] | Should Be $null
        $(Get-Triplet-State($global:triplets[0]))[2] | Should Be 2
    }
    It "Reports row with three entries from P1" {
        $global:r0c0 = 1
        $global:r0c1 = 1
        $global:r0c2 = 1
        $(Get-Triplet-State($global:triplets[0]))[0] | Should Be 1
        $(Get-Triplet-State($global:triplets[0]))[1] | Should Be $null
        $(Get-Triplet-State($global:triplets[0]))[2] | Should Be 1
    }
    It "Reports full row with mixed entries" {
        $global:r0c0 = 1
        $global:r0c1 = 2
        $global:r0c2 = 1
        $(Get-Triplet-State($global:triplets[0]))[0] | Should Be 6
        $(Get-Triplet-State($global:triplets[0]))[1] | Should Be $null
        $(Get-Triplet-State($global:triplets[0]))[2] | Should Be $null
    }
    
    It "Reports 2-full row with mixed entries" {
        $global:r0c0 = 1
        $global:r0c1 = 0
        $global:r0c2 = 2
        $(Get-Triplet-State($global:triplets[0]))[0] | Should Be 5
        $(Get-Triplet-State($global:triplets[0]))[1] | Should Be 1
        $(Get-Triplet-State($global:triplets[0]))[2] | Should Be $null
    }
    
    
    
}


Describe "Get-Player-Input" {

    BeforeEach {
        Reset-Globals;
        Mock Read-Host {};
    }

    It "Changes board on P1 input" {
        $global:currToken = 1
        Mock Read-Host {return "2 2"}
        Get-Player-Input
        $global:r1c1 | Should Be 1
    }
    It "Changes board on P2 input" {
        $global:currToken = 2
        Mock Read-Host {return "1 2"}
        Get-Player-Input
        $global:r1c0 | Should Be 2
    }
    It "P1 cannot overwrite P2" {
        $global:currToken = 1
        $global:r0c1 = 2
        Mock Read-Host {return "2 1"}
        Get-Player-Input
        $global:r0c1 | Should Be 2
    }
    It "P2 cannot overwrite P1" {
        $global:currToken = 2
        $global:r0c2 = 1
        Mock Read-Host {return "3 1"}
        Get-Player-Input
        $global:r0c2 | Should Be 1
    }
    It "P1 cannot overwrite P1" {
        "Cannot vary inputs for Read-Input" | Should Be "A method for changing Read-Input returns"
    }
    It "P2 cannot overwrite P2" {
        "Cannot vary inputs for Read-Input" | Should Be "A method for changing Read-Input returns"
    }

}

Describe "Check-Win" {
    
    BeforeEach {
        Reset-Globals;
    }

    It "Reports when P1 has won" {
        $global:r0c2 = 1
        $global:r1c2 = 1
        $global:r2c2 = 1
        Check-Win | Should Be 1
    }
    It "Reports when P2 has won" {
        $global:r0c1 = 2
        $global:r1c1 = 2
        $global:r2c1 = 2
        Check-Win | Should Be 2
    }
    It "Reports when no one has won" {
        $global:r0c2 = 1
        $global:r1c2 = 1
        $global:r2c2 = 2
        Check-Win | Should Be $false
    }

}

Describe "Get-Choice" {
    
    BeforeEach {
        Reset-Globals;
    }
    It "Choose to complete row with nothing else around" {
        $global:r2c0 = 1
        $global:r2c1 = 1
        Get-Choice | Should Be 2, 2, 2
    }
    It "Choose to build row with nothing else around" {
        $global:r0c0 = 1 
        $(Get-Choice)[0] | Should Be 3
        $(Get-Choice)[2] | Should Be 0
    }
    
    It "Choose to complete row rather than a mixed one" {
        $global:r0c0 = 1 
        $global:r0c1 = 1
        $global:r1c0 = 2
        $(Get-Choice)[0] | Should Be 2
        $(Get-Choice)[2] | Should Be 0
    }
    It "Choose to complete row rather than anything else" {
        $global:r0c0, $global:r0c1, $global:r0c2 = 1, 2, 1
        $global:r1c0, $global:r1c1, $global:r1c2 = 0, 2, 0
        $global:r2c0, $global:r2c1, $global:r2c2 = 2, 1, 1 
        $(Get-Choice)[0] | Should Be 2
        $(Get-Choice)[1] | Should Be 1
        $(Get-Choice)[2] | Should Be 5
    }

}