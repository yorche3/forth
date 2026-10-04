\ data_structures_basics.forth — Celda enlazada compartida, lista enlazada, pila y cola
\
\ Especificación: 06_Data_Structures_Basics
\
\ Forth no declara tipos: el tipo nuevo del módulo se declara con su tamaño en
\ celdas y con las palabras de acceso del Node. Las instancias las reserva quien
\ llama (create ... allot) y cada palabra recibe su dirección.
\
\ Reparto de celdas de cada instancia:
\   node        celda 0 = valor, celda 1 = dirección del siguiente (0 = sin enlace)
\   linked-list celda 0 = cabeza, celda 1 = cola, celda 2 = contador
\   stack       celda 0 = tope, celda 1 = contador
\   queue       celda 0 = frente, celda 1 = cola, celda 2 = contador
\
\ Indicador de fallo: -1 en las operaciones que devuelven un entero (cabeza, tope
\ o extracción) cuando la estructura está vacía. El enlace ausente del Node usa la
\ dirección nula 0, no -1. Las banderas usan el par del lenguaje: 0 (falso) y -1
\ (verdadero).
\
\ Adaptación por mutabilidad: Forth escribe en el sitio, así que `node-set-next`
\ enlaza la misma celda en vez de devolver una copia y las estructuras conservan su
\ identidad. Por eso `insert-tail` y `enqueue` dejan la cola en O(1) y el resto de
\ operaciones conserva la complejidad que promete la especificación.
\
\ Las celdas enlazadas se reservan en el montón con `allocate`: el contrato no
\ expone ninguna operación de destrucción, así que viven mientras dure el sistema.
\ El estado de los recorridos vive en variables del diccionario, al estilo del
\ módulo numbers: las palabras no son reentrantes.

2 cells constant /node
3 cells constant /linked-list
2 cells constant /stack
3 cells constant /queue

\ Node — celda enlazada compartida por las tres estructuras

: node-init ( node value -- )
    over !                       \ valor
    0 over cell+ !               \ sin enlace
    drop
;

: node-get-value ( node -- value )
    @
;

: node-get-next ( node -- next )
    cell+ @
;

: node-set-next ( node next -- )
    swap cell+ !                 \ el enlace va a la celda 1 del nodo
;

\ Reserva en el montón una celda enlazada inicializada con `value`
: new-node ( value -- node )
    /node allocate throw         \ ( value node )
    dup >r
    swap node-init
    r>
;

\ LinkedList — cada nodo conoce al siguiente; las operaciones enlazan la celda en su sitio

variable ll-current
variable ll-previous

: linked-list-init ( list -- )
    /linked-list erase          \ cabeza, cola y contador a cero
;

: linked-list-get-head ( list -- value )
    @ dup 0= if
        drop -1                  \ la lista está vacía
    else
        @
    then
;

: linked-list-insert-head ( list value -- )
    new-node                     \ ( list node )
    >r                           \ (r: node)
    r@ over @ node-set-next      \ nodo.next = cabeza
    r@ over !                    \ cabeza = nodo
    dup cell+ @ 0= if            \ la lista estaba vacía
        r@ over cell+ !          \ la cola también es el nodo
    then
    2 cells + 1 swap +!          \ contador + 1
    r> drop
;

: linked-list-insert-tail ( list value -- )
    new-node                     \ ( list node )
    >r
    dup cell+ @ 0= if            \ la cola está ausente
        r@ over !                \ la cabeza también es el nodo
    else
        dup cell+ @ r@ node-set-next   \ cola.next = nodo
    then
    r@ over cell+ !              \ cola = nodo
    2 cells + 1 swap +!          \ contador + 1
    r> drop
;

: linked-list-delete ( list value -- success )
    >r                           \ (r: value)
    dup @ ll-current !           \ actual = cabeza
    0 ll-previous !              \ anterior = ausente
    begin
        ll-current @ 0<>
    while
        ll-current @ @ r@ = if
            \ reconecta el enlace saltando la celda encontrada
            ll-previous @ 0= if
                ll-current @ cell+ @ over !          \ cabeza = actual.next
            else
                ll-current @ cell+ @
                ll-previous @ cell+ !                \ anterior.next = actual.next
            then
            dup cell+ @ ll-current @ = if            \ la cola era esa celda
                ll-previous @ over cell+ !           \ cola = anterior
            then
            dup 2 cells + -1 swap +!                 \ contador - 1
            drop true r> drop exit
        then
        ll-current @ ll-previous !                   \ anterior = actual
        ll-current @ cell+ @ ll-current !            \ actual = actual.next
    repeat
    drop false r> drop           \ el valor no está en la lista
;

: linked-list-is-empty ( list -- flag )
    2 cells + @ 0=
;

: linked-list-size ( list -- count )
    2 cells + @
;

\ Stack — LIFO sobre el mismo Node; la celda 0 apunta al tope

variable st-base
variable st-value

: stack-init ( stack -- )
    /stack erase                 \ tope ausente y contador a cero
;

: stack-push ( stack value -- )
    new-node                     \ ( stack node )
    >r                           \ (r: node)
    r@ over @ node-set-next      \ nodo.next = tope
    r@ over !                    \ tope = nodo
    cell+ 1 swap +!              \ contador + 1
    r> drop
;

: stack-pop ( stack -- value )
    st-base !
    st-base @ @ dup 0= if
        drop -1                  \ la pila está vacía
    else
        dup @ st-value !         \ valor del tope
        cell+ @                  \ celda siguiente
        st-base @ !              \ tope = siguiente
        st-base @ cell+ -1 swap +!   \ contador - 1
        st-value @
    then
;

: stack-peek ( stack -- value )
    @ dup 0= if
        drop -1                  \ la pila está vacía
    else
        @
    then
;

: stack-is-empty ( stack -- flag )
    cell+ @ 0=
;

: stack-size ( stack -- count )
    cell+ @
;

\ Queue — FIFO sobre el mismo Node; celda 0 el frente, celda 1 la cola

variable q-base
variable q-value

: queue-init ( queue -- )
    /queue erase                 \ frente y cola ausentes, contador a cero
;

: queue-enqueue ( queue value -- )
    new-node                     \ ( queue node )
    >r
    dup cell+ @ 0= if            \ la cola está ausente
        r@ over !                \ el frente también es el nodo
    else
        dup cell+ @ r@ node-set-next   \ cola.next = nodo
    then
    r@ over cell+ !              \ cola = nodo
    2 cells + 1 swap +!          \ contador + 1
    r> drop
;

: queue-dequeue ( queue -- value )
    q-base !
    q-base @ @ dup 0= if
        drop -1                  \ la cola está vacía
    else
        dup @ q-value !                     \ valor del frente
        cell+ @                             \ celda siguiente
        q-base @ !                          \ frente = siguiente
        q-base @ @ 0= if                    \ se extrajo el último elemento
            0 q-base @ cell+ !              \ la cola queda ausente
        then
        q-base @ 2 cells + -1 swap +!       \ contador - 1
        q-value @
    then
;

: queue-peek ( queue -- value )
    @ dup 0= if
        drop -1                  \ la cola está vacía
    else
        @
    then
;

: queue-is-empty ( queue -- flag )
    2 cells + @ 0=
;

: queue-size ( queue -- count )
    2 cells + @
;
