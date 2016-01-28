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

# For determining then the current round is done or not
$finished = $false


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
4,x - Player 1 has a single token placed, place taken by token is at x
5,x,null - Tokens from multiple players have been placed, last available place is at x. Player is not applicable
6,null,null - Triplet is totally full with tokens from mixed players
7,null,null - Triplet is empty
#>
Function Get-Triplet-State ($triplet) {
    # Ugly base-10 code generation, please someone think of a more elegant solution. Note that value at each element is 1 (Player 1) or 2 (Player 2)
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
    elseif ($state -eq 12 -or $state -eq 21 -or $state -eq 102 -or$state -eq 201 -or $state -eq 120 -or $state -eq 210) {
        if ($state -eq 120) { return 7, 0 }
        if ($state -eq 210) { return 7, 0 }
        if ($state -eq 102) { return 7, 1 }
        if ($state -eq 201) { return 7, 1 }
        if ($state -eq  12) { return 7, 2 }
        if ($state -eq  21) { return 7, 2 }        
    }   
    elseif ($state -ne 0) {
        return 8, $null
    } 
    elseif ($state -eq 0) {
        return 7, $null, $null
    } 

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
    
    # If the game has already been won, don't do anything
    if ($choice -le 2) {
        
    }
    
    # If it can win or block player, do it
    elseif ($choice -le 4) {
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