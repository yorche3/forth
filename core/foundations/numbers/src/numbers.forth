\ numbers.forth — Módulo Numbers con algoritmos numéricos en 3 enfoques
\
\ Especificación: 04_Numbers
\
\ Enfoques:
\   _rec: recursión directa
\   _acc: recursión con acumulador (tail-call style)
\   _ite: iterativo (bucles)
\
\ Algoritmos:
\   sum-first-n       — suma de los primeros n números
\   factorial         — factorial de n
\   fibonacci         — n-ésimo número de Fibonacci
\   greatest-common-divisor — máximo común divisor (GCD)
\   least-common-multiple   — mínimo común múltiplo (LCM)

\ ============================================================
\ Enfoque recursivo (_rec)
\ ============================================================

: sum-first-n-rec ( n -- sum )
    dup 0 <= if
        drop 0
    else
        dup 1 - recurse
        +
    then
;

: factorial-rec ( n -- fact )
    dup 1 <= if
        drop 1
    else
        dup 1- recurse
        *
    then
;

: fibonacci-rec ( n -- fib )
    dup 0 <= if
        drop 0
    else
        dup 1 = if
            drop 1
        else
            dup 2 - recurse
            swap 1 - recurse
            +
        then
    then
;

: greatest-common-divisor-rec ( a b -- gcd )
    dup 0 = if
        drop
    else
        swap over mod recurse
    then
;

: least-common-multiple-rec ( a b -- lcm )
    2dup greatest-common-divisor-rec
    / *
;

\ ============================================================
\ Enfoque con acumulador (_acc)
\ ============================================================

: sum-first-n-help ( n acc -- sum )
    swap dup 0 <= if
        drop
    else            \ acc n
       dup 1- >r    \ acc n r:n-1
       + >r         \ acc+n n-1
       swap recurse \ n-1 acc+n
    then
;

: sum-first-n-acc ( n -- sum )
    0 sum-first-n-help
;

: factorial-help ( n acc -- fact )
    swap dup 1 <= if
        drop
    else               \ acc n
        dup 1- >r       \ acc n r:n-1
        * >r            \ acc*n n-1
        swap recurse     \ n-1 acc*n
    then
;

: factorial-acc ( n -- fact )
    1 factorial-help
;

: fibonacci-help ( n acc1 acc2 -- fib )
    rot dup 0 <= if
        drop drop
    else
        1- >r            \ acc1 acc2 r:n-1
        swap over       \ acc2 acc1 acc2 r:n-1
        + >r             \ acc2 acc1+acc2 n-1
        rot rot recurse   \ n-1 acc2 acc1+acc2
    then
;

: fibonacci-acc ( n -- fib )
    0 1 fibonacci-help
;

\ ============================================================
\ Enfoque iterativo (_ite)
\ ============================================================

: sum-first-n-ite ( n -- sum )
    dup 0 <= if
        drop 0
    else
        0 swap
        1+ 0
        ?do
            i +
        loop
    then
;

: factorial-ite ( n -- fact )
    dup 0 <= if
        drop 1
    else
        1 swap
        1+ 1
        ?do
            i *
        loop
    then
;

: fibonacci-ite ( n -- fib )
    dup 0> if
        0 1 rot         \ n acc1 acc2 -> acc1 acc2 n
        0            \ acc1 acc2 n-1 0
        ?do             \ 0 to n-2
            dup rot     \ acc1 acc2 acc2 -> acc2 acc2 acc1
            +           \ acc2 acc2+acc1
        loop
        drop
    then
;

: greatest-common-divisor-ite ( a b -- gcd )
    begin
        dup 0 <>        \ a b b & a b (b != 0)?
    while
        swap over mod   \ b a -> b a b -> b (a % b)
    repeat
    drop
;

: least-common-multiple-ite ( a b -- lcm )
    2dup greatest-common-divisor-rec
    / *
;

