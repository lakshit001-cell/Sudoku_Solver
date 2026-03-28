all:
	ocamlc -o sudoku2cnf str.cma sudoku2cnf.ml
	ocamlc -o sol2grid str.cma sol2grid.ml

run:
	./sudoku2cnf input.txt > problem.cnf
	z3 -dimacs problem.cnf >sat_output.txt
	./sol2grid sat_output.txt >output.txt
	@if grep -q "s UNSATISFIABLE" sat_output.txt; then \
		echo "NO SOLUTION FOR THE SUDOKU";\
	else \
		cat adcl.txt >> problem.cnf;\
		z3 -dimacs problem.cnf > sat_output2.txt;\
		if grep -q "s SATISFIABLE" sat_output2.txt; then \
			echo "Multiple solutions for the sudoku";\
			./sol2grid sat_output2.txt > second_soln.txt;\
		else \
			echo "unique solution";\
		fi;\
	fi



remove :
	rm -f sol2grid sudoku2cnf sat_output.txt output.txt *.cmo *.cmi sat_output2.txt adcl.txt problem.cnf second_soln.txt