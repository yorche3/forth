# Numbers — Forth

Implementación de la especificación [04_Numbers](https://yorche3.github.io/programming_languages/core/foundations/04_Numbers/) en **Forth** (Gforth), utilizando un único archivo fuente que aglutina los 3 enfoques y un framework de testing unitario minimalista casero.

---

## 📂 Archivos y estructura / Files & Structure

| Archivo | Propósito |
|---------|-----------|
| [`src/numbers.forth`](src/numbers.forth) | Implementación completa: 5 algoritmos × 3 enfoques (`_rec`, `_acc`, `_ite`) + helpers `_help`. |
| [`test/test.forth`](test/test.forth) | Framework de testing unitario mínimo: `init-tests`, `assert-equals`, `test-report`. |
| [`test/numbers-rec-tests.forth`](test/numbers-rec-tests.forth) | Tests del enfoque recursivo directo (`_rec`) — 11 casos. |
| [`test/numbers-ite-tests.forth`](test/numbers-ite-tests.forth) | Tests del enfoque iterativo (`_ite`) — 11 casos. |
| [`test/run-tests.forth`](test/run-tests.forth) | Punto de entrada: incluye dependencias y ejecuta las 2 suites. |

**Estructura de directorios esperada:**

```text
numbers/
├── src/
│   └── numbers.forth            # Único archivo: 3 enfoques en 1
├── test/
│   ├── test.forth               # Framework de testing unitario
│   ├── numbers-rec-tests.forth  # Tests: enfoque recursivo
│   ├── numbers-ite-tests.forth  # Tests: enfoque iterativo
│   └── run-tests.forth          # Punto de entrada
└── README.md
```

---

## 🛠️ Enfoque y construcción / Approach & Build

**ES:** El proyecto se creó manualmente, sin herramientas de scaffolding. Forth no tiene un sistema de paquetes ni frameworks de testing estándar, por lo que se implementó un `test.forth` casero con las palabras `init-tests`, `assert-equals` y `test-report`. Las suites se separan por enfoque pero todas referencian el mismo `numbers.forth`.

**EN:** The project was created manually, without scaffolding tools. Forth has no package system or standard test framework, so a custom `test.forth` was implemented with `init-tests`, `assert-equals`, and `test-report` words. Test suites are separated by approach but all reference the same `numbers.forth`.

> **Nota:** Los tests del enfoque con acumulador (`_acc`) no se incluyen como suite independiente. En Forth no hay garantía de Tail Call Optimization (TCO), por lo que las versiones con acumulador se conservan únicamente con fines educativos. La validación de su comportamiento se cubre a través de las pruebas de los enfoques recursivo e iterativo, que juntos ejercitan los mismos resultados.

---

## 🚀 Compilación y ejecución / Build & Run

### Ejecutar programa principal / Run main program

Forth es un lenguaje interpretado; no requiere compilación separada:

```bash
gforth src/numbers.forth -e "3 sum-first-n-rec . bye"
```

### Ejecutar pruebas unitarias / Run unit tests

```bash
cd test
gforth run-tests.forth
```

**Salida esperada / Expected output:**

```text
tests runned 22
passed 22
failed 0
```

---

## 🧠 Algoritmos / operaciones

### 3 enfoques × 5 algoritmos = 15 funciones

| Algoritmo | `_rec` | `_acc` | `_ite` |
|-----------|--------|--------|--------|
| `sum-first-n` | ✅ | ✅ | ✅ |
| `factorial` | ✅ | ✅ | ✅ |
| `fibonacci` | ✅ | ✅ | ✅ |
| `greatest-common-divisor` | ✅ | ✅ | ✅ |
| `least-common-multiple` | ✅ | ✅ | ✅ |

### Detalle de funciones

```forth
\ Enfoque recursivo (_rec)
sum-first-n-rec              ( n -- sum )
factorial-rec                ( n -- fact )
fibonacci-rec                ( n -- fib )
greatest-common-divisor-rec  ( a b -- gcd )
least-common-multiple-rec    ( a b -- lcm )

\ Enfoque con acumulador (_acc)
sum-first-n-acc              ( n -- sum )
sum-first-n-help             ( n acc -- sum )
factorial-acc                ( n -- fact )
factorial-help               ( n acc -- fact )
fibonacci-acc                ( n -- fib )
fibonacci-help               ( n acc1 acc2 -- fib )

\ Enfoque iterativo (_ite)
sum-first-n-ite              ( n -- sum )
factorial-ite                ( n -- fact )
fibonacci-ite                ( n -- fib )
greatest-common-divisor-ite  ( a b -- gcd )
least-common-multiple-ite    ( a b -- lcm )
```

---

## 📝 Notas de implementación / Implementation Notes

### 🔁 Sobre recursión con acumulador y Tail Call Optimization (TCO) / On recursion with accumulator and Tail Call Optimization (TCO)

**ES:**

Tail recursion ocurre cuando la llamada recursiva es la última acción que ejecuta una palabra; después de la llamada no hay más instrucciones, la palabra devuelve el resultado de la llamada recursiva. La recursión con acumulador consigue esto pasando el estado previo como parámetro a cada llamada, sin dejar trabajo pendiente en la pila.

En **Forth**, **no se garantiza TCO**. Forth es un estándar minimalista y la optimización de llamadas terminales depende de la implementación específica (Gforth, SwiftForth, etc.). Gforth, en particular, **no realiza TCO** de forma automática.

La implementación con acumulador (`_acc`) se conserva únicamente con fines educativos: sirve como puente conceptual entre la recursión directa (más cercana a la definición matemática) y la versión iterativa (más eficiente). Como no hay un beneficio práctico de rendimiento, no se desarrollan pruebas unitarias específicas para las palabras con acumulador. La validación del comportamiento se cubre a través de las pruebas de los enfoques recursivo e iterativo, que juntos ejercitan los mismos resultados.

**EN:**

Tail recursion occurs when the recursive call is the last action that runs a word; after the call there are no more instructions, the word returns the result of the recursive call. Recursion with accumulator achieves this by passing the previous state as a parameter to each call, without leaving any pending work on the stack.

In **Forth**, **TCO is not guaranteed**. Forth is a minimal standard and tail call optimization depends on the specific implementation (Gforth, SwiftForth, etc.). Gforth, in particular, **does not perform TCO** automatically.

The accumulator implementation (`_acc`) is preserved only for educational purposes: it serves as a conceptual bridge between the direct recursive (closer to mathematical definition) and the iterative version (more efficient). Since there is no practical performance benefit, no specific unit tests are developed for the recursive methods with accumulator.

### ⚠️ Peculiaridades de Forth / Forth Peculiarities

- **Comparaciones**: En Forth, `<=` es `( n1 n2 -- flag )` y devuelve true si `n1 <= n2` (n1 es el tope de pila). Por eso `n 0<=` funciona como palabra nativa para verificar `n <= 0`, mientras que `dup 0 <=` compararía `0 <= n` (siempre true para n ≥ 0).
- **Pila de retorno**: Las palabras `>r` y `r>` permiten usar la pila de retorno para almacenar valores temporales, necesario en las versiones con acumulador para preservar el estado entre llamadas recursivas.
- **`recurse`**: Forth usa `recurse` (no el nombre de la palabra) para hacer llamadas recursivas, permitiendo que la palabra se renombre sin romper la recursión.

---

### 🌐 Otras implementaciones / Other implementations

Este proyecto también está implementado en otros lenguajes. Explora el [repositorio principal](https://github.com/yorche3/programming_languages) para ver todas las versiones.

---

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
