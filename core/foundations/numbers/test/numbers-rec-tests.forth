\ numbers-rec-tests.forth — Suite de pruebas (enfoque recursivo)
\ Especificación: 04_Numbers
\
\ Casos de prueba (11):
\   sum-first-n-rec(0)  = 0
\   sum-first-n-rec(3)  = 6
\   factorial-rec(0)    = 1
\   factorial-rec(4)    = 24
\   fibonacci-rec(0)    = 0
\   fibonacci-rec(1)    = 1
\   fibonacci-rec(6)    = 8
\   greatest-common-divisor-rec(12, 8) = 4
\   greatest-common-divisor-rec(7, 5)  = 1
\   least-common-multiple-rec(4, 6)    = 12
\   least-common-multiple-rec(6, 8)    = 24
\
\ Nota: las dependencias (numbers.forth, test.forth) se cargan desde run-tests.forth

: test-sum-first-n-rec ( -- )
    0 sum-first-n-rec 0 assert-equals
    3 sum-first-n-rec 6 assert-equals
;

: test-factorial-rec ( -- )
    0 factorial-rec 1 assert-equals
    4 factorial-rec 24 assert-equals
;

: test-fibonacci-rec ( -- )
    0 fibonacci-rec 0 assert-equals
    1 fibonacci-rec 1 assert-equals
    6 fibonacci-rec 8 assert-equals
;

: test-greatest-common-divisor-rec ( -- )
    12 8 greatest-common-divisor-rec 4 assert-equals
    7 5 greatest-common-divisor-rec 1 assert-equals
;

: test-least-common-multiple-rec ( -- )
    4 6 least-common-multiple-rec 12 assert-equals
    6 8 least-common-multiple-rec 24 assert-equals
;

: run-rec-tests ( -- )
    test-sum-first-n-rec
    test-factorial-rec
    test-fibonacci-rec
    test-greatest-common-divisor-rec
    test-least-common-multiple-rec
;
