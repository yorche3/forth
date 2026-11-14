\ run-tests.forth — Punto de entrada para ejecutar las pruebas del módulo
\
\ Uso:
\   gforth run-tests.forth
\
\ (ejecutar desde el directorio test/)

\ Dependencias compartidas (una sola vez)
include ../src/data_structures_advanced.forth
include test.forth

include data-structures-advanced-tests.forth

: run-all-tests ( -- )
    init-tests

    test-tree-node-create
    test-tree-node-absent-links
    test-tree-node-link-children
    test-tree-node-traverse-links
    test-tree-node-unlink-children
    test-tree-create-empty
    test-tree-insert-root
    test-tree-insert-lower-higher
    test-tree-multilevel
    test-tree-missing-value
    test-tree-duplicate
    test-tree-ordered-insertions
    test-graph-create-empty
    test-graph-isolated-vertex
    test-graph-directed-edge
    test-graph-duplicate-vertex
    test-graph-duplicate-edge
    test-graph-missing-endpoint
    test-graph-sorted-neighbours
    test-graph-missing-edge-query
    test-graph-missing-vertex-neighbours
    test-graph-self-loop
    test-graph-neighbour-isolation

    test-report
;

run-all-tests
bye
