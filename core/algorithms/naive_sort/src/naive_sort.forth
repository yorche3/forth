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
