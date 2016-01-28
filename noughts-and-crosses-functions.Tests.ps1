@"
Test suite for noughtsAndCrosses program. MVC approach is taken so functions dedicated to output are not tested due to how often that are tinkered with.
Due to issues with global scope variables between modules, this should only be run in Windows PowerShell ISE
"@

Import-Module Pester

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
Import-Module $here\$sut

Function Reset-Globals {

    # Boolean values for deciding what players are playing
    $global:comp1 = $false
    $global:comp2 = $false
    $global:player1 = $false
    $global:player2 = $false

    # The marker to put on the game board, denoting which player's turn it is
    $global:currToken = -1

    # Array of abuse that the computer randomly picks to throw at players
    $global:insults =  "Hmmm....",
                "I've got you now",
                "Here comes the pain",
                "Game over mate"

    # Elements of the game board, will also reset $matrix and $triplets
    $global:r0c0, $global:r0c1, $global:r0c2 = 0, 0, 0
    $global:r1c0, $global:r1c1, $global:r1c2 = 0, 0, 0
    $global:r2c0, $global:r2c1, $global:r2c2 = 0, 0, 0

    # For determining then the current round is done or not
    $global:finished = $false
    
    
}

Describe "Get-Triplet-State" {

    BeforeEach {
        Reset-Globals
    }

    It "Reports empty row" {
        $(Get-Triplet-State($triplets[0]))[0] | Should Be 7
        $(Get-Triplet-State($triplets[0]))[1] | Should Be $null
        $(Get-Triplet-State($triplets[0]))[2] | Should Be $null
    }
    It "Reports row with one entry from P1" {
        $global:r0c0 = 1
        $(Get-Triplet-State($global:triplets[0]))[0] | Should Be 6
        $(Get-Triplet-State($global:triplets[0]))[1] | Should Be 0
    }
    It "Reports row with one entry from P2" {
        $global:r0c0 = 2
        $(Get-Triplet-State($global:triplets[0]))[0] | Should Be 5
        $(Get-Triplet-State($global:triplets[0]))[1] | Should Be 0
    }
    It "Reports row with two entries from P1" {
        $global:r0c0 = 1
        $global:r0c1 = 1
        $(Get-Triplet-State($global:triplets[0]))[0] | Should Be 4
        $(Get-Triplet-State($global:triplets[0]))[1] | Should Be 2
    }
    It "Reports row with two entries from P2" {
        $global:r0c0 = 2
        $global:r0c1 = 2
        $(Get-Triplet-State($global:triplets[0]))[0] | Should Be 3
        $(Get-Triplet-State($global:triplets[0]))[1] | Should Be 2
    }
    It "Reports row with three entries from P2" {
        $global:r0c0 = 2
        $global:r0c1 = 2
        $global:r0c2 = 2
        $(Get-Triplet-State($global:triplets[0]))[0] | Should Be 2
    }
    It "Reports row with three entries from P1" {
        $global:r0c0 = 1
        $global:r0c1 = 1
        $global:r0c2 = 1
        $(Get-Triplet-State($global:triplets[0]))[0] | Should Be 1
    }
    It "Reports full row with mixed entries" {
        $global:r0c0 = 1
        $global:r0c1 = 2
        $global:r0c2 = 1
        $(Get-Triplet-State($global:triplets[0]))[0] | Should Be 8
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