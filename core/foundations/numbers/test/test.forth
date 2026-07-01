\ test.forth — Framework de testing unitario
\
\ Proporciona:
\   assert-equals  ( actual expected -- )  - Verifica igualdad de enteros

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

: test-report ( -- )
    cr
    s" tests runned " type test-count @ .
    cr
    s" passed " type passed-count @ .
    cr
    s" failed " type failed-count @ .
    cr
;