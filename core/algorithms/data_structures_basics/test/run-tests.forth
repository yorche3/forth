\ run-tests.forth — Punto de entrada para ejecutar las pruebas del módulo
\
\ Uso:
\   gforth run-tests.forth
\
\ (ejecutar desde el directorio test/)
\
\ El escenario de cada ADT (los 15 casos de la especificación) se recorre una vez
\ por cada una de las 23 operaciones expuestas; en cada recorrido solo se
\ comprueban las aserciones de la operación bajo prueba.

\ Dependencias compartidas (una sola vez)
include ../src/data_structures_basics.forth
include test.forth

\ Suite de prueba
include data-structures-basics-tests.forth

: run-all-tests ( -- )
    init-tests

    test-node-init
    test-node-get-value
    test-node-get-next
    test-node-set-next

    test-linked-list-init
    test-linked-list-get-head
    test-linked-list-insert-head
    test-linked-list-insert-tail
    test-linked-list-delete
    test-linked-list-is-empty
    test-linked-list-size

    test-stack-init
    test-stack-push
    test-stack-pop
    test-stack-peek
    test-stack-is-empty
    test-stack-size

    test-queue-init
    test-queue-enqueue
    test-queue-dequeue
    test-queue-peek
    test-queue-is-empty
    test-queue-size

    test-report
;

run-all-tests
bye
