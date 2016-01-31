# Noughts and Crosses
The classic game of noughts and crosses... in Powershell!

## Install & Run

1. Download the zip file or pull from this repository
2. Open a Powershell console with administrative rights (Right click -> Run as administrator)
3. Navigate to the directory where the files reside. One way is to use the commands:
  - cd C:\
  - cd Path\To\Files\
4. Run the command: Set-ExecutionPolicy Unrestricted 
5. Type "Y" for the prompt (Please don't be scared by the stern warning thrown. Because this script doesn't have a certificate, you need to change the execution policy otherwise Powershell will be mean and won't run the script. I assure you there isn't an ounce of maliciousness in this script.)
6. Run the command: .\noughts-and-crosses.ps1

## Testing

Yes this Powershell script actually has unit tests! *But why?* While I don't have any plans on continuing development, the tests will help anyone who wants to work with this code in the future. On that note, the tests only run correctly when you run the test file individually, as opposed to calling Invoke-Pester. I believe this is due to a bug on global variable scoping in Pester itself. The [Pester](https://github.com/pester/Pester) framework was very easy to use and would recommend it for any Powershell project. 
