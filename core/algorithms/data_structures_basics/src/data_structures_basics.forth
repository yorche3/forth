\ data_structures_basics.forth — Contrato y esqueletos de las estructuras enlazadas básicas
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
\ dirección nula 0, no -1. Las banderas usan el par del lenguaje —0 falso, -1
\ verdadero— y el esqueleto devuelve 0.

2 cells constant /node
3 cells constant /linked-list
2 cells constant /stack
3 cells constant /queue

\ Node — celda enlazada compartida por las tres estructuras

: node-init ( node value -- )
    \ Escribe el valor y deja el enlace ausente.
    2drop
;

: node-get-value ( node -- value )
    \ Sin caso de fallo: tras init el valor siempre existe.
    drop 0
;

: node-get-next ( node -- next )
    \ Enlace ausente = dirección nula 0.
    drop 0
;

: node-set-next ( node next -- )
    \ La especificación admite el nodo nuevo si el lenguaje es inmutable; aquí la
    \ celda se escribe en su sitio.
    2drop
;

\ LinkedList — el esqueleto devuelve el indicador natural y no resuelve ningún caso

: linked-list-init ( list -- )
    \ Deja cabeza y cola ausentes y el contador a cero.
    drop
;

: linked-list-get-head ( list -- value )
    \ -1 si la lista está vacía; si no, el valor de la cabeza.
    drop -1
;

: linked-list-insert-head ( list value -- )
    2drop
;

: linked-list-insert-tail ( list value -- )
    2drop
;

: linked-list-delete ( list value -- success )
    \ -1 (verdadero) si elimina la primera aparición; 0 (falso) si el valor no está.
    2drop 0
;

: linked-list-is-empty ( list -- flag )
    drop 0
;

: linked-list-size ( list -- count )
    drop 0
;

\ Stack — LIFO sobre el mismo Node; la celda 0 apunta al tope

: stack-init ( stack -- )
    \ Deja el tope ausente y el contador a cero.
    drop
;

: stack-push ( stack value -- )
    2drop
;

: stack-pop ( stack -- value )
    \ -1 si la pila está vacía; si no, el valor del tope, que se retira.
    drop -1
;

: stack-peek ( stack -- value )
    \ -1 si la pila está vacía; si no, el valor del tope, sin retirarlo.
    drop -1
;

: stack-is-empty ( stack -- flag )
    drop 0
;

: stack-size ( stack -- count )
    drop 0
;

\ Queue — FIFO sobre el mismo Node; celda 0 el frente, celda 1 la cola

: queue-init ( queue -- )
    \ Deja frente y cola ausentes y el contador a cero.
    drop
;

: queue-enqueue ( queue value -- )
    2drop
;

: queue-dequeue ( queue -- value )
    \ -1 si la cola está vacía; si no, el valor del frente, que se retira.
    drop -1
;

: queue-peek ( queue -- value )
    \ -1 si la cola está vacía; si no, el valor del frente, sin retirarlo.
    drop -1
;

: queue-is-empty ( queue -- flag )
    drop 0
;

: queue-size ( queue -- count )
    drop 0
;
