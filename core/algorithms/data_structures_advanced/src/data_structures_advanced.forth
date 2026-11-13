\ data_structures_advanced.forth — Árbol binario de búsqueda y grafo dirigido
\
\ Especificación: 07_Data_Structures_Advanced
\
\ Forth representa los tipos mediante bloques de celdas reservados por quien
\ llama. El valor de Node esta embebido en cada nodo, sin tipo base separado.
\   tree-node:   valor, izquierdo, derecho
\   binary-tree: raiz, contador
\   graph-node:  etiqueta, vecinos, siguiente vertice
\   graph:       vertices, contador de vertices, contador de aristas
\ Los enlaces ausentes son 0; las banderas son false (0) y true (-1).
\ get-neighbors devuelve una copia de celdas y su cantidad, con una bandera
\ que distingue un vertice ausente de una secuencia vacia. Quien llama libera
\ una direccion no nula devuelta con free.

3 cells constant /tree-node
2 cells constant /binary-tree
3 cells constant /graph-node
3 cells constant /graph

\ TreeNode

: tree-node-init ( node value -- )
    2drop
;

: tree-node-get-value ( node -- value )
    drop -1
;

: tree-node-get-left ( node -- left )
    drop 0
;

: tree-node-get-right ( node -- right )
    drop 0
;

: tree-node-set-left ( node left -- )
    2drop
;

: tree-node-set-right ( node right -- )
    2drop
;

\ BinaryTree

: binary-tree-init ( tree -- )
    drop
;

: binary-tree-insert ( tree value -- success )
    2drop false
;

: binary-tree-contains ( tree value -- flag )
    2drop false
;

: binary-tree-is-empty ( tree -- flag )
    drop false
;

: binary-tree-size ( tree -- count )
    drop 0
;

\ GraphNode — interno a Graph

: graph-node-init ( node label -- )
    2drop
;

\ Graph

: graph-init ( graph -- )
    drop
;

: graph-add-vertex ( graph label -- success )
    2drop false
;

: graph-add-edge ( graph u v -- success )
    2drop drop false
;

: graph-has-edge ( graph u v -- flag )
    2drop drop false
;

: graph-get-neighbors ( graph u -- addr count success )
    2drop 0 0 false
;

: graph-is-empty ( graph -- flag )
    drop false
;

: graph-vertex-count ( graph -- count )
    drop 0
;

: graph-edge-count ( graph -- count )
    drop 0
;
