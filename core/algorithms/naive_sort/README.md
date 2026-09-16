# Naive Sort — Forth

Implementación de la especificación [05_Naive_Sort](https://yorche3.github.io/programming_languages/core/algorithms/05_Naive_Sort/) en **Forth** (Gforth), con un único archivo fuente y un framework de testing unitario minimalista casero.

Implementa los tres algoritmos elementales de ordenamiento ($O(n^2)$) — **Selection Sort**, **Bubble Sort** e **Insertion Sort** — sobre celdas de memoria, sin usar la palabra `sort` de `lib/` ni ninguna rutina de ordenamiento del sistema.

---

## 📂 Archivos y estructura / Files & Structure

| Archivo | Propósito |
|---------|-----------|
| [`src/naive_sort.forth`](src/naive_sort.forth) | Las 3 palabras del contrato + el helper `swap-cells`. |
| [`test/test.forth`](test/test.forth) | Framework de testing unitario mínimo: `init-tests`, `set-label`, `append-label`, `assert-equals`, `test-report`. |
| [`test/naive-sort-tests.forth`](test/naive-sort-tests.forth) | Suites de prueba — los 7 casos × 3 algoritmos. |
| [`test/run-tests.forth`](test/run-tests.forth) | Punto de entrada: incluye dependencias y ejecuta las suites. |

**Estructura de directorios esperada:**

```text
naive_sort/
├── src/
│   └── naive_sort.forth           # Único archivo fuente
├── test/
│   ├── test.forth                 # Framework de testing unitario
│   ├── naive-sort-tests.forth     # 7 casos × 3 algoritmos
│   └── run-tests.forth            # Punto de entrada
└── README.md
```

---

## 🛠️ Enfoque y construcción / Approach & Build

**ES:** El proyecto se creó manualmente, sin herramientas de scaffolding (`mkdir -p src test`). Forth no tiene un sistema de paquetes ni un framework de testing estándar, así que se reutiliza el mismo esquema que `core/foundations/numbers/`: un runner casero `test.forth` más un archivo de suites y un punto de entrada.

A diferencia de `numbers`, cuyo contrato es una palabra por valor, aquí la especificación exige entradas de longitud variable (0, 1, 5 y 6 elementos). Eso no se puede expresar con aridad fija, así que el contrato es **`( addr count -- )`**: ordena **in-place** las `count` celdas a partir de `addr`.

**EN:** The project was created manually, without scaffolding tools (`mkdir -p src test`). Forth has no package system or standard test framework, so it reuses the same scheme as `core/foundations/numbers/`: a custom `test.forth` runner plus a suites file and an entry point.

Unlike `numbers`, whose contract is one word per value, this specification requires variable-length inputs (0, 1, 5 and 6 elements). That cannot be expressed with fixed arity, so the contract is **`( addr count -- )`**: it sorts **in-place** the `count` cells starting at `addr`.

```bash
mkdir -p src test
```

---

## 📄 Configuración clave / Key Configuration

### `src/naive_sort.forth` — Contrato del módulo

**ES:** Las tres palabras del contrato son la única API. El helper `swap-cells` queda como palabra interna y el estado de los bucles vive en variables globales (`arr`, `len`, `min-idx`, `swapped?`, `ins-key`, `ins-j`), que es el equivalente en Forth a las locales de otros lenguajes.

**EN:** The three contract words are the only API. The `swap-cells` helper stays internal and loop state lives in global variables (`arr`, `len`, `min-idx`, `swapped?`, `ins-key`, `ins-j`), which is Forth's equivalent of locals in other languages.

```forth
selection-sort  ( addr n -- )      \ selection, bubble e insertion
bubble-sort     ( addr count -- )
insertion-sort  ( addr n -- )
```

### `test/test.forth` — Framework de testing

**ES:** Se parte del runner de `numbers` (`init-tests`, `assert-equals`, `test-report`) y se añade una etiqueta, porque el runner original no identifica el caso que falla. `set-label` guarda el prefijo y `append-label` lo completa, de modo que cada fallo se imprime como `"{algoritmo} should sort {caso}"`.

**EN:** It starts from the `numbers` runner (`init-tests`, `assert-equals`, `test-report`) and adds a label, because the original runner does not identify the failing case. `set-label` stores the prefix and `append-label` completes it, so each failure prints as `"{algorithm} should sort {case}"`.

```forth
: assert-equals ( actual expected -- )
    test-count @ 1 + test-count !
    2dup = if
        2drop
        passed-count @ 1 + passed-count !
    else
        ...  \ imprime "[FAIL] <etiqueta>: Expected: <e> but got: <a>"
    then ;
```

### `test/naive-sort-tests.forth` — Suites

**ES:** Los siete casos se declaran como fixtures con nombre (`in-standard`, `out-standard`, …) y un único helper `assert-sorts-all-cases ( xt c-addr u -- )` genera un test por caso para cualquier algoritmo. Como los algoritmos ordenan in-place, cada caso copia su fixture al buffer `work` antes de ordenar.

**EN:** The seven cases are declared as named fixtures (`in-standard`, `out-standard`, …) and a single `assert-sorts-all-cases ( xt c-addr u -- )` helper generates one test per case for any algorithm. Since the algorithms sort in place, every case copies its fixture into the `work` buffer before sorting.

```forth
: assert-sorts-all-cases ( xt c-addr u -- )
    save-algo-name
    algo-xt !
    in-standard   6  out-standard   s" an unsorted array"              run-case
    in-sorted     5  out-sorted     s" an already sorted array"        run-case
    ...
;
```

---

## 🚀 Compilación y ejecución / Build & Run

Forth es interpretado; no hay compilación separada.

### Cargar el módulo / Load the module

```bash
gforth -e "include src/naive_sort.forth bye"
```

**Salida real / Actual output:** sin salida, código de salida `0` (el módulo carga sin errores).

### Ejecutar pruebas unitarias / Run unit tests

```bash
cd test
gforth run-tests.forth
```

**Salida real / Actual output:**

```text
tests runned 78
passed 78
failed 0
```

> **Nota:** el runner imprime un espacio final tras cada número. Se ha recortado aquí para no dejar espacios colgando en el Markdown.

---

## 🧠 Algoritmos / operaciones

| Palabra | Estrategia | Complejidad | In-place | Tests |
|---------|-----------|-------------|:--------:|:-----:|
| `selection-sort` | Busca el mínimo del tramo no ordenado (índice en `min-idx`) y lo intercambia con la posición `i` | $O(n^2)$ siempre | ✅ | 7 |
| `bubble-sort` | Compara e intercambia adyacentes; sale antes si una pasada no intercambia nada (`swapped?`) | $O(n^2)$ peor/promedio, $O(n)$ mejor | ✅ | 7 |
| `insertion-sort` | Guarda `a[i]` en `ins-key` y desplaza el tramo ordenado con `ins-j` | $O(n^2)$ peor/promedio, $O(n)$ mejor | ✅ | 7 |

| Palabra / Variable | Papel |
|--------------------|-------|
| `swap-cells ( addr1 addr2 -- )` | Intercambia el contenido de dos celdas. |
| `arr`, `len` | Dirección base y número de celdas del array en curso. |
| `min-idx` | Índice del mínimo en `selection-sort`. |
| `swapped?` | Bandera de intercambio de `bubble-sort` (salida temprana). |
| `ins-key`, `ins-j` | Clave e índice de desplazamiento en `insertion-sort`. |

**Casos cubiertos:** array desordenado, ya ordenado, en orden inverso, elementos idénticos, con negativos, un solo elemento y array vacío.

---

## 📝 Notas de implementación / Implementation Notes

### 🔁 Divergencias idiomáticas respecto al pseudocódigo / Idiomatic divergences from the pseudocode

| Pseudocódigo | Forth | Motivo / Reason |
|--------------|-------|-----------------|
| `selection_sort(arr)` con `arr` como valor | `( addr count -- )` | Forth no tiene tipo array: una secuencia es una dirección más un número de celdas / Forth has no array type |
| `return arr` | No devuelve nada: muta la memoria | El array ya es una dirección; ordenar in-place es el equivalente / The array is already an address |
| Variables locales `min_idx`, `key`, `j`, `swapped` | Variables globales | Forth estándar no tiene locales; las de Gforth son una extensión / Standard Forth has no locals |
| Bucles `for`/`while` | `?do … loop` y `begin … while … repeat` | Construcciones de bucle de Forth / Forth loop constructs |
| `if min_idx != i` (evita el swap) | `i min-idx @ <> if` | Mismo guardado explícito / Same explicit guard |

### 🪆 Índices en bucles anidados / Indices in nested loops

**ES:** En Forth, dentro de un `?do` anidado `i` es el índice **interno** y `j` el **externo**. `selection-sort` y `bubble-sort` usan `i` como índice interno, que es lo que el pseudocódigo llama `j`; el índice externo (`i` del pseudocódigo) no se necesita dentro del bucle interno porque `min-idx` y `swapped?` lo guardan en variables.

**EN:** In Forth, inside a nested `?do` the letter `i` is the **inner** index and `j` is the **outer** one. `selection-sort` and `bubble-sort` use `i` as the inner index, which is what the pseudocode calls `j`; the outer index (the pseudocode's `i`) is not needed inside the inner loop because `min-idx` and `swapped?` keep it in variables.

### ⚠️ El orden de `!` importa / `!` argument order matters

**ES:** `!` es `( x addr -- )`: el **valor** va debajo y la **dirección** arriba. Un intercambio ingenuo que reutilice los dos valores sin cruzarlos acaba escribiendo cada valor en su propia celda (un no-op silencioso). `swap-cells` conserva el valor de `addr2` en `swap-tmp` y luego cruza los dos almacenamientos.

**EN:** `!` is `( x addr -- )`: the **value** goes below and the **address** on top. A naive swap that reuses both values without crossing them ends up writing each value back into its own cell (a silent no-op). `swap-cells` keeps the value of `addr2` in `swap-tmp` and then crosses the two stores.

### 🚫 Caso nulo / Null case

**ES:** El caso nulo de la especificación **se omite** porque Forth no tiene `null`/`nil` y no existe representación de array inválido: `addr` y `count` son siempre dos celdas. La justificación está documentada en `src/naive_sort.forth` y en `test/naive-sort-tests.forth`.

**EN:** The specification's null case **is omitted** because Forth has no `null`/`nil` and there is no invalid-array representation: `addr` and `count` are always two cells. The rationale is documented in `src/naive_sort.forth` and `test/naive-sort-tests.forth`.

### 📁 Desviación de ubicación y nombres / Location and naming deviation

**ES:** La especificación espera `src/naive_sort.ext` y `test/naive_sort_test.ext`. Forth usa la extensión `.forth` y el *naming* `kebab-case` de las palabras (`naive-sort-tests.forth`), que es la convención del lenguaje y la que ya sigue `core/foundations/numbers/` (`numbers-rec-tests.forth`). El punto de entrada **sí** existe (`test/run-tests.forth`), y se añade un archivo `test/test.forth` con el framework, igual que en `numbers/`.

**EN:** The specification expects `src/naive_sort.ext` and `test/naive_sort_test.ext`. Forth uses the `.forth` extension and the `kebab-case` word naming (`naive-sort-tests.forth`), which is the language convention already followed by `core/foundations/numbers/` (`numbers-rec-tests.forth`). The entry point **does** exist (`test/run-tests.forth`), and a `test/test.forth` file with the framework is added, as in `numbers/`.

---

### 🌐 Otras implementaciones / Other implementations

Este proyecto también está implementado en otros lenguajes. Explora el [repositorio principal](https://github.com/yorche3/programming_languages) para ver todas las versiones.

---

*[← Volver a Algorithms Pure](README.md) | [↑ Volver a Forth Core](../../README.md)*

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
