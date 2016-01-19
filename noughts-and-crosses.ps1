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
#>

$comp1 = $false
$comp2 = $false
$player1 = $false
$player2 = $false

$currToken = -1

$insults =  "Hmmm....",
            "I've got you now",
            "Here comes the pain",
            "Game over mate"

$r0c0, $r0c1, $r0c2 = 0, 0, 0
$r1c0, $r1c1, $r1c2 = 0, 0, 0
$r2c0, $r2c1, $r2c2 = 0, 0, 0

$matrix =   ([ref]$r0c0, [ref]$r0c1, [ref]$r0c2),
            ([ref]$r1c0, [ref]$r1c1, [ref]$r1c2),
            ([ref]$r2c0, [ref]$r2c1, [ref]$r2c2)
            
$triplets = ([ref]$r0c0, [ref]$r0c1, [ref]$r0c2),#row 1
            ([ref]$r1c0, [ref]$r1c1, [ref]$r1c2),#row 2
            ([ref]$r2c0, [ref]$r2c1, [ref]$r2c2),#row 3
            ([ref]$r0c0, [ref]$r1c0, [ref]$r2c0),#column 1
            ([ref]$r0c1, [ref]$r1c1, [ref]$r2c1),#column 2
            ([ref]$r0c2, [ref]$r1c2, [ref]$r2c2),#column 3
            ([ref]$r0c0, [ref]$r1c1, [ref]$r2c2),#diagonal 1
            ([ref]$r0c2, [ref]$r1c1, [ref]$r2c0) #diagonal 2

$finished = $false

Function Display-State {
    ":Game State:"
    ForEach ($row in $matrix) { 
        ForEach ($ele in $row) {
            Write-Host "$($ele.value) " -NoNewLine
        }
        Write-Host ""
    }
}

Function Get-Player-Input {
    [int]$row, [int]$col = Read-Host -Prompt "Your turn!" | % {$_.Split(' ')}
    $row--;
    $col--;
    $matrix[$row][$col].value = $global:currToken;    
}

<#
Return codes
1,null - Player 1 won, null
2,null - Player 2/Computer won, null
3,x - Player 1 nearly won, last available place
4,x - Player 2 nearly won, last available place
5,x - Player 2 single, taken place
6,x - Player 1 single, taken place
7,x - Crowded, last available place
8,null - Empty, null
#>
Function Get-Triplet-State ($triplet) {
    $state = [int]$triplet[0].value*1 + [int]$triplet[1].value*10 + [int]$triplet[2].value*100
   
    if ($state -eq 111) {   
        return 1, $null
    } 
    elseif ($state -eq 222) {
        return 2, $null
    }
    elseif ($state -eq 22 -or $state -eq 202 -or $state -eq 220) {
        if ($state -eq 220) { return 3, 0 }
        if ($state -eq 202) { return 3, 1 }
        if ($state -eq  22) { return 3, 2 }
    }    
    elseif ($state -eq 11 -or $state -eq 101 -or $state -eq 110) {
        if ($state -eq 110) { return 4, 0 }
        if ($state -eq 101) { return 4, 1 }
        if ($state -eq  11) { return 4, 2 }
    }
    
    elseif ($state -eq 2 -or $state -eq 20 -or $state -eq 200) {
        if ($state -eq   2) { return 5, 0 }
        if ($state -eq  20) { return 5, 1 }
        if ($state -eq 200) { return 5, 2 }
    }
    elseif ($state -eq 1 -or $state -eq 10 -or $state -eq 100) {
        if ($state -eq   1) { return 6, 0 }
        if ($state -eq  10) { return 6, 1 }
        if ($state -eq 100) { return 6, 2 }
    }
    elseif ($state -eq 222) {
        return 7
    } 
    return 999, $null
}

Function Check-Status ($status) {
    ForEach ($triplet in $triplets) {
        $returnCode = Get-Triplet-State($triplet)
        if ($returnCode[0] -eq $status) {
            if ($status -eq 1) { $global:winner = "You won!" }
            if ($status -eq 2) { $global:winner = "You lost!" }
            $global:finished = $true
        }    
    }
}

<#
Used by computer to determine its next move.
Returns the type of choice, a position in a particular triplet, and where the triplet is in the triplets array
#>
Function Get-Choice {
    $choice = 999
    $currTriplet = 0
    $tripletIndex = 0
    ForEach ($triplet in $triplets) {
        if ((Get-Triplet-State($triplet))[0] -lt $choice) { 
            $choice = (Get-Triplet-State($triplet))[0] 
            $position = (Get-Triplet-State($triplet))[1]
            $tripletIndex = $currTriplet
        }
        $currTriplet++
    }
    return $choice, $position, $tripletIndex
}

Function Computer-Choice {
    Write-Host "Computer's turn" -NoNewLine
    Start-Sleep -m 500
    Write-Host "." -NoNewLine
    Start-Sleep -m 500
    Write-Host "." -NoNewLine
    Start-Sleep -m 500
    Write-Host "." -NoNewLine
    Start-Sleep -m 500
    Write-Host $insults[$(Get-Random -Minimum 0 -Maximum $insults.count)] -NoNewLine
    Start-Sleep -m 1000
    
    # Get choice
    $choice, $position, $tripletIndex = Get-Choice
    
    # If it can win or block player, do it
    if ($choice -le 4) {
        $global:triplets[$tripletIndex][$position].value = $global:currToken
    } 
    
    #Build up a row if there is already one there
    elseif ($choice -le 6) {
         $global:triplets[$tripletIndex][($position + (Get-Random -minimum 1 -maximum 3)) % 3].value = $global:currToken
    
    # Else randomly choose block
    } else {
        $compX = Get-Random -Minimum 0 -Maximum 3
        $compY = Get-Random -Minimum 0 -Maximum 3
        while ($matrix[$compX][$compY].value -ne 0) {
            $compX = Get-Random -Minimum 0 -Maximum 3
            $compY = Get-Random -Minimum 0 -Maximum 3
        }
        $matrix[$compX][$compY].value = $global:currToken
    }
}

Function Play-Intro {
    "*******************"
    "     Welcome to    "
    "                   "    
    "NOUGHTS AND CROSSES"
    "                   "
    "*******************"
    "                   "
    Start-Sleep -m 750
    $global:players = Read-Host -Prompt "How many players?"
    while ($global:players -lt 0 -or $global:players -gt 2) {
        "Please choose a valid number of players"
        $global:players = Read-Host -Prompt "How many players?"
    }
    "!!!"
    Start-Sleep -m 500
}

Function Enable-Players {
    if ($global:players -eq 0) {
        $global:comp1 = $true
        $global:comp2 = $true
    }
    if ($global:players -eq 1) {
        $global:player1 = $true
        $global:comp2 = $true
    }
    if ($global:players -eq 2) {
        $global:player1 = $true
        $global:player2 = $true
    }
}

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