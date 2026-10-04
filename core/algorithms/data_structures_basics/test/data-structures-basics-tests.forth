\ data-structures-basics-tests.forth — Suite de pruebas de Data Structures Basics
\ Especificación: 06_Data_Structures_Basics
\
\ Los 15 casos de la especificación (Node 2, LinkedList 5, Stack 4, Queue 4) son
\ pasos sucesivos sobre el mismo estado lógico: cada estructura se inicializa una
\ sola vez por recorrido y los casos se aplican en orden, sin reiniciar el
\ escenario. Cada operación expuesta tiene su propio test: el escenario completo
\ se reproduce con la operación como sujeto y solo se comprueban las aserciones
\ que le pertenecen.
\
\ Indicadores (contrato del paso 4b): -1 en las operaciones que devuelven un
\ entero cuando la estructura está vacía; el enlace ausente de la celda es la
\ dirección nula 0. Las banderas usan el par del lenguaje: -1 (verdadero) y
\ 0 (falso). Los valores de los casos son enteros positivos (5, 10, 20, 30, 40,
\ 99) para no colisionar con el indicador de fallo.
\
\ El contrato solo permite avanzar en la lista con get_head + delete, así que
\ cada comprobación de recorrido se hace sobre una instancia de replay
\ (`replay-list`), nunca sobre la instancia del escenario: el ADT es mutable y
\ vaciarla lo rompería.
\
\ Nota: las dependencias (data_structures_basics.forth, test.forth) se cargan
\ desde run-tests.forth

\ ============================================================
\ Instancias — las reserva la suite; el reparto de celdas es el del contrato
\ ============================================================

create node-a         /node allot
create node-b         /node allot
create list-buf       /linked-list allot
create stack-buf      /stack allot
create queue-buf      /queue allot

\ Instancia de replay para comprobar recorridos sin tocar el escenario
create replay-list    /linked-list allot

\ ============================================================
\ Salidas esperadas de los recorridos
\ ============================================================

create out-inserted      5 , 10 , 20 , 10 ,
create out-after-delete  5 , 20 , 10 ,

\ ============================================================
\ Infraestructura: sujeto bajo prueba, caso en curso y dueños de la aserción
\ ============================================================

variable subject
create subject-name 64 allot
variable subject-name-len

variable case-len
create case-desc 64 allot
variable case-count

8 constant max-owners
create owner-table max-owners cells allot
variable owner-count

4 constant max-traversal
create work 8 cells allot
variable drained-count
variable drained-value

variable popped
variable deleted?

: set-subject ( xt c-addr u -- )
    subject-name-len !
    subject-name
    subject-name-len @
    move
    subject !
;

: set-case ( c-addr u -- )
    case-len !
    case-desc
    case-len @
    move
;

\ Construye "<operación> should <caso>" en la etiqueta del framework
: build-label ( -- )
    subject-name label subject-name-len @ move
    subject-name-len @ label-len !
    s"  should " append-label
    case-desc case-len @ append-label
;

\ Declara las operaciones dueñas del bloque de aserciones que empieza:
\ ( xt1 ... xtn n -- )
: owners ( xt1 ... xtn n -- )
    dup owner-count !
    0 ?do
        owner-table i cells + !
    loop
;

: owned? ( -- flag )
    owner-count @ 0= if
        true exit
    then
    false
    owner-count @ 0 ?do
        subject @  owner-table i cells + @  =  or
    loop
;

\ Una aserción del caso: solo se comprueba si el sujeto está entre sus dueños
: assert-for ( actual expected -- )
    owned? if
        build-label
        assert-equals
    else
        2drop
    then
;

\ Compara las `count` celdas de `work` con las esperadas
: check-work ( expected count -- )
    0 ?do
        dup i cells + @
        work i cells + @
        swap
        assert-for
    loop
    drop
;

\ Vuelca la lista de replay en `work` vaciándola y la compara con el caso:
\ ( expected count -- ). El tope `max-traversal` evita que una implementación
\ que no elimine deje la suite colgada.
: drain-replay ( expected count -- )
    case-count !
    0 drained-count !
    begin
        drained-count @ max-traversal <
        if
            replay-list linked-list-get-head
            dup -1 <> if
                drained-value !
                true
            else
                drop
                false
            then
        else
            false
        then
    while
        drained-value @  work drained-count @ cells +  !
        drained-count @ 1+ drained-count !
        replay-list  drained-value @  linked-list-delete  drop
    repeat
    drained-count @  case-count @  assert-for
    case-count @  check-work
;

\ ============================================================
\ Replay de la lista: mismas operaciones que el escenario, sobre otro buffer
\ ============================================================

: replay-inserted ( -- )
    replay-list linked-list-init
    replay-list 10 linked-list-insert-tail
    replay-list 20 linked-list-insert-tail
    replay-list 5  linked-list-insert-head
    replay-list 10 linked-list-insert-tail
;

: replay-deleted ( -- )
    replay-inserted
    replay-list 10 linked-list-delete drop
;

: replay-absent ( -- )
    replay-deleted
    replay-list 99 linked-list-delete drop
;

\ ============================================================
\ Escenario de Node — 2 casos
\ ============================================================

: run-node-cases ( xt c-addr u -- )
    set-subject

    \ --- Inicializar y observar valor/enlace
    s" initialize and observe value/link" set-case
    node-a 10 node-init
    node-a node-get-value  10  ['] node-init ['] node-get-value  2 owners assert-for
    node-a node-get-next   0   ['] node-init ['] node-get-next   2 owners assert-for

    \ --- Inicializar otro nodo, enlazar y recorrer
    s" initialize another node, link and traverse" set-case
    node-b 20 node-init
    node-a node-b node-set-next
    node-a node-get-next  node-b  ['] node-set-next ['] node-get-next  2 owners assert-for
    node-a node-get-next node-get-value  20
        ['] node-set-next ['] node-get-next ['] node-get-value  3 owners assert-for
    node-b node-get-next  0  ['] node-set-next ['] node-get-next  2 owners assert-for
;

\ ============================================================
\ Escenario de LinkedList — 5 casos
\ ============================================================

: run-linked-list-cases ( xt c-addr u -- )
    set-subject

    \ --- Estado vacío
    s" empty state" set-case
    list-buf linked-list-init
    list-buf linked-list-is-empty  true  ['] linked-list-init ['] linked-list-is-empty  2 owners assert-for
    list-buf linked-list-size      0     ['] linked-list-init ['] linked-list-size       2 owners assert-for
    list-buf linked-list-get-head  -1    ['] linked-list-init ['] linked-list-get-head   2 owners assert-for

    \ --- Insertar por ambos extremos
    s" insert at both ends" set-case
    list-buf 10 linked-list-insert-tail
    list-buf 20 linked-list-insert-tail
    list-buf 5  linked-list-insert-head
    list-buf 10 linked-list-insert-tail
    list-buf linked-list-size  4
        ['] linked-list-insert-head ['] linked-list-insert-tail ['] linked-list-size  3 owners assert-for
    replay-inserted
    out-inserted 4
        ['] linked-list-insert-head ['] linked-list-insert-tail ['] linked-list-get-head  3 owners drain-replay

    \ --- Eliminar la primera aparición
    s" delete first occurrence" set-case
    list-buf 10 linked-list-delete deleted? !
    deleted? @ true  ['] linked-list-delete  1 owners assert-for
    list-buf linked-list-size  3  ['] linked-list-delete ['] linked-list-size  2 owners assert-for
    replay-deleted
    out-after-delete 3
        ['] linked-list-delete ['] linked-list-get-head  2 owners drain-replay

    \ --- Valor ausente
    s" absent value" set-case
    list-buf 99 linked-list-delete deleted? !
    deleted? @ false  ['] linked-list-delete  1 owners assert-for
    list-buf linked-list-size  3  ['] linked-list-delete ['] linked-list-size  2 owners assert-for
    replay-absent
    out-after-delete 3
        ['] linked-list-delete ['] linked-list-get-head  2 owners drain-replay

    \ --- Vaciar la lista
    s" empty the list" set-case
    list-buf 5  linked-list-delete deleted? !
    deleted? @ true  ['] linked-list-delete  1 owners assert-for
    list-buf 20 linked-list-delete deleted? !
    deleted? @ true  ['] linked-list-delete  1 owners assert-for
    list-buf 10 linked-list-delete deleted? !
    deleted? @ true  ['] linked-list-delete  1 owners assert-for
    list-buf linked-list-is-empty  true  ['] linked-list-delete ['] linked-list-is-empty  2 owners assert-for
    list-buf linked-list-size      0     ['] linked-list-delete ['] linked-list-size       2 owners assert-for
    list-buf linked-list-get-head  -1    ['] linked-list-delete ['] linked-list-get-head   2 owners assert-for
;

\ ============================================================
\ Escenario de Stack — 4 casos
\ ============================================================

: run-stack-cases ( xt c-addr u -- )
    set-subject

    \ --- Estado vacío y extracción fallida
    s" empty state and failed removal" set-case
    stack-buf stack-init
    stack-buf stack-is-empty  true  ['] stack-init ['] stack-is-empty  2 owners assert-for
    stack-buf stack-size      0     ['] stack-init ['] stack-size       2 owners assert-for
    stack-buf stack-peek      -1    ['] stack-init ['] stack-peek       2 owners assert-for
    stack-buf stack-pop       -1    ['] stack-init ['] stack-pop        2 owners assert-for

    \ --- LIFO y peek no mutante
    s" LIFO and non-mutating peek" set-case
    stack-buf 10 stack-push
    stack-buf 20 stack-push
    stack-buf 30 stack-push
    stack-buf stack-peek  30  ['] stack-push ['] stack-peek  2 owners assert-for
    stack-buf stack-size  3   ['] stack-push ['] stack-size  2 owners assert-for

    \ --- Extracción y reutilización
    s" removal and reuse" set-case
    stack-buf stack-pop popped !
    popped @ 30  ['] stack-pop  1 owners assert-for
    stack-buf 40 stack-push
    stack-buf stack-pop popped !
    popped @ 40  ['] stack-pop ['] stack-push  2 owners assert-for
    stack-buf stack-pop popped !
    popped @ 20  ['] stack-pop  1 owners assert-for
    stack-buf stack-pop popped !
    popped @ 10  ['] stack-pop  1 owners assert-for
    stack-buf stack-is-empty  true  ['] stack-pop ['] stack-is-empty  2 owners assert-for
    stack-buf stack-size      0     ['] stack-pop ['] stack-size       2 owners assert-for

    \ --- Vacío tras extracción
    s" empty after removal" set-case
    stack-buf stack-pop popped !
    popped @ -1  ['] stack-pop  1 owners assert-for
    stack-buf stack-is-empty  true  ['] stack-pop ['] stack-is-empty  2 owners assert-for
;

\ ============================================================
\ Escenario de Queue — 4 casos
\ ============================================================

: run-queue-cases ( xt c-addr u -- )
    set-subject

    \ --- Estado vacío y extracción fallida
    s" empty state and failed removal" set-case
    queue-buf queue-init
    queue-buf queue-is-empty  true  ['] queue-init ['] queue-is-empty  2 owners assert-for
    queue-buf queue-size      0     ['] queue-init ['] queue-size       2 owners assert-for
    queue-buf queue-peek      -1    ['] queue-init ['] queue-peek       2 owners assert-for
    queue-buf queue-dequeue   -1    ['] queue-init ['] queue-dequeue    2 owners assert-for

    \ --- FIFO y peek no mutante
    s" FIFO and non-mutating peek" set-case
    queue-buf 10 queue-enqueue
    queue-buf 20 queue-enqueue
    queue-buf 30 queue-enqueue
    queue-buf queue-peek  10  ['] queue-enqueue ['] queue-peek  2 owners assert-for
    queue-buf queue-size  3   ['] queue-enqueue ['] queue-size  2 owners assert-for

    \ --- Extracción y reutilización
    s" removal and reuse" set-case
    queue-buf queue-dequeue popped !
    popped @ 10  ['] queue-dequeue  1 owners assert-for
    queue-buf 40 queue-enqueue
    queue-buf queue-dequeue popped !
    popped @ 20  ['] queue-dequeue  1 owners assert-for
    queue-buf queue-dequeue popped !
    popped @ 30  ['] queue-dequeue  1 owners assert-for
    queue-buf queue-dequeue popped !
    popped @ 40  ['] queue-dequeue ['] queue-enqueue  2 owners assert-for
    queue-buf queue-is-empty  true  ['] queue-dequeue ['] queue-is-empty  2 owners assert-for
    queue-buf queue-size      0     ['] queue-dequeue ['] queue-size       2 owners assert-for

    \ --- Vacío tras extracción
    s" empty after removal" set-case
    queue-buf queue-dequeue popped !
    popped @ -1  ['] queue-dequeue  1 owners assert-for
    queue-buf queue-is-empty  true  ['] queue-dequeue ['] queue-is-empty  2 owners assert-for
;

\ ============================================================
\ Un test por operación de la especificación (23)
\ ============================================================

: test-node-init ( -- )          ['] node-init          s" node-init"          run-node-cases ;
: test-node-get-value ( -- )     ['] node-get-value     s" node-get-value"     run-node-cases ;
: test-node-get-next ( -- )      ['] node-get-next      s" node-get-next"      run-node-cases ;
: test-node-set-next ( -- )      ['] node-set-next      s" node-set-next"      run-node-cases ;

: test-linked-list-init ( -- )       ['] linked-list-init       s" linked-list-init"       run-linked-list-cases ;
: test-linked-list-get-head ( -- )   ['] linked-list-get-head   s" linked-list-get-head"   run-linked-list-cases ;
: test-linked-list-insert-head ( -- ) ['] linked-list-insert-head s" linked-list-insert-head" run-linked-list-cases ;
: test-linked-list-insert-tail ( -- ) ['] linked-list-insert-tail s" linked-list-insert-tail" run-linked-list-cases ;
: test-linked-list-delete ( -- )     ['] linked-list-delete     s" linked-list-delete"     run-linked-list-cases ;
: test-linked-list-is-empty ( -- )   ['] linked-list-is-empty   s" linked-list-is-empty"   run-linked-list-cases ;
: test-linked-list-size ( -- )       ['] linked-list-size       s" linked-list-size"       run-linked-list-cases ;

: test-stack-init ( -- )     ['] stack-init     s" stack-init"     run-stack-cases ;
: test-stack-push ( -- )     ['] stack-push     s" stack-push"     run-stack-cases ;
: test-stack-pop ( -- )      ['] stack-pop      s" stack-pop"      run-stack-cases ;
: test-stack-peek ( -- )     ['] stack-peek     s" stack-peek"     run-stack-cases ;
: test-stack-is-empty ( -- ) ['] stack-is-empty s" stack-is-empty" run-stack-cases ;
: test-stack-size ( -- )     ['] stack-size     s" stack-size"     run-stack-cases ;

: test-queue-init ( -- )     ['] queue-init     s" queue-init"     run-queue-cases ;
: test-queue-enqueue ( -- )  ['] queue-enqueue  s" queue-enqueue"  run-queue-cases ;
: test-queue-dequeue ( -- )  ['] queue-dequeue  s" queue-dequeue"  run-queue-cases ;
: test-queue-peek ( -- )     ['] queue-peek     s" queue-peek"     run-queue-cases ;
: test-queue-is-empty ( -- ) ['] queue-is-empty s" queue-is-empty" run-queue-cases ;
: test-queue-size ( -- )     ['] queue-size     s" queue-size"     run-queue-cases ;
