<#
Noughts and Crosses!
Author: Patrick Nicholls
Date: 8/12/15
TODO:
    -AI:  rule for split
    -Abusive computer: Pull insults from a website
    -Intro screen: Choose 2P or 1P, computer difficulty
    -Larger board
    -Draw
    -Outline of board; Borders around the boxes
    -End game when full
#>

$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module $ScriptDir\NoughtsAndCrosses-Functions.ps1


Play-Intro
Enable-Players

while (!$finished) {

    if ($player1) {  
        cls
        $global:currToken = 1
        Display-State
        Get-Player-Input
        Check-Status 1 #Player 1 won
        if ($finished) { break }
    }
    
    if ($player2) {
        cls
        $global:currToken = 2
        Display-State
        Get-Player-Input
        Check-Status 2 #Player 2 won
        if ($finished) { break }    
    }
    
    
    if ($comp1) {
        cls
        $global:currToken = 1
        Display-State
        Computer-Choice
        Check-Status 1 #Computer won
    }
    
    if ($comp2) {
        cls
        $global:currToken = 2
        Display-State
        Computer-Choice
        Check-Status 2 #Computer won        
    }
}
cls
Display-State
"$winner"