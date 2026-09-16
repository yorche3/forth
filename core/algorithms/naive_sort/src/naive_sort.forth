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
variable min-idx

variable swap-tmp

: swap-cells ( addr1 addr2 -- )
    \ Intercambia los valores de las celdas en addr1 y addr2.
    \ Ojo: `!` es ( x addr -- ), así que los dos valores deben cruzarse.
    dup @ swap-tmp !    \ swap-tmp = valor original de addr2
    over @ swap !       \ addr2 <- valor original de addr1
    swap-tmp @ swap ! ; \ addr1 <- valor original de addr2

: selection-sort ( addr n -- )
    \ Si el array tiene 0 o 1 elementos, devuelve el array tal cual
    dup 1 <= if
        2drop
        exit
    then
    len !
    arr !
    len @ 1- 0 ?do \ i: 0..(len-2)
        i min-idx ! \ min_idx = i
        len @ i 1+ ?do \ dentro del bucle interno: i = j (externo), j = i (interno)
            arr @ i cells + @ \ a[j]
            arr @ min-idx @ cells + @ \ a[j] a[min_idx]
            < if i min-idx ! then \ si a[j] < a[min_idx], min_idx = j
        loop
        i min-idx @ <> if \ intercambia las posiciones i y min_idx
            arr @ i cells +
            arr @ min-idx @ cells +
            swap-cells
        then
    loop
;

variable swapped?

: bubble-sort ( addr count -- )
    dup 1 <= if
        2drop
        exit
    then
    len !
    arr !
    len @ 1- 0 ?do \ i: 0..(len-2)
        false swapped? !
        len @ 1- i - 0 ?do \ dentro del bucle interno: i = j, j = i (externo)
            arr @ i cells + @ \ a[j]
            arr @ i 1+ cells + @ \ a[j] a[j+1]
            2dup > if \ si a[j] > a[j+1], intercambia
                2drop
                arr @ i cells +
                arr @ i 1+ cells +
                swap-cells
                true swapped? !
            else
                2drop
            then
        loop
        swapped? @ 0= if
            leave \ salida temprana: la pasada no hizo ningún intercambio
        then
    loop
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