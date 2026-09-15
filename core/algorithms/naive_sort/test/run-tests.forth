\ run-tests.forth — Punto de entrada para ejecutar las pruebas de Naive Sort
\
\ Uso:
\   gforth run-tests.forth
\
\ (ejecutar desde el directorio test/)
\
\ Ejecuta 78 aserciones: 3 algoritmos × (6+5+5+4+5+1) celdas de los casos
\ con datos. El caso del array vacío se ejecuta pero no produce aserciones:
\ con el contrato ( addr count -- ) y count 0 no hay estado observable.

\ Dependencias compartidas (una sola vez)
include ../src/naive_sort.forth
include test.forth

\ Suite de prueba
include naive-sort-tests.forth

: run-all-tests ( -- )
    init-tests
    test-selection-sort
    test-bubble-sort
    test-insertion-sort
    test-report
;

run-all-tests
bye
