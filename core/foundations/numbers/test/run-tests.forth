\ run-tests.forth — Punto de entrada para ejecutar las pruebas de Numbers
\
\ Uso:
\   gforth run-tests.forth
\
\ (ejecutar desde el directorio test/)
\
\ Ejecuta 22 tests: 11 recursivos + 11 iterativos

\ Dependencias compartidas (una sola vez)
include ../src/numbers.forth
include test.forth

\ Suites de prueba
include numbers-rec-tests.forth
include numbers-ite-tests.forth

: run-all-tests ( -- )
    init-tests
    run-rec-tests
    run-ite-tests
    test-report
;

run-all-tests
bye