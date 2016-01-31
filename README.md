# Noughts and Crosses
The classic game of noughts and crosses... in Powershell!

## Install & Run

1. Download the zip file or pull from this repository
2. Open a Powershell console with administrative rights (Right click, Run as administrator)
3. Navigate to the directory where the files reside. One way is to use the commands:
  - cd C:\
  - cd Path\To\Files\
4. Run the command: Set-ExecutionPolicy Unrestricted 
5. Type "Y" for the prompt (Please don't be scared by the stern warning thrown. Because this script doesn't have a certificate, you need to change the execution policy otherwise Powershell will be mean and won't run the script. I assure you there isn't an ounce of maliciousness in this script.)
6. Run the command: .\noughts-and-crosses.ps1

## How to play

1. When prompted, choose whether 1 or 2 players will be participating in this splendid game of noughts and crosses (Or perhaps choose **0** if your feeling adventurous).
2. When prompted, choose where to put your 'token' on the board by entering in x,y coordinates, with reference from below:
```
  1    |   | 
    -----------
y 2    |   |  
    -----------
  3    |   |  
     1   2   3
         x
```
3. ???
4. Have fun!

## Testing

Yes this Powershell script actually has unit tests courtesy of [Pester](https://github.com/pester/Pester)! *But why?* While I don't have any plans on continuing development, the tests will help anyone who wants to work with this code in the future. On that note, the tests only run correctly when you run the test file individually, as opposed to calling Invoke-Pester in a Powershell shell in the directory. I believe this is due to a bug on global variable scoping in Pester itself.

## Future development

If someone wipes the cobwebs off this repository some time in the future, a few notes on the code if you want to tinker with it:
- The noughts-and-crosses.ps1 file is the runnable game file which is essentially a loop of game logic.
- The noughts-and-crosses-functions.ps1 file has the core functions.
- The noughts-and-crosses-functions-tests.ps1 file contains, *you guessed it*, tests for the core functions.
- The game doesn't seem to run on anything other than the Powershell IDE console. I believe this is due to either modules not being loaded or how different consoles represent text.
