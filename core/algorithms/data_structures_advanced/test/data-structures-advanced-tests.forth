\ data-structures-advanced-tests.forth — Suite de pruebas de Data Structures Advanced
\ Especificación: 07_Data_Structures_Advanced
\
\ La tabla trae 24 casos (TreeNode 6, BinaryTree 7, Graph 11). Cada caso es un
\ test con instancias recién inicializadas y sus pasos en orden, con una
\ etiqueta por paso. Se omite «Adaptación inmutable»: las celdas de Forth son
\ mutables, no hay TreeNode inmutable que representar (quedan 23 ejecutables).
\
\ Indicadores (contrato del paso 4b): enlace ausente = 0; banderas -1/0;
\ get-neighbors devuelve ( addr count success ) con una copia que quien llama
\ libera con free. Las etiquetas del grafo y los valores del ABB son positivos.

create node-parent  /tree-node allot
create node-left    /tree-node allot
create node-right   /tree-node allot
create tree-buf     /binary-tree allot
create graph-buf    /graph allot

create exp-none
create exp-30        30 ,
create exp-10        10 ,
create exp-30-50     30 , 50 ,
create exp-30-50-70  30 , 50 , 70 ,
create exp-50        50 ,

variable nb-exp
variable nb-n

: yes ( flag -- ) true assert-equals ;
: no  ( flag -- ) false assert-equals ;
: lbl ( c-addr u -- ) set-label ;

\ ---------- ayudantes TreeNode ----------

: fresh-parent ( -- )
    node-parent 10 tree-node-init
    node-left   20 tree-node-init
    node-right  30 tree-node-init
;

\ ---------- ayudantes BinaryTree ----------

: tree-has  ( value -- ) tree-buf swap binary-tree-contains yes ;
: tree-lacks ( value -- ) tree-buf swap binary-tree-contains no ;
: tree-add  ( value -- ) tree-buf swap binary-tree-insert yes ;
: tree-count ( n -- ) tree-buf binary-tree-size swap assert-equals ;

\ ---------- ayudantes Graph ----------

: g-vertex ( label -- ) graph-buf swap graph-add-vertex yes ;
: g-edge   ( u v -- ) graph-buf -rot graph-add-edge yes ;
: g-edge-fails ( u v -- ) graph-buf -rot graph-add-edge no ;
: g-has    ( u v -- ) graph-buf -rot graph-has-edge yes ;
: g-lacks  ( u v -- ) graph-buf -rot graph-has-edge no ;
: g-counts ( vertices edges -- )
    swap
    graph-buf graph-vertex-count swap assert-equals
    graph-buf graph-edge-count   swap assert-equals
;

\ Libera la copia devuelta, si la hay
: free-nb ( addr -- ) ?dup if free drop then ;

: check-nb-free ( u exp n -- )
    nb-n ! nb-exp !
    graph-buf swap graph-get-neighbors
    yes
    nb-n @ assert-equals
    dup 0<> if
        nb-n @ 0 ?do
            dup i cells + @ nb-exp @ i cells + @ assert-equals
        loop
    then
    free-nb
;

: nb-missing ( u -- )
    graph-buf swap graph-get-neighbors
    no 2drop
;

\ ============================================================
\ TreeNode
\ ============================================================

: test-tree-node-create
    s" TreeNode.init should create a node with its value" lbl
    fresh-parent
    node-parent tree-node-get-value 10 assert-equals
;

: test-tree-node-absent-links
    s" TreeNode.init should leave left and right absent" lbl
    fresh-parent
    node-parent tree-node-get-left  0 assert-equals
    s" TreeNode.init should leave right absent" lbl
    node-parent tree-node-get-right 0 assert-equals
;

: test-tree-node-link-children
    fresh-parent
    node-parent node-left  tree-node-set-left
    node-parent node-right tree-node-set-right
    s" TreeNode.get_left should lead to the left child 20" lbl
    node-parent tree-node-get-left tree-node-get-value 20 assert-equals
    s" TreeNode.get_right should lead to the right child 30" lbl
    node-parent tree-node-get-right tree-node-get-value 30 assert-equals
;

: test-tree-node-traverse-links
    fresh-parent
    node-parent node-left  tree-node-set-left
    node-parent node-right tree-node-set-right
    s" TreeNode traversal should reach left child 20" lbl
    node-parent tree-node-get-left tree-node-get-value 20 assert-equals
    s" TreeNode traversal should reach right child 30" lbl
    node-parent tree-node-get-right tree-node-get-value 30 assert-equals
    s" TreeNode left child should have an absent left link" lbl
    node-parent tree-node-get-left tree-node-get-left 0 assert-equals
    s" TreeNode left child should have an absent right link" lbl
    node-parent tree-node-get-left tree-node-get-right 0 assert-equals
    s" TreeNode right child should have an absent left link" lbl
    node-parent tree-node-get-right tree-node-get-left 0 assert-equals
    s" TreeNode right child should have an absent right link" lbl
    node-parent tree-node-get-right tree-node-get-right 0 assert-equals
;

: test-tree-node-unlink-children
    fresh-parent
    node-parent node-left  tree-node-set-left
    node-parent node-right tree-node-set-right
    node-parent 0 tree-node-set-left
    s" TreeNode.set_left(absent) should clear the left link" lbl
    node-parent tree-node-get-left 0 assert-equals
    s" TreeNode.set_left(absent) should preserve value 10" lbl
    node-parent tree-node-get-value 10 assert-equals
    s" TreeNode.set_left(absent) should preserve right child 30" lbl
    node-parent tree-node-get-right tree-node-get-value 30 assert-equals
    node-parent 0 tree-node-set-right
    s" TreeNode.set_right(absent) should clear the left link" lbl
    node-parent tree-node-get-left 0 assert-equals
    s" TreeNode.set_right(absent) should clear the right link" lbl
    node-parent tree-node-get-right 0 assert-equals
    s" TreeNode.set_right(absent) should preserve value 10" lbl
    node-parent tree-node-get-value 10 assert-equals
;

\ ============================================================
\ BinaryTree
\ ============================================================

: test-tree-create-empty
    tree-buf binary-tree-init
    s" BinaryTree.is_empty should be true on a new tree" lbl
    tree-buf binary-tree-is-empty yes
    s" BinaryTree.size should be 0 on a new tree" lbl
    0 tree-count
    s" BinaryTree.contains should fail on a new tree" lbl
    50 tree-lacks
;

: test-tree-insert-root
    tree-buf binary-tree-init
    s" BinaryTree.insert should succeed for the root 50" lbl
    50 tree-add
    s" BinaryTree.size should be 1 after the root" lbl
    1 tree-count
    s" BinaryTree.is_empty should be false after the root" lbl
    tree-buf binary-tree-is-empty no
    s" BinaryTree.contains should find the root 50" lbl
    50 tree-has
;

: test-tree-insert-lower-higher
    tree-buf binary-tree-init
    s" BinaryTree.insert should succeed for 50, 30 and 70" lbl
    50 tree-add 30 tree-add 70 tree-add
    s" BinaryTree.size should be 3" lbl
    3 tree-count
    s" BinaryTree.contains should find 50, 30 and 70" lbl
    50 tree-has 30 tree-has 70 tree-has
;

: test-tree-multilevel
    tree-buf binary-tree-init
    s" BinaryTree.insert should succeed for five multilevel values" lbl
    50 tree-add 30 tree-add 70 tree-add 20 tree-add 40 tree-add
    s" BinaryTree.contains should find every multilevel value" lbl
    50 tree-has 30 tree-has 70 tree-has 20 tree-has 40 tree-has
    s" BinaryTree.size should be 5 for multilevel branches" lbl
    5 tree-count
;

: test-tree-missing-value
    tree-buf binary-tree-init
    s" BinaryTree.insert should succeed for 50" lbl
    50 tree-add
    s" BinaryTree.contains should fail for the missing 99" lbl
    99 tree-lacks
    s" BinaryTree.size should stay 1 after a missing query" lbl
    1 tree-count
    s" BinaryTree.contains should still find 50" lbl
    50 tree-has
;

: test-tree-duplicate
    tree-buf binary-tree-init
    s" BinaryTree.insert should succeed for 50, 30, 70 and the duplicate 30" lbl
    50 tree-add 30 tree-add 70 tree-add 30 tree-add
    s" BinaryTree.size should stay 3 after a duplicate" lbl
    3 tree-count
    s" BinaryTree.contains should keep all three values" lbl
    50 tree-has 30 tree-has 70 tree-has
;

: test-tree-ordered-insertions
    tree-buf binary-tree-init
    s" BinaryTree.insert should succeed for ordered 20, 30, 40, 50, 70" lbl
    20 tree-add 30 tree-add 40 tree-add 50 tree-add 70 tree-add
    s" BinaryTree.size should be 5 after ordered insertions" lbl
    5 tree-count
    s" BinaryTree.contains should find every ordered value" lbl
    20 tree-has 30 tree-has 40 tree-has 50 tree-has 70 tree-has
    s" BinaryTree.contains should fail for 99 after ordered insertions" lbl
    99 tree-lacks
;

\ ============================================================
\ Graph
\ ============================================================

: test-graph-create-empty
    graph-buf graph-init
    s" Graph.is_empty should be true on a new graph" lbl
    graph-buf graph-is-empty yes
    s" Graph.vertex_count/edge_count should be 0 on a new graph" lbl
    0 0 g-counts
    s" Graph.has_edge should fail on a new graph" lbl
    10 30 g-lacks
    s" Graph.get_neighbors should fail on a new graph" lbl
    10 nb-missing
;

: test-graph-isolated-vertex
    graph-buf graph-init
    s" Graph.add_vertex should succeed for 10" lbl
    10 g-vertex
    s" Graph.is_empty should be false with a vertex" lbl
    graph-buf graph-is-empty no
    s" Graph counts should be 1 vertex and 0 edges" lbl
    1 0 g-counts
    s" Graph.get_neighbors should be empty for an isolated vertex" lbl
    10 exp-none 0 check-nb-free
;

: test-graph-directed-edge
    graph-buf graph-init
    s" Graph.add_vertex should succeed for 10 and 70" lbl
    10 g-vertex 70 g-vertex
    s" Graph.add_edge should succeed for 10 to 70" lbl
    10 70 g-edge
    s" Graph.has_edge should find 10 to 70" lbl
    10 70 g-has
    s" Graph.has_edge should fail for the reverse 70 to 10" lbl
    70 10 g-lacks
    s" Graph counts should be 2 vertices and 1 edge" lbl
    2 1 g-counts
;

: test-graph-duplicate-vertex
    graph-buf graph-init
    s" Graph.add_vertex should succeed for 10 and 30" lbl
    10 g-vertex 30 g-vertex
    s" Graph.add_edge should succeed for 10 to 30" lbl
    10 30 g-edge
    s" Graph.add_vertex should succeed for the duplicate 10" lbl
    10 g-vertex
    s" Graph counts should stay 2 vertices and 1 edge" lbl
    2 1 g-counts
    s" Graph.get_neighbors(10) should preserve [30] after duplicate vertex" lbl
    10 exp-30 1 check-nb-free
;

: test-graph-duplicate-edge
    graph-buf graph-init
    s" Graph.add_vertex should succeed for 10 and 30" lbl
    10 g-vertex 30 g-vertex
    s" Graph.add_edge should succeed twice for 10 to 30" lbl
    10 30 g-edge 10 30 g-edge
    s" Graph counts should be 2 vertices and 1 edge" lbl
    2 1 g-counts
    s" Graph.get_neighbors(10) should be [30] after duplicate edge" lbl
    10 exp-30 1 check-nb-free
;

: test-graph-missing-endpoint
    graph-buf graph-init
    10 g-vertex 30 g-vertex 10 30 g-edge
    s" Graph.add_edge should fail for 10 to 99" lbl
    10 99 g-edge-fails
    s" Graph.add_edge should fail for 99 to 10" lbl
    99 10 g-edge-fails
    s" Graph.add_edge should fail for 98 to 99" lbl
    98 99 g-edge-fails
    s" Graph.add_edge should fail for 99 to 99" lbl
    99 99 g-edge-fails
    s" Graph counts should stay 2 vertices and 1 edge after failures" lbl
    2 1 g-counts
    s" Graph.get_neighbors(10) should stay [30] after failures" lbl
    10 exp-30 1 check-nb-free
    s" Graph.get_neighbors(30) should stay empty after failures" lbl
    30 exp-none 0 check-nb-free
    s" Graph.has_edge should fail for every attempted edge" lbl
    10 99 g-lacks 99 10 g-lacks 98 99 g-lacks 99 99 g-lacks
    s" Graph.get_neighbors should fail for 98" lbl
    98 nb-missing
    s" Graph.get_neighbors should fail for 99" lbl
    99 nb-missing
;

: test-graph-sorted-neighbours
    graph-buf graph-init
    s" Graph.add_vertex should succeed for 10, 30, 50 and 70" lbl
    10 g-vertex 30 g-vertex 50 g-vertex 70 g-vertex
    s" Graph.add_edge should succeed for four edges" lbl
    10 70 g-edge 10 30 g-edge 10 50 g-edge 30 50 g-edge
    s" Graph.get_neighbors(10) should be [30,50,70]" lbl
    10 exp-30-50-70 3 check-nb-free
    s" Graph.get_neighbors(30) should be [50]" lbl
    30 exp-50 1 check-nb-free
    s" Graph.get_neighbors(50) should be empty" lbl
    50 exp-none 0 check-nb-free
    s" Graph.get_neighbors(70) should be empty" lbl
    70 exp-none 0 check-nb-free
    s" Graph counts should be 4 vertices and 4 edges" lbl
    4 4 g-counts
;

: test-graph-missing-edge-query
    graph-buf graph-init
    s" Graph.add_vertex should succeed for 10 and 30" lbl
    10 g-vertex 30 g-vertex
    s" Graph.has_edge should fail without the edge" lbl
    10 30 g-lacks
    s" Graph counts should be 2 vertices and 0 edges" lbl
    2 0 g-counts
    s" Graph.is_empty should be false with vertices" lbl
    graph-buf graph-is-empty no
;

: test-graph-missing-vertex-neighbours
    graph-buf graph-init
    s" Graph.add_vertex should succeed for 10" lbl
    10 g-vertex
    s" Graph.get_neighbors should fail for the missing 99" lbl
    99 nb-missing
    s" Graph.get_neighbors should stay empty, not failed, for 10" lbl
    10 exp-none 0 check-nb-free
    s" Graph counts should stay 1 vertex and 0 edges" lbl
    1 0 g-counts
;

: test-graph-self-loop
    graph-buf graph-init
    s" Graph.add_vertex should succeed for 10" lbl
    10 g-vertex
    s" Graph.add_edge should succeed twice for the loop 10 to 10" lbl
    10 10 g-edge 10 10 g-edge
    s" Graph.has_edge should find the loop 10 to 10" lbl
    10 10 g-has
    s" Graph.get_neighbors(10) should be [10]" lbl
    10 exp-10 1 check-nb-free
    s" Graph counts should be 1 vertex and 1 edge" lbl
    1 1 g-counts
;

\ Resultado guardado de vecinos antes de añadir otra arista
variable saved-nb
variable saved-n

: test-graph-neighbour-isolation
    graph-buf graph-init
    s" Graph.add_vertex should succeed for 10, 30 and 50" lbl
    10 g-vertex 30 g-vertex 50 g-vertex
    s" Graph.add_edge should succeed for 10 to 30" lbl
    10 30 g-edge
    graph-buf 10 graph-get-neighbors
    s" Graph.get_neighbors(10) should succeed for the saved result" lbl
    yes saved-n ! saved-nb !
    \ otra copia devuelta: modificarla no debe afectar al grafo
    graph-buf 10 graph-get-neighbors yes
    drop dup 0<> if 99 over ! then
    free-nb
    s" Graph.add_edge should succeed for 10 to 50" lbl
    10 50 g-edge
    s" Graph saved neighbours should keep count 1" lbl
    saved-n @ 1 assert-equals
    s" Graph saved neighbours should remain [30]" lbl
    saved-nb @ 0<> if saved-nb @ @ 30 assert-equals else 0 30 assert-equals then
    saved-nb @ free-nb
    s" Graph.get_neighbors(10) should be [30,50] after the new edge" lbl
    10 exp-30-50 2 check-nb-free
    s" Graph counts should be 3 vertices and 2 edges" lbl
    3 2 g-counts
;
