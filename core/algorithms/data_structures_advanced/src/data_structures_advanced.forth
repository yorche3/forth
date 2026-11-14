\ data_structures_advanced.forth — Árbol binario de búsqueda y grafo dirigido
\
\ Especificación: 07_Data_Structures_Advanced
\
\ Forth representa los tipos mediante bloques de celdas reservados por quien
\ llama. El valor de Node esta embebido en cada nodo, sin tipo base separado.
\   tree-node:   valor, izquierdo, derecho
\   binary-tree: raiz, contador
\   graph-node:  etiqueta, bloque de vecinos, siguiente vertice
\   graph:       vertices, contador de vertices, contador de aristas
\ Los enlaces ausentes son 0; las banderas son false (0) y true (-1).
\ El bloque de vecinos guarda la cuenta en su celda 0 y los valores ordenados
\ y sin duplicados a continuacion.
\ get-neighbors devuelve una copia de celdas y su cantidad, con una bandera
\ que distingue un vertice ausente de una secuencia vacia. Quien llama libera
\ una direccion no nula devuelta con free.

3 cells constant /tree-node
2 cells constant /binary-tree
3 cells constant /graph-node
3 cells constant /graph

\ TreeNode

: tree-node-init ( node value -- )
    over 2 cells + 0 swap !
    over cell+ 0 swap !
    swap !
;

: tree-node-get-value ( node -- value )
    @
;

: tree-node-get-left ( node -- left )
    cell+ @
;

: tree-node-get-right ( node -- right )
    2 cells + @
;

: tree-node-set-left ( node left -- )
    swap cell+ !
;

: tree-node-set-right ( node right -- )
    swap 2 cells + !
;

\ BinaryTree

: binary-tree-init ( tree -- )
    dup 0 swap !  \ initialize root to 0
    cell+ 0 swap !  \ initialize count to 0
;

variable bt-cur

: binary-tree-count-up ( tree -- )
    cell+ 1 swap +!
;

: binary-tree-insert ( tree value -- success )
    { tree value }
    tree @ 0= if
        /tree-node allocate throw
        dup value tree-node-init
        dup tree !
        tree binary-tree-count-up
        drop true exit
    then
    tree @
    begin ( current )
        dup bt-cur !
        bt-cur @ tree-node-get-value value = if
            drop true exit
        then
        bt-cur @ tree-node-get-value value > if
            bt-cur @ tree-node-get-left
            dup 0= if
                drop
                /tree-node allocate throw
                dup value tree-node-init
                dup bt-cur @ swap tree-node-set-left
                tree binary-tree-count-up
                drop true exit
            then
        else
            bt-cur @ tree-node-get-right
            dup 0= if
                drop
                /tree-node allocate throw
                dup value tree-node-init
                dup bt-cur @ swap tree-node-set-right
                tree binary-tree-count-up
                drop true exit
            then
        then
    again
;

: binary-tree-contains ( tree value -- flag )
    { tree value }
    tree @
    begin ( current )
        dup 0= if
            drop false exit
        then
        dup bt-cur !
        bt-cur @ tree-node-get-value value = if
            drop true exit
        then
        drop
        bt-cur @ tree-node-get-value value > if
            bt-cur @ tree-node-get-left
        else
            bt-cur @ tree-node-get-right
        then
    again
;

: binary-tree-is-empty ( tree -- flag )
    cell+ @ 0=
;

: binary-tree-size ( tree -- count )
    cell+ @
;

\ GraphNode — interno a Graph
\
\ El bloque de vecinos es una reserva propia: celda 0 = cantidad, y despues
\ los valores en orden ascendente. Un bloque ausente es 0.

variable gn-head
variable nb-src
variable nb-new
variable nb-copy
variable nb-count
variable nb-i
variable nb-j
variable nb-tmp
variable nb-placed

: graph-node-init ( node label -- )
    over 0 swap cell+ !
    over 0 swap 2 cells + !
    swap !
;

: nb-get ( i block -- value )
    swap 1+ cells swap + @
;

: nb-put ( value block i -- )
    1+ cells + !
;

: nb-contains? ( block value -- flag )
    { block value }
    block 0= if false exit then
    0 nb-i !
    begin
        nb-i @ block @ <
    while
        nb-i @ block nb-get value = if true exit then
        1 nb-i +!
    repeat
    false
;

: nb-insert ( block value -- block' )
    { block value }
    block 0= if
        2 cells allocate throw
        dup 1 swap !
        dup cell+ value swap !
        exit
    then
    block @ 2 + cells allocate throw nb-new !
    block @ 1+ nb-new @ !
    0 nb-i !
    0 nb-j !
    false nb-placed !
    begin
        nb-i @ block @ <
    while
        nb-i @ block nb-get nb-tmp !
        nb-placed @ 0= nb-tmp @ value > and if
            value nb-new @ nb-j @ nb-put
            1 nb-j +!
            true nb-placed !
        then
        nb-tmp @ nb-new @ nb-j @ nb-put
        1 nb-j +!
        1 nb-i +!
    repeat
    nb-placed @ 0= if
        value nb-new @ nb-j @ nb-put
    then
    block free throw
    nb-new @
;

: find-graph-node ( head label -- node | 0 )
    { head label }
    head
    begin
        dup 0= if exit then
        dup @ label = if exit then
        2 cells + @
    again
;

\ Graph

: graph-init ( graph -- )
    dup 0 swap !
    dup 0 swap cell+ !
    0 swap 2 cells + !
;

: graph-add-vertex ( graph label -- success )
    { graph label }
    graph @ label find-graph-node if
        true exit
    then
    /graph-node allocate throw
    dup label graph-node-init
    dup graph @ swap 2 cells + !
    graph !
    graph cell+ 1 swap +!
    true
;

: graph-add-edge ( graph u v -- success )
    { graph u v }
    graph @ u find-graph-node dup 0= if drop false exit then
    gn-head !
    graph @ v find-graph-node 0= if false exit then
    gn-head @ cell+ @ v nb-contains? if
        true exit
    then
    gn-head @ cell+ @ v nb-insert gn-head @ cell+ !
    graph 2 cells + 1 swap +!
    true
;

: graph-has-edge ( graph u v -- flag )
    { graph u v }
    graph @ u find-graph-node dup 0= if drop false exit then
    cell+ @ v nb-contains?
;

: graph-get-neighbors ( graph u -- addr count success )
    { graph u }
    graph @ u find-graph-node dup 0= if drop 0 0 false exit then
    cell+ @ dup 0= if drop 0 0 true exit then
    dup nb-src !
    dup @ nb-count !
    drop
    nb-count @ cells allocate throw nb-copy !
    nb-count @ 0 ?do
        i nb-src @ nb-get
        i cells nb-copy @ + !
    loop
    nb-copy @ nb-count @ true
;

: graph-is-empty ( graph -- flag )
    @ 0=
;

: graph-vertex-count ( graph -- count )
    cell+ @
;

: graph-edge-count ( graph -- count )
    2 cells + @
;
