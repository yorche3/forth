\ run-tests.forth — Punto de entrada para ejecutar las pruebas del módulo
\
\ Uso:
\   gforth run-tests.forth
\
\ (ejecutar desde el directorio test/)

\ Dependencias compartidas (una sola vez)
include ../src/data_structures_advanced.forth
include test.forth

\ Suite de prueba (pendiente — se conectará en el paso 4c)
\ include data-structures-advanced-tests.forth

: run-all-tests ( -- )
    init-tests

    \ Las palabras de prueba se llamarán aquí cuando exista la suite

    test-report
;

run-all-tests
bye
