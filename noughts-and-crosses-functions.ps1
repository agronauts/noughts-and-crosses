# Boolean values for deciding what players are playing
$comp1 = $false
$comp2 = $false
$player1 = $false
$player2 = $false

# The marker to put on the game board, denoting which player's turn it is
$currToken = -1

$tokens = @{0 = ' '; 1 = 'X'; 2 = 'O'}
            

# Array of abuse that the computer randomly picks to throw at players
$insults =  "Hmmm....",
            "I've got you now",
            "Here comes the pain",
            "Game over mate"

# Elements of the game board
$r0c0, $r0c1, $r0c2 = 0, 0, 0
$r1c0, $r1c1, $r1c2 = 0, 0, 0
$r2c0, $r2c1, $r2c2 = 0, 0, 0

# For refering to the board elements easily using 2d-array, index notation
$matrix =   ([ref]$r0c0, [ref]$r0c1, [ref]$r0c2),
            ([ref]$r1c0, [ref]$r1c1, [ref]$r1c2),
            ([ref]$r2c0, [ref]$r2c1, [ref]$r2c2)
            
# Noughts and crosses is determined by the state of the successive line of elements on the board. Therefore this 2D array of triplets makes checking the game state easy.
$triplets = ([ref]$r0c0, [ref]$r0c1, [ref]$r0c2),#row 1
            ([ref]$r1c0, [ref]$r1c1, [ref]$r1c2),#row 2
            ([ref]$r2c0, [ref]$r2c1, [ref]$r2c2),#row 3
            ([ref]$r0c0, [ref]$r1c0, [ref]$r2c0),#column 1
            ([ref]$r0c1, [ref]$r1c1, [ref]$r2c1),#column 2
            ([ref]$r0c2, [ref]$r1c2, [ref]$r2c2),#column 3
            ([ref]$r0c0, [ref]$r1c1, [ref]$r2c2),#diagonal 1
            ([ref]$r0c2, [ref]$r1c1, [ref]$r2c0) #diagonal 2

Function Reset-Globals {

    # Boolean values for deciding what players are playing
    $global:comp1 = $global:false
    $global:comp2 = $global:false
    $global:player1 = $global:false
    $global:player2 = $global:false

    # The marker to put on the game board, denoting which player's turn it is
    $global:currToken = -1

    $global:tokens = @{0 = ' '; 1 = 'X'; 2 = 'O'}
            

    # Array of abuse that the computer randomly picks to throw at players
    $global:insults =  "Hmmm....",
                "I've got you now",
                "Here comes the pain",
                "Game over mate"

    # Elements of the game board
    $global:r0c0, $global:r0c1, $global:r0c2 = 0, 0, 0
    $global:r1c0, $global:r1c1, $global:r1c2 = 0, 0, 0
    $global:r2c0, $global:r2c1, $global:r2c2 = 0, 0, 0

}

# Displays the game board in its current state
Function Display-State {
    ":Game State:"
    $rowNum = 0
    ForEach ($row in $matrix) {
        $eleNum = 0;
        ForEach ($ele in $row) {
            Write-Host $global:tokens.get_Item($ele.value) -NoNewLine
            if ($eleNum -le 1) {
                $eleNum++;
                Write-Host " | " -NoNewLine
            }
        }
        if ($rowNum -le 1) {
            $rowNum++;
            Write-Host "" 
            Write-Host "- - - - -"
        }
    }
    Write-Host ""
}

# Prompts the player for their input and sets the element they specify (Using a two-point coordinate) to their token 
Function Get-Player-Input {
    [int]$col, [int]$row = Read-Host -Prompt "Your turn!" | % {$_.Split(' ')} -ErrorAction 'silentlycontinue' 
    $row = 3 - $row;
    $col--;
    while ($row -lt 0 -or $row -gt 2 -or $col -lt 0 -or $col -gt 2 -or $global:matrix[$row][$col].value -ne 0) {
        [int]$col, [int]$row = Read-Host -Prompt "Choose valid coordinates" | % {$_.Split(' ')} -ErrorAction 'silentlycontinue'
        $row = 3 - $row;
        $col--;
    }
    $global:matrix[$row][$col].value = $global:currToken;
}

<#
Takes a triplet and returns an three-tuple of integers denoting the state of the triplet.
The first integer represents the type of state of the tuple, while the second denotes a position in the tuple from the top-left, while the third denotes the player implicated.
The relevance of the second and third integer depends on the first and hence can be null.
Below is an explaination for the return codes. They are ordered by the first integer representing a descending level of importance.

Return codes
1,null,y - Player y won
2,x,y - Player y nearly won, last available place is at x
3,x,y - Player y has a single token placed, place taken by token is at x
4,null,null - Triplet is empty
5,x,null - Tokens from multiple players have been placed, last available place is at x. Player is not applicable
6,null,null - Triplet is totally full with tokens from mixed players

#>
Function Get-Triplet-State ($triplet) {
    # Ugly base-10 code generation, please someone think of a more elegant solution. Note that value at each element is 1 (Player 1) or 2 (Player 2)
    $state = [int]$triplet[0].value*1 + [int]$triplet[1].value*10 + [int]$triplet[2].value*100

    if ((111, 222) -contains $state) {   
        if ($state -eq 111) { return 1, $null, 1 } 
        if ($state -eq 222) { return 1, $null, 2 }
    } 
    elseif ((22, 202, 220, 11, 101, 110) -contains $state) {
        if ($state -eq 220) { return 2, 0, 2 }
        if ($state -eq 202) { return 2, 1, 2 }
        if ($state -eq  22) { return 2, 2, 2 }
        if ($state -eq 110) { return 2, 0, 1 }
        if ($state -eq 101) { return 2, 1, 1 }
        if ($state -eq  11) { return 2, 2, 1 }
    }
    elseif ((2, 20, 200, 1, 10, 100) -contains $state) {
        if ($state -eq   2) { return 3, 0, 2 }
        if ($state -eq  20) { return 3, 1, 2 }
        if ($state -eq 200) { return 3, 2, 2 }
        if ($state -eq   1) { return 3, 0, 1 }
        if ($state -eq  10) { return 3, 1, 1 }
        if ($state -eq 100) { return 3, 2, 1 }
    }   
    elseif ($state -eq 0) {
        return 4, $null, $null
    }    
    elseif ((12,21,102,201,120,210) -contains $state) {
        if ($state -eq 120) { return 5, 0, $null }
        if ($state -eq 210) { return 5, 0, $null }
        if ($state -eq 102) { return 5, 1, $null }
        if ($state -eq 201) { return 5, 1, $null }
        if ($state -eq  12) { return 5, 2, $null }
        if ($state -eq  21) { return 5, 2, $null }        
    }   
    elseif ($state -ne 0) {
        return 6, $null, $null
    } 
}

<#
Iterates through all triplets to see if someone has won, returning the player code of the winner.
#>
Function Check-Win {
    $full = $true
    ForEach ($triplet in $global:triplets) {
        $someoneWon, $null, $winner = Get-Triplet-State($triplet)
        if ($someoneWon -eq 1) {
            return $winner
        }
        elseif ($someoneWon -ne 6) {
            $full = $false
        }    
    }
    if ($full) { return 3 }
    return $false
}

<#
Used by computer to determine its next move.
Returns the type of choice, a position in a particular triplet, and where the triplet is in the triplets array
#>
Function Get-Choice {
    $choice = 999
    $currTriplet = 0
    $tripletIndex = 0
    ForEach ($triplet in $global:triplets) {
        $returnCode, $null, $player = Get-Triplet-State($triplet)
        if ($returnCode -lt $choice) { 
            $choice = (Get-Triplet-State($triplet))[0] 
            $position = (Get-Triplet-State($triplet))[1]
            $tripletIndex = $currTriplet
        }
        elseif ($returnCode -eq 3 -and $player -eq $currToken) { 
            $choice = (Get-Triplet-State($triplet))[0] 
            $position = (Get-Triplet-State($triplet))[1]
            $tripletIndex = $currTriplet
        }
        $currTriplet++
    }
        
    #Build up a row if there is already one there
    if ($choice -eq 3) {
        $position = ($position + (Get-Random -minimum 1 -maximum 3)) % 3
    }
    
    # Else randomly choose block
    elseif ($choice -ge 4) {
        $position = Get-Random -Minimum 0 -Maximum 3
        $tripletIndex = Get-Random -Minimum 0 -Maximum 9
        while ($matrix[$compX][$compY].value -ne 0) {
            $position = Get-Random -Minimum 0 -Maximum 3
            $tripletIndex = Get-Random -Minimum 0 -Maximum 9
        }
    }

    return $choice, $position, $tripletIndex
}

<#
Gets the computer's move and describes how the computer will execute each type of move.
#> 
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

    # Execute choice
    $global:triplets[$tripletIndex][$position].value = $global:currToken
    
}

<#
Play Hi-res intro graphics and gets settings for the game.
#>
Function Play-Intro {
    Write-Host  "*******************"
                "     Welcome to    "
                "                   "    
                "NOUGHTS AND CROSSES"
                "                   "
                "*******************"
                "                   "
    Start-Sleep -m 750
    $global:players = Read-Host -Prompt "How many players?"
    while ($global:players -lt 0 -or $global:players -gt 2) {
        Write-Host "Please choose a valid number of players"
        $global:players = Read-Host -Prompt "How many players?"
    }
    Write-Host "!!!"
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