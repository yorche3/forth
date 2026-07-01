\ numbers-ite-tests.forth — Suite de pruebas (enfoque iterativo)
\
\ Especificación: 04_Numbers
\
\ Casos de prueba (11):
\   sum-first-n-ite(0)  = 0
\   sum-first-n-ite(3)  = 6
\   factorial-ite(0)    = 1
\   factorial-ite(4)    = 24
\   fibonacci-ite(0)    = 0
\   fibonacci-ite(1)    = 1
\   fibonacci-ite(6)    = 8
\   greatest-common-divisor-ite(12, 8) = 4
\   greatest-common-divisor-ite(7, 5)  = 1
\   least-common-multiple-ite(4, 6)    = 12
\   least-common-multiple-ite(6, 8)    = 24
\
\ Nota: las dependencias (numbers.forth, test.forth) se cargan desde run-tests.forth




: test-sum-first-n-ite ( -- )
    0 sum-first-n-ite 0 assert-equals
    3 sum-first-n-ite 6 assert-equals
;

: test-factorial-ite ( -- )
    0 factorial-ite 1 assert-equals
    4 factorial-ite 24 assert-equals
;

: test-fibonacci-ite ( -- )
    0 fibonacci-ite 0 assert-equals
    1 fibonacci-ite 1 assert-equals
    6 fibonacci-ite 8 assert-equals
;

: test-greatest-common-divisor-ite ( -- )
    12 8 greatest-common-divisor-ite 4 assert-equals
    7 5 greatest-common-divisor-ite 1 assert-equals
;

: test-least-common-multiple-ite ( -- )
    4 6 least-common-multiple-ite 12 assert-equals
    6 8 least-common-multiple-ite 24 assert-equals
;

: run-ite-tests ( -- )
    test-sum-first-n-ite
    test-factorial-ite
    test-fibonacci-ite
    test-greatest-common-divisor-ite
    test-least-common-multiple-ite
;
