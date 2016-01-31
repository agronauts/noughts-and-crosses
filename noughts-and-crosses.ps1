<#
Noughts and Crosses!
Author: Patrick Nicholls
Date: 8/12/15
TODO:
    -AI:  rule for split
    -More abusive computer: Pull insults from a website
    -Larger board
    -Draw
    -Outline of board; Borders around the boxes
    -Better input
    -Fix P1 Win only after player 2 check
    -Prompt user for incorrect entry
    -Streamline output
        -Color output
#>

$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module $ScriptDir\noughts-and-crosses-functions.ps1

Reset-Globals
Play-Intro
Enable-Players

$winner = $false
while ($true) {

    if ($player1) {  
        cls
        $global:currToken = 1
        Display-State
        Get-Player-Input
        $winner = Check-win
        if ($winner) { break }
    }
    
    if ($player2) {
        cls
        $global:currToken = 2
        Display-State
        Get-Player-Input
        $winner = Check-win
        if ($winner) { break }
    }
    
    
    if ($comp1) {
        cls
        $global:currToken = 1
        Display-State
        Computer-Choice
        $winner = Check-win
        if ($winner) { break }
    }
    
    if ($comp2) {
        cls
        $global:currToken = 2
        Display-State
        Computer-Choice
        $winner = Check-win
        if ($winner) { break }
    }
}
cls
Display-State
if ($winner -eq 1) {
    if ($player1) { "You won!"}
    if ($comp1) { "Computer 1 won!"}
}
elseif ($winner -eq 2) {
    if ($player2) {"Player 2 won!"}
    if ($comp2) {"Computer 2 won!"}
}
else { "Tie!" }