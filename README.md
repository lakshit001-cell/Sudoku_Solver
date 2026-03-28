# SAT-Based Sudoku Solver

A robust Sudoku solver that converts grid constraints into **Conjunctive Normal Form (CNF)**, utilizes the **Z3 Theorem Prover** to find solutions, and decodes the results back into a readable grid format. It supports standard $9 \times 9$ grids ($n=3$) and $16 \times 16$ hexadecimal grids ($n=4$).

---


### 1. Compilation
To compile the project and generate the executables (`Sudoku2cnf` and `sol2grid`):
```bash
make all
exit



To run the project, put the input sudoku in the input.txt file and then run in terminal: 
make run

The status of the solution : no solution, unique solution or multiple solution will be shown in the console and if solution exists then the solved sudoku will be shown in the output.txt

To remove the build files:
make remove