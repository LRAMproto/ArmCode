COVERAGE = -fprofile-arcs -ftest-coverage

default:

# Test Build
# Note that you will have to run clean before re-compiling.
coverage_transition:
	g++ -c $(COVERAGE) -Wall src/Transition.cpp -o obj/Transition.o
coverage_statemachine:
	g++ -c $(COVERAGE) -Wall src/StateMachine.cpp -o obj/StateMachine.o
compile_main:
	g++ -c $(COVERAGE) -Wall src/test1.cpp -o obj/test1_main.o

test1: coverage_transition coverage_statemachine compile_main
	g++ $(COVERAGE) -Wall obj/test1_main.o obj/Transition.o obj/StateMachine.o -o test1.o

orig_compile_test1:
	g++ $(COVERAGE) -Wall Transition.cpp Transition.h StateMachine.cpp
clean:
	rm -f *.o obj/*.o obj/*.gch obj/*.gcov obj/*.gcno obj/*.gcda
