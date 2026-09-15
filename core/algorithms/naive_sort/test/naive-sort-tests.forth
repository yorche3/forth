\ naive-sort-tests.forth — Suite de pruebas de Naive Sort
\ Especificación: 05_Naive_Sort
\
\ Los 7 casos de la especificación se aplican a los 3 algoritmos.
\ Como los algoritmos ordenan in-place, cada caso opera sobre una COPIA del
\ fixture (buffer `work`) y nunca sobre la constante compartida.
\
\ Caso nulo: Forth no tiene null/nil y no existe representación de array nulo,
\ por lo que el caso inválido de la especificación se omite.
\
\ Nota: las dependencias (naive_sort.forth, test.forth) se cargan desde
\ run-tests.forth

\ ============================================================
\ Fixtures de entrada — NUNCA se ordenan directamente
\ ============================================================

create in-standard     5 ,  2 ,  9 ,  1 ,  5 ,  6 ,
create in-sorted       1 ,  2 ,  3 ,  4 ,  5 ,
create in-reverse      5 ,  4 ,  3 ,  2 ,  1 ,
create in-identical    7 ,  7 ,  7 ,  7 ,
create in-negative     3 , -1 ,  4 , -5 ,  0 ,
create in-single      42 ,

\ ============================================================
\ Salidas esperadas
\ ============================================================

create out-standard    1 ,  2 ,  5 ,  5 ,  6 ,  9 ,
create out-sorted      1 ,  2 ,  3 ,  4 ,  5 ,
create out-reverse     1 ,  2 ,  3 ,  4 ,  5 ,
create out-identical   7 ,  7 ,  7 ,  7 ,
create out-negative   -5 , -1 ,  0 ,  3 ,  4 ,
create out-single     42 ,

\ Buffer de trabajo: cada caso ordena una copia de su fixture
create work 8 cells allot

\ ============================================================
\ Infraestructura de la suite
\ ============================================================

create algo-name 64 allot
variable algo-name-len
variable algo-xt

variable case-xt
variable case-count
variable case-expected

: save-algo-name ( c-addr u -- )
    dup algo-name-len !
    algo-name swap move
;

\ Construye "<algoritmo> should sort <descripción>" en la etiqueta
: build-label ( desc-addr desc-len -- )
    >r >r
    algo-name label algo-name-len @ move
    algo-name-len @ label-len !
    s"  should sort " append-label
    r> r> append-label
;

\ Copia `count` celdas desde `src` al buffer `work`
: load-work ( src count -- )
    0 ?do
        dup i cells + @
        work i cells + !
    loop
    drop
;

\ Compara las `count` celdas de `work` con las esperadas
: check-work ( expected count -- )
    0 ?do
        dup i cells + @
        work i cells + @
        swap
        assert-equals
    loop
    drop
;

\ Ejecuta un caso: ( src count xt expected -- )
: do-case ( src count xt expected -- )
    case-expected !
    case-xt !
    dup case-count !
    load-work
    work case-count @ case-xt @ execute
    case-expected @ case-count @ check-work
;

\ Ejecuta un caso y fija su etiqueta: ( src count expected c-addr u -- )
: run-case ( src count expected c-addr u -- )
    build-label
    >r
    algo-xt @
    r>
    do-case
;

\ ============================================================
\ Helper compartido
\ ============================================================

\ Aplica los 7 casos de la especificación a la función `xt`.
\ `c-addr u` es el nombre del algoritmo, usado en la etiqueta del caso.
\
\ Orden en la pila: ( xt c-addr u -- ). Primero se guarda el nombre (consume
\ c-addr u) y sólo entonces el xt queda en la cima para `algo-xt !`.
: assert-sorts-all-cases ( xt c-addr u -- )
    save-algo-name
    algo-xt !
    in-standard   6  out-standard   s" an unsorted array"              run-case
    in-sorted     5  out-sorted     s" an already sorted array"        run-case
    in-reverse    5  out-reverse    s" a reverse ordered array"        run-case
    in-identical  4  out-identical  s" an array of identical elements" run-case
    in-negative   5  out-negative   s" an array with negative numbers" run-case
    in-single     1  out-single     s" a single element array"         run-case
    work          0  work           s" an empty array"                 run-case
;

\ ============================================================
\ Un test por función de la especificación
\ ============================================================

: test-selection-sort ( -- )
    ['] selection-sort  s" selection-sort" assert-sorts-all-cases
;

: test-bubble-sort ( -- )
    ['] bubble-sort  s" bubble-sort" assert-sorts-all-cases
;

: test-insertion-sort ( -- )
    ['] insertion-sort  s" insertion-sort" assert-sorts-all-cases
;
