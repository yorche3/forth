\ run_tests.forth — Punto de entrada para ejecutar las pruebas del Calculator
\
\ Uso:
\   gforth run_tests.forth
\
\ (ejecutar desde el directorio test/)

include calculator_tests.forth

  run-calculator-tests
bye