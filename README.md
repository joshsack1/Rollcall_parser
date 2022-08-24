# Rollcall Parser
## Purpose
When building a database of house votes, it is helpful to be able to quickly incorporate the results of a roll call vote

## How to use this tool
Download the roll call vote(s) you want to as a .xml file from the Clerk of the House of Representatives, and save it to the folder you have cloned this project to.

Open the julia REPL with the `julia` command in the terminal.
Enter the package manager in the REPL with the close bracket `]`
Activate the package environment with the `activate .` command
Return to the main REPL with the backspace.
Run the code with
 ```julia
include("parser.jl")
```
When prompted, enter the name of the xml file
