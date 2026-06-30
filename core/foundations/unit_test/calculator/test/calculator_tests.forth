\ calculator_tests.forth — Suite de pruebas para el módulo Calculator
\
\ Especificación: 03_Unit_Test_Calculator

include ../src/calculator.forth
include test.forth

: test-addition ( -- )
    2 3 addition 5 assert-equals
;

: test-subtraction ( -- )
    5 2 subtraction 3 assert-equals
;

: test-multiplication ( -- )
    3 4 multiplication 12 assert-equals
;

: test-division ( -- )
    10 3 division 3 assert-equals
;

: test-modulus ( -- )
    10 3 modulus 1 assert-equals
;

: run-calculator-tests ( -- )
  init-tests
  test-addition
  test-subtraction
  test-multiplication
  test-division
  test-modulus
  test-report
;

