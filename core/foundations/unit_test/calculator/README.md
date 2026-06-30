# Calculator — Forth

Implementación de la especificación [03_Unit_Test_Calculator](https://yorche3.github.io/programming_languages/core/foundations/03_Unit_Test_Calculator/) en **Forth**, ejecutado con **Gforth**.

---

## 📂 Archivos y estructura / Files & Structure

### Raíz del proyecto / Project root

| Archivo | Propósito |
|---------|-----------|
| [`src/calculator.forth`](src/calculator.forth) | Implementación — 5 operaciones aritméticas básicas. |

### Pruebas / Tests (`test/`)

| Archivo | Propósito |
|---------|-----------|
| [`test/test.forth`](test/test.forth) | Framework de testing — `assert-equals`, `assert-compare`, `test-report`. |
| [`test/calculator_tests.forth`](test/calculator_tests.forth) | Suite de pruebas — 5 tests con `assert-equals`. |
| [`test/run_tests.forth`](test/run_tests.forth) | Punto de entrada para ejecutar las pruebas. |

**Estructura de directorios esperada:**

```text
calculator/
├── src/
│   └── calculator.forth         # Implementación — 5 operaciones aritméticas
├── test/
│   ├── test.forth               # Framework de testing
│   ├── calculator_tests.forth   # Suite de pruebas unitarias
│   └── run_tests.forth          # Punto de entrada
└── README.md                    # Este archivo
```

---

## 🛠️ Enfoque y construcción / Approach & Build

**ES:** Este proyecto usa **Gforth** y sigue un enfoque minimalista. No requiere sistema de compilación ni gestor de paquetes — el código se ejecuta directamente con `gforth`.

Características:
- **Sin dependencias externas** — todo usa palabras nativas de Forth.
- **Framework de testing propio** — `test.forth` implementa `assert-equals`, `assert-compare` y `test-report` sin librerías externas.
- **Ejecución directa** — `gforth test/run_tests.forth` ejecuta todas las pruebas.

**EN:** This project uses **Gforth** and follows a minimalist approach. No build system or package manager required — the code runs directly with `gforth`.

Features:
- **No external dependencies** — everything uses native Forth words.
- **Custom test framework** — `test.forth` implements `assert-equals`, `assert-compare` and `test-report` with no external libraries.
- **Direct execution** — `gforth test/run_tests.forth` runs all tests.

---

## 📄 Archivos de configuración clave / Key Configuration Files

### `src/calculator.forth` — Implementación

**ES:** Contiene las 5 operaciones aritméticas. `multiplication` usa suma repetitiva (`?do`/`loop`), `division` usa resta repetitiva (`begin`/`while`/`repeat`), y `modulus` se define en términos de `division` y `multiplication`, cumpliendo la especificación educativa.

**EN:** Contains the 5 arithmetic operations. `multiplication` uses repeated addition (`?do`/`loop`), `division` uses repeated subtraction (`begin`/`while`/`repeat`), and `modulus` is defined in terms of `division` and `multiplication`, complying with the educational specification.

```forth
\ addition ( a b -- a+b )
: addition ( a b -- c ) + ;

\ subtraction ( a b -- a-b )
: subtraction ( a b -- c ) - ;

\ multiplication ( a b -- a*b )
: multiplication ( a b -- c )
    0 swap 0
    ?do over addition loop
    nip
;

\ division ( a b -- quotient )
: division ( a b -- quotient )
    0 >r
    begin over over >= while
        swap over subtraction
        r> 1 addition >r
        swap
    repeat
    drop drop r>
;

\ modulus ( a b -- remainder )
: modulus ( a b -- remainder )
    2dup division >r >r r> r>
    multiplication subtraction
;
```

### `test/test.forth` — Framework de testing

**ES:** Proporciona las palabras necesarias para definir y ejecutar pruebas unitarias con contadores y reporte de resultados.

**EN:** Provides the words needed to define and run unit tests with counters and result reporting.

```forth
variable test-count
variable passed-count
variable failed-count

: init-tests ( -- )
    0 test-count !  0 passed-count !  0 failed-count !
;

: assert-equals ( actual expected -- )
    test-count @ 1 + test-count !
    2dup = if 2drop passed-count @ 1 + passed-count !
    else failed-count @ 1 + failed-count !
        s"   [FAIL] Expected: " type . s"  but got: " type . cr
    then
;

: test-report ( -- )
    cr s" Tests run: " type test-count @ .
    s" , Passed: " type passed-count @ .
    s" , Failed: " type failed-count @ . cr
;
```

### `test/calculator_tests.forth` — Pruebas unitarias

**ES:** Define 5 tests, uno por operación, y la palabra `run-calculator-tests` que los ejecuta todos y muestra el reporte.

**EN:** Defines 5 tests, one per operation, and the `run-calculator-tests` word that runs them all and shows the report.

```forth
include ../src/calculator.forth
include test.forth

: test-addition ( -- )       2 3 addition 5 assert-equals ;
: test-subtraction ( -- )    5 2 subtraction 3 assert-equals ;
: test-multiplication ( -- ) 3 4 multiplication 12 assert-equals ;
: test-division ( -- )       10 3 division 3 assert-equals ;
: test-modulus ( -- )        10 3 modulus 1 assert-equals ;

: run-calculator-tests ( -- )
    init-tests
    test-addition  test-subtraction  test-multiplication
    test-division  test-modulus
    test-report
;
```

### `test/run_tests.forth` — Punto de entrada

**ES:** Incluye la suite y ejecuta todos los tests.

**EN:** Includes the test suite and runs all tests.

```forth
include calculator_tests.forth
run-calculator-tests
bye
```

---

## 🚀 Compilación y ejecución / Build & Run

### Requisito: Tener Gforth instalado

```bash
# Linux (Debian/Ubuntu)
sudo apt install gforth

# macOS (con Homebrew)
brew install gforth

# Windows
# Descargar desde: https://gforth.org/
```

### Ejecutar pruebas unitarias

```bash
cd core/foundations/unit_test/calculator/test
gforth run_tests.forth
```

**Salida esperada / Expected output:**

```text
Tests run: 5 , Passed: 5 , Failed: 0
```

> **ES:** Los 5 tests deben pasar (5 passed, 0 failed).
> **EN:** All 5 tests must pass (5 passed, 0 failed).

---

## 🧠 Algoritmos / operaciones (según el módulo)

| Función | Implementación | Cumple |
|---------|---------------|--------|
| `addition(a, b)` | `a + b` (suma directa) | ✅ |
| `subtraction(a, b)` | `a - b` (resta directa) | ✅ |
| `multiplication(a, b)` | Suma repetitiva de `a`, `b` veces con `?do`/`loop` | ✅ No usa `*` |
| `division(a, b)` | Resta repetitiva con `begin`/`while`: cuántas veces cabe `b` en `a` | ✅ No usa `/` |
| `modulus(a, b)` | `a - multiplication(division(a, b), b)` | ✅ No usa `mod` |

---

## 📝 Notas de implementación / Implementation Notes

- **ES:** Forth no tiene un gestor de paquetes estándar como npm o pip. El framework de testing (`test.forth`) es una implementación casera que cubre las necesidades del proyecto.
- **EN:** Forth doesn't have a standard package manager like npm or pip. The test framework (`test.forth`) is a custom implementation that covers the project's needs.
- **ES:** Las funciones `multiplication` y `division` están implementadas con sumas/restas repetitivas para cumplir la especificación educativa (no usar operadores `*` ni `/` directos).
- **EN:** The `multiplication` and `division` functions are implemented with repeated addition/subtraction to comply with the educational specification (no direct `*` or `/` operators).
- **ES:** `modulus` usa `multiplication` y `division` (definidas por el usuario) en lugar del operador nativo `mod` de Forth.
- **EN:** `modulus` uses `multiplication` and `division` (user-defined) instead of Forth's native `mod` operator.

---

### 🌐 Otras implementaciones / Other implementations

Este proyecto también está implementado en otros lenguajes. Explora el [repositorio principal](https://github.com/yorche3/programming_languages) para ver todas las versiones.

---

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
