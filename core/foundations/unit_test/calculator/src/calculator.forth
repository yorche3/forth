\ calculator.forth — Módulo Calculator con operaciones aritméticas básicas
\
\ Implementaciones educativas:
\   multiplication: suma repetitiva (no usa *)
\   division: resta repetitiva (no usa /)
\   modulus: usa division y multiplication (no usa mod)

\ addition ( a b -- a+b )
: addition ( a b -- c )
    +
;

\ subtraction ( a b -- a-b )
: subtraction ( a b -- c )
    -
;

\ multiplication ( a b -- a*b )
\ Implementación educativa: suma repetitiva.
: multiplication ( a b -- c )
    0 swap 0                \ c = 0 -> pila (a c=0 b i=0)
    ?do                     \ from 0 to b-1 -> pila (a c=0)
        over addition       \ pila (a c=c+a) //internal i=i+1
    loop
    nip                     \ remove a -> pila (c)
;

\ division ( a b -- quotient )
\ Implementación educativa: resta repetitiva.
\ Cuenta cuántas veces cabe b en a mediante restas sucesivas.
: division ( a b -- quotient )
    0 >r            \ pila (a b) | pila-ret (quotient=0)
    begin
        over over >=  \ pila (a b) | pila-ret (quotient=0) if a >= b
    while
        swap over subtraction \ pila (b a) -> pila (b a b) -> pila (b a=a-b)
        r> 1 addition >r    \ pila-ret (quotient=quotient+1)
        swap                \ pila (a=a-b b)
    repeat
    drop drop r>
;

\ modulus ( a b -- remainder )
\ Implementación: resto = a - (cociente * b) usando funciones propias
: modulus ( a b -- remainder )
    \ Pila: a b
    2dup               \ a b a b
    division           \ a b quotient
    >r >r              \ a             (pila ret: quotient, b)
    r>                 \ a b
    r>                 \ a b quotient
    multiplication      \ a (b*quotient)
    subtraction         \ a - (b*quotient) = remainder
;

