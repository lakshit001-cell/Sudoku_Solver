# 🧩 SAT-Based Sudoku Solver

A robust Sudoku solver that converts grid constraints into **Conjunctive Normal Form (CNF)**, utilizes the **Z3 Theorem Prover** to find solutions, and decodes the results back into a readable grid format. It supports standard $9 \times 9$ grids ($n = 3$) and $16 \times 16$ hexadecimal grids ($n = 4$).

---

## 🚀 Quick Start

### 1. Compilation
To compile the project and generate the executables (`Sudoku2cnf` and `sol2grid`):
```bash
make all
```

---

### 2. Running the Solver
Ensure your Sudoku puzzle is in `input.txt` (use `.` or `0` for empty cells), then run:
```bash
make run
```

---

### 3. Cleanup
To remove compiled binaries and temporary SAT files:
```bash
make remove
```

---

## 🛠 Technical Implementation

### 🔢 Variable Mapping
The solver maps every possible cell value to a unique boolean variable.

For a grid of size $N \times N$ (where $N = n^2$), the variable ID for a value $v$ at row $r$ and column $c$ is:

$$
ID(r, c, v) = (r - 1) \cdot N^2 + (c - 1) \cdot N + v
$$

---

### 📐 Logical Constraints (CNF Clauses)

The program generates SAT clauses using the following constraints:

- **c1 (Cell Vitality)**  
  Ensures every cell contains **at least one value** (OR of all possibilities)

- **c2 (Cell Uniqueness)**  
  Ensures each cell contains **at most one value**

- **c3 / c4 (Row & Column Constraints)**  
  Ensures each value appears exactly once per row and column using:
  $$
  (\neg a \lor \neg b)
  $$

- **c5 (Sub-block Constraint)**  
  Ensures no duplicate values inside an $n \times n$ sub-grid

- **par (Fixed Clues)**  
  Reads `input.txt` and encodes given values as **unit clauses**

---

### 🔁 Handling Multiple Solutions

If a solution is found, the solver adds a clause to block that solution:

$$
\neg (v_1 \land v_2 \land \dots \land v_k)
\equiv
(\neg v_1 \lor \neg v_2 \lor \dots \lor \neg v_k)
$$

- Re-running Z3 with this clause:
  - If SAT again → **multiple solutions**
  - If UNSAT → **unique solution**

---

## 📂 Project Structure & Flow

### 🔄 Command Flow
```
input.txt → Sudoku2cnf → problem.cnf → Z3 → sat_output.txt → sol2grid → output.txt
```

### 📁 Components

- **Sudoku2cnf** → Converts Sudoku constraints into `problem.cnf`  
- **sol2grid** → Converts SAT output into readable Sudoku grid  
- **Makefile** → Automates compilation and execution  

---

## 📊 Input & Output

### 📥 Input
- `input.txt` → Sudoku grid (supports `0-9` and `A-F`)

### 📤 Output
- `output.txt` → First valid solution  
- `second_soln.txt` → Second solution (only if multiple solutions exist)

---

## 📢 Console Indicators

- **Unique solution** → Exactly one solution exists  
- **Multiple solution for the sudoku** → More than one solution exists  
- **No solution exists** → Puzzle is unsatisfiable  