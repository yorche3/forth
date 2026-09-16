\ naive_sort.forth — Módulo Naive Sort con ordenamientos elementales
\
\ Especificación: 05_Naive_Sort
\
\ Algoritmos:
\   selection-sort  — encuentra el mínimo y lo coloca al inicio (O(n^2))
\   bubble-sort     — compara e intercambia adyacentes, con bandera swapped
\   insertion-sort  — inserta cada elemento en su sub-array ordenado
\
\ Contrato común (addr count -- ):
\   Ordena in-place las `count` celdas a partir de `addr`, de menor a mayor.
\   Con count 0 o 1 no modifica nada.
\
\ Caso nulo: Forth no tiene null/nil y no existe representación de array nulo,
\ por lo que el caso inválido de la especificación se omite.

variable arr
variable len

: swap-cells ( addr1 addr2 -- )
    \ Intercambia los valores de las celdas en addr1 y addr2
    over @ over @ rot ! swap ! ;

: selection-sort ( addr n -- )
    \ Si el array tiene 0 o 1 elementos, devuelve el array tal cual
    dup 1 <= if
        2drop
        exit
    then
    len !
    arr !
    len @ 1- 0 ?do \ i: 0..(len-2);
        i          \ min_idx = i
        len @ i 1+ ?do \ j: (i+1)..(len-1);
            arr @ min_idx cells + @ \ ( min_idx arr[j] )
            over arr @ swap-cells + @ \ ( min_idx arr[j] a[min_idx] )
            < if drop i then \ if arr[j] < arr[min_idx], update min_idx
        loop
        \ stack : ( min_idx );
        arr @ i cells + \ ( min_idx addr_i )
        swap            \ ( addr_i min_idx )
        arr @ swap cells + \ ( addr_i addr_min_idx )
        swap-cells \ Intercambia los elementos en las posiciones i y min_idx
    loop
;

: bubble-sort ( addr count -- )
    dup 1 <= if
        2drop
        exit
    then
    len !
    arr !
    len @ 0 ?do
        len @ 1- 0 ?do
            arr @ j cells + @ arr @ j 1+ cells + @
            2dup <
            if
                swap-cells
            then
        loop
    loop
;


variable swapped?

: insertion-sort ( addr count -- )
    dup 1 <= if
        2drop
        exit
    then
    begin
        false swapped? !
        len @ 1- 0 ?do
            arr @ j cells + @ 
            arr @ j 1+ cells + @
            2dup < if
                2drop
                arr @ j cells +
                arr @ j 1+ cells +
                swap-cells
                true swapped? !
            then
        loop
    again \ Repite hasta que no haya más intercambios
;

variable ins-key
variable ins-j

: insertion-sort ( addr n -- )
  dup 1 <= if 2drop exit then
  len ! arr !
  len @ 1 ?do                       \ i: 1..n-1
    arr @ i cells + @ ins-key !     \ key = a[i]
    i 1- ins-j !                    \ j = i - 1
    begin
      ins-j @ 0 >=
      if
        arr @ ins-j @ cells + @ ins-key @ >   \ j >= 0 and a[j] > key
      else
        false
      then
    while
      \ desplazar a[j] a a[j+1]
      arr @ ins-j @ cells + @       \ a[j]
      arr @ ins-j @ 1+ cells + !    \ a[j+1] = a[j]
      ins-j @ 1- ins-j !            \ j = j - 1
    repeat
    ins-key @
    arr @ ins-j @ 1+ cells + !      \ a[j+1] = key
  loop ;