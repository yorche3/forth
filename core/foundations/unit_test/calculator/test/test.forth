\ test.forth — Framework de testing unitario
\
\ Proporciona:
\   assert-equals  ( actual expected -- )  - Verifica igualdad de enteros
\   assert-compare ( addr1 n1 addr2 n2 -- ) - Verifica igualdad de cadenas
variable test-count
variable passed-count
variable failed-count

: init-tests ( -- )
    0 test-count !
    0 passed-count !
    0 failed-count !
;

: assert-equals ( actual expected -- )
    test-count @ 1 + test-count !
    2dup = if
        2drop
        passed-count @ 1 + passed-count !
    else
        failed-count @ 1 + failed-count !
        cr s"   [FAIL] Expected: " type .
        s"  but got: " type . cr
    then
;

: assert-compare ( addr1 n1 addr2 n2 -- )
    test-count @ 1 + test-count !
    2over 2over
    compare 0= if
        2drop 2drop
        passed-count @ 1 + passed-count !
    else
        failed-count @ 1 + failed-count !
        cr s"   [FAIL] Expected: " type .
        s"  but got: " type . cr
    then
;

: test-report ( -- )
    cr
    s" Tests run: " type test-count @ .
    s" , Passed: " type passed-count @ .
    s" , Failed: " type failed-count @ .
    cr
;

