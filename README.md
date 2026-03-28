Readme-
Files-3
Sudoku2cnf, sol2grid, Makefile
File required - input.txt
File output 2- output.txt and second_soln.txt(if exists)
Console Output- Detects number of solution- Multiple , Unique or None.

Note- program works on z3 output format - "s SATISFIABLE/UNSATIFIABLE" as the first line in sat_output.txt.

Command Format-
Run make remove to remove compilation files.
Then to compile- make
To generate output- make run

Command Flow-> Input.txt->Sudoku2nf->problem.cnf->z3->sat_ouput.txt->sol2grid->output.txt


Handling Edge cases-> No solution-> Output.txt contains text "no solution exists" and similar message is displayed in console.

Multiple Solutions-> output.txt contains first solution and second_soln.txt contains the second solution for the sudoku. Message "Multiple solution for the sudoku" is displayed on the console. I have enabled the features by appending  or of  negation of Boolean variables of the first solution and again passing it through the z3. (-a||-b||-c.....)

In case of unique solutions, a message "Unique solution" is shown on the console.



File: Sudokfu2cnf-> Takes and input.txt and generates cnf through various recursive functions for clauses. 

Description: 
Function Get id- takes argument n r c and v calculates variable id for example if n=3 there are 729 atomic such variables and we assign values according to the formula 


Function c1 refers to clause 1 that is atleast one value per square cell. The logical proposition is or of all the variables corresponding to a square cell.(a||B||C||D....)

Function c3 is recursive which ensures that a column has no duplicate values. The logical proposition is -(a&b)= -a||-b by demorgans law.

Function c3o is a recursive functions which uses c3 to go over a complete column, whereas c3 only compares values of 2 rows.

Function c3v-> does the above for each value of v and initiates c3o from column 1.

Now we can ensure column 1 has no duplicates, we need to iterate over all columns- the function allc does that.


Now we have same nomenclature c4, c4o,c4v and allr which ensures that values in a row is not duplicated. 

Function c2-> It ensures that a square cell can hold maximum of one value only. The logical proposition is for a square cell 2 variables corresponding to two different values cannot be true simultaneously-> -(a&b)= -a||-b

Function c2o does that job for all possible combinations of different variables for one square cell.

Function cols and row -> Helper functions to iterate over all square cells and apply proposition 1 and 2, Since both of them have to apply to each square cell in the sudoku.

Function c5-> It ensures that no two square cells within a  sub-block have same value by same logical proposition of  -(a&b)= -a||-b applying to two square cells with a value.

Function c5o -> uses a list of coordinates for a sub-block and applies the c5 proposition to every possible pair of cells within that list for a given value v.

Function getr-> is a recursive helper that collects row coordinates for a sub-block. It builds a list of (row, column) pairs by iterating from a starting row up to the maximum row of that specific block.

Function getall -> uses getr to collect all coordinates in an n by n sub-block. It iterates through the columns and calls getr for each one to create a complete list of cell coordinates for the block.

Function fullrow iterates vertically through the grid to process sub-blocks. It collects the coordinates for a block using getall and then applies the block constraints for every possible value from 1 to sq before moving to the next block n rows down.

Function allblocks is the outermost block function that iterates horizontally. It ensures that every sub-block in the entire sudoku grid is processed by calling fullrow for each starting block column.

Function par-> parses the input string to identify pre-filled clues. If a cell contains a valid digit or hexadecimal character, it calculates the corresponding variable id and adds a unit clause to the accumulator which forces the solver to keep that value.


Redundant clauses-> Each digit appears atleast once in a row and a column as I have already implemented that each row/column has no duplicates and each square cell contains exactly 1 digit, the above clause can be derived from it.


FILE 2 ->sol2grid -> The files takes the z3 output and then converts the variables back to values at respective position in grid and then finally prints it in output.txt (if solution exists)


Function read -> This recursive function reads the entire Z3 output file line by line. It trims the whitespace from each line and concatenates them into one giant string so the program can easily parse every variable assignment at once.

Function hex-> This function maps the raw integer values from the solver back into characters you can actually read. If n=4, it uses "0123456789ABCDEF," and for n=3, it uses "123456789". It is redundant for n=3 but it makes the code consistent for conversion required from int to string.

Function rowreader -> This handles a single row of the final Sudoku grid. It converts the row array into a list, runs every number through the hex function, and prints the finished line to the screen.

Function allreader ->This is a recursive function that walks through the entire 2D matrix. It calls rowreader for every single row until it reaches the end of the grid, effectively displaying the full solution.

Function Decoder-> It takes variables from the z3 output list and then converts it into appropriate row, column and value corresponding to the grid size.







