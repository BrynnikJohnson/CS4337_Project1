# Development Log - CS4337 Project 1

## March 3, 2026, 2:25 PM
### Initial Thoughts
I am starting Project 1 for CS4337, which involves creating a calculator using prefix-notation expressions within racket. The expressions I need to include are addition (+), multiplication (*), division (/), unary negation (-), and history reference ($n). The requirement to maintain a history of results is intriguing. The program also needs to support both an interactive and batch mode (triggered by a -b or --batch flag).

### Plan for This Session
* Initialize Repository
* Implement the Mode Detection
* Create a function to split the input strings into individual tokens
* Start working on the logic for the needed expressions

## March 3, 2026, 3:30 PM
### Reflection
I created the function to split up the string into tokens, and started working on the function to parse the expression. I also implemented the addition and multiplication logic. In my next session I want to implement the unary negation and division logic, as well as, working on the main function loop to make it easier to test. I may also start on the history creation/reference. 

## March 6, 2026, 1:40 PM
### Plan for This Session
* Finish the rest of the calculation logic (unary negation, division, etc.)
* Create the main function loop to display everything correctly and allow multiple inputs until quit
* Work on/finish the history implementation
