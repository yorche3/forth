# Data Structures Basics — Forth

Implementación de la especificación [06_Data_Structures_Basics](https://yorche3.github.io/programming_languages/core/algorithms/06_Data_Structures_Basics/) en **Forth** (Gforth 0.7.3), con un único archivo fuente y el runner de pruebas casero del repositorio.

Implementation of the [06_Data_Structures_Basics](https://yorche3.github.io/programming_languages/core/algorithms/06_Data_Structures_Basics/) specification in **Forth** (Gforth 0.7.3), with a single source file and the repository's custom test runner.

**ES:** La celda enlazada compartida (`Node`) y los tres ADT —lista enlazada, pila y cola— se implementan a mano sobre bloques de celdas que reserva quien llama. No se usa ninguna colección de la biblioteca estándar: Forth no tiene tipos contenedores y el módulo no delega unas estructuras en otras.

**EN:** The shared linked cell (`Node`) and the three ADTs —linked list, stack and queue— are implemented by hand over blocks of cells reserved by the caller. No standard-library collection is used: Forth has no container types and the module does not delegate one structure to another.

---

## 📂 Archivos y estructura / Files & Structure

| Archivo / File | Propósito / Purpose |
|---|---|
| [`src/data_structures_basics.forth`](src/data_structures_basics.forth) | Las 23 palabras del contrato, el ayudante `new-node` y las variables de recorrido / The contract's 23 words, the `new-node` helper and the traversal variables |
| [`test/test.forth`](test/test.forth) | Framework de testing unitario: `init-tests`, `set-label`, `append-label`, `assert-equals`, `test-report` / Minimal unit-test framework |
| [`test/data-structures-basics-tests.forth`](test/data-structures-basics-tests.forth) | Suite: los 15 casos de la especificación × las 23 operaciones / Suite: the specification's 15 cases × the 23 operations |
| [`test/run-tests.forth`](test/run-tests.forth) | Punto de entrada: carga el módulo y el framework, y ejecuta la suite / Entry point: loads the module and the framework, and runs the suite |

**Estructura de directorios / Directory structure:**

```text
data_structures_basics/
├── src/
│   └── data_structures_basics.forth   # Módulo: Node, LinkedList, Stack, Queue
├── test/
│   ├── test.forth                     # Framework de testing unitario
│   ├── data-structures-basics-tests.forth  # 15 casos × 23 operaciones
│   └── run-tests.forth                # Punto de entrada
└── README.md
```

**Desviación respecto a la ubicación esperada / Deviation from expected location:**

**ES:** La especificación propone `src/data_structures_basics.ext`, `test/data_structures_basics_test.ext` y `test/run_tests.ext`. Aquí se usa la extensión `.forth` y el *naming* `kebab-case` de las palabras, que es la convención del lenguaje y la que ya sigue `core/algorithms/naive_sort/`. El punto de entrada **sí** existe (`test/run-tests.forth`) y se añade `test/test.forth` con el framework, igual que en `naive_sort/` y `numbers/`.

**EN:** The specification suggests `src/data_structures_basics.ext`, `test/data_structures_basics_test.ext` and `test/run_tests.ext`. This module uses the `.forth` extension and the language's `kebab-case` word naming, the convention already followed by `core/algorithms/naive_sort/`. The entry point **does** exist (`test/run-tests.forth`) and `test/test.forth` is added with the framework, as in `naive_sort/` and `numbers/`.

**Las instancias las reserva la suite / Instances are reserved by the suite:**

**ES:** Forth no declara tipos, así que el «tipo nuevo» del módulo se declara con **cuatro constantes de tamaño en celdas** —`/node`, `/linked-list`, `/stack`, `/queue`— más el reparto de campos documentado en la cabecera del fuente. Quien llama reserva el bloque (`create … allot`) y pasa su dirección a cada palabra.

**EN:** Forth does not declare types, so the module's "new type" is declared with **four size constants in cells** —`/node`, `/linked-list`, `/stack`, `/queue`— plus the field layout documented in the source header. The caller reserves the block (`create … allot`) and passes its address to every word.

```forth
\ Reparto de celdas / Cell layout
\   node        celda 0 = valor, celda 1 = dirección del siguiente (0 = sin enlace)
\   linked-list celda 0 = cabeza, celda 1 = cola, celda 2 = contador
\   stack       celda 0 = tope, celda 1 = contador
\   queue       celda 0 = frente, celda 1 = cola, celda 2 = contador

2 cells constant /node
3 cells constant /linked-list
2 cells constant /stack
3 cells constant /queue
```

---

## 🛠️ Enfoque y construcción / Approach & Build

**ES:** El proyecto se creó a mano, sin herramientas de *scaffolding*. Forth no tiene gestor de paquetes ni framework de pruebas estándar, así que se reutiliza el esquema del repositorio: un runner casero (`test/test.forth`), un archivo de suites y un punto de entrada.

Las celdas enlazadas se reservan en el montón con `allocate` (`new-node`), porque el contrato no impone ninguna capacidad y un *pool* estático lo incumpliría. Los ADT guardan punteros y contador dentro del bloque de la instancia y **no** delegan en `LinkedList`: cada uno enlaza sus celdas con las palabras del `Node`.

**EN:** The project was created by hand, without scaffolding tools. Forth has no package manager or standard test framework, so the repository's scheme is reused: a custom runner (`test/test.forth`), a suites file and an entry point.

Linked cells are reserved on the heap with `allocate` (`new-node`), because the contract imposes no capacity and a static pool would breach it. The ADTs keep pointers and a counter inside the instance block and do **not** delegate to `LinkedList`: each one links its cells with the `Node` words.

```bash
mkdir -p src test
```

---

## 📄 Configuración clave / Key Configuration

**ES:** No aplica: Forth se interpreta directamente con `gforth` y no hay manifiesto, fichero de construcción ni dependencias. La única configuración es la del propio fuente: las constantes de tamaño y el reparto de campos de la sección anterior. El contrato completo son las palabras siguientes, con su efecto en la pila.

**EN:** Not applicable: Forth is interpreted directly with `gforth` and there is no manifest, build file or dependencies. The only configuration is the source's own: the size constants and the field layout from the previous section. The full contract is the following words, with their stack effect.

```forth
\ Node
node-init        ( node value -- )
node-get-value   ( node -- value )
node-get-next    ( node -- next )
node-set-next    ( node next -- )

\ LinkedList
linked-list-init        ( list -- )
linked-list-get-head    ( list -- value )
linked-list-insert-head ( list value -- )
linked-list-insert-tail ( list value -- )
linked-list-delete      ( list value -- success )
linked-list-is-empty    ( list -- flag )
linked-list-size        ( list -- count )

\ Stack
stack-init     ( stack -- )
stack-push     ( stack value -- )
stack-pop      ( stack -- value )
stack-peek     ( stack -- value )
stack-is-empty ( stack -- flag )
stack-size     ( stack -- count )

\ Queue
queue-init     ( queue -- )
queue-enqueue  ( queue value -- )
queue-dequeue  ( queue -- value )
queue-peek     ( queue -- value )
queue-is-empty ( queue -- flag )
queue-size     ( queue -- count )
```

---

## 🚀 Compilación y ejecución / Build & Run

Forth es interpretado; no hay compilación separada.

### Cargar el módulo / Load the module

```bash
gforth -e "include src/data_structures_basics.forth bye"
```

**Salida real / Actual output:** sin salida, código de salida `0` (el módulo carga sin errores ni avisos).

### Ejecutar pruebas unitarias / Run unit tests

```bash
cd test
gforth run-tests.forth
```

**Salida real / Actual output:**

```text
tests runned 114
passed 114
failed 0
```

> **Nota:** el runner imprime un espacio final tras cada número. Se ha recortado aquí para no dejar espacios colgando en el Markdown.

**ES:** Salida copiada de la última ejecución real del 2026-10-03. El acta de evidencia del sprint se encuentra en [`docs/evidence/algorithms/data_structures_basics/forth.md`](https://github.com/yorche3/programming_languages/blob/main/docs/evidence/algorithms/data_structures_basics/forth.md).

**EN:** Output copied from the last real run on 2026-10-03. The sprint evidence record is at [`docs/evidence/algorithms/data_structures_basics/forth.md`](https://github.com/yorche3/programming_languages/blob/main/docs/evidence/algorithms/data_structures_basics/forth.md).

---

## 🧠 Algoritmos y operaciones / Algorithms & Operations

| Operación / Operation | Entrada → salida / Input → output | Complejidad / Complexity | Notas / Notes |
|---|---|---|---|
| `node-init` | `node value → —` | `O(1)` | Escribe valor y deja el enlace ausente / Writes the value and leaves the link absent. |
| `node-get-value` | `node → value` | `O(1)` | Lee la celda 0; no muta / Reads cell 0; does not mutate. |
| `node-get-next` | `node → next` | `O(1)` | Dirección nula `0` si no hay enlace / Null address `0` when there is no link. |
| `node-set-next` | `node next → —` | `O(1)` | Enlaza en el sitio (Forth es mutable) / Links in place (Forth is mutable). |
| `linked-list-init` | `list → —` | `O(1)` | Cabeza, cola y contador a cero / Head, tail and counter to zero. |
| `linked-list-get-head` | `list → value` | `O(1)` | `-1` si la lista está vacía / `-1` when the list is empty. |
| `linked-list-insert-head` | `list value → —` | `O(1)` | Enlaza delante de la cabeza / Links before the head. |
| `linked-list-insert-tail` | `list value → —` | `O(1)` | Usa el puntero de cola guardado / Uses the stored tail pointer. |
| `linked-list-delete` | `list value → success` | `O(n)` | Primera aparición; bandera verdadera o falsa / First occurrence; true or false flag. |
| `linked-list-is-empty` | `list → flag` | `O(1)` | Contador a cero / Counter equals zero. |
| `linked-list-size` | `list → count` | `O(1)` | Contador guardado / Stored counter. |
| `stack-init` | `stack → —` | `O(1)` | Tope ausente y contador a cero / Absent top and zero counter. |
| `stack-push` | `stack value → —` | `O(1)` | El nodo nuevo apunta al tope anterior / The new cell points to the previous top. |
| `stack-pop` | `stack → value` | `O(1)` | Retira el tope; `-1` si está vacía / Removes the top; `-1` when empty. |
| `stack-peek` | `stack → value` | `O(1)` | Observa el tope sin retirarlo / Observes the top without removing it. |
| `stack-is-empty` | `stack → flag` | `O(1)` | Contador a cero / Counter equals zero. |
| `stack-size` | `stack → count` | `O(1)` | Contador guardado / Stored counter. |
| `queue-init` | `queue → —` | `O(1)` | Frente y cola ausentes, contador a cero / Absent front and rear, zero counter. |
| `queue-enqueue` | `queue value → —` | `O(1)` | Enlaza tras la cola y la actualiza / Links after the rear and updates it. |
| `queue-dequeue` | `queue → value` | `O(1)` | Retira el frente; `-1` si está vacía / Removes the front; `-1` when empty. |
| `queue-peek` | `queue → value` | `O(1)` | Observa el frente sin retirarlo / Observes the front without removing it. |
| `queue-is-empty` | `queue → flag` | `O(1)` | Contador a cero / Counter equals zero. |
| `queue-size` | `queue → count` | `O(1)` | Contador guardado / Stored counter. |

---

## 🧩 Decisiones de diseño / Design decisions

| Decisión / Decision | Alternativa considerada / Alternative | Razón / Reason |
|---|---|---|
| Instancias reservadas por quien llama / Instances reserved by the caller | Que el módulo reserve la instancia y devuelva un puntero / The module reserving the instance and returning a pointer | El módulo no guarda ningún registro global y quien llama controla la memoria; las constantes de tamaño son la declaración del tipo en Forth / The module keeps no global registry and the caller controls memory; the size constants are Forth's type declaration. |
| Celdas reservadas con `allocate` / Cells reserved with `allocate` | Un *pool* estático con `create … allot` / A static pool with `create … allot` | Un *pool* fijo introduce una capacidad que la especificación prohíbe / A fixed pool introduces the capacity the specification forbids. |
| Estado de los recorridos en variables del diccionario / Traversal state in dictionary variables | Locales de Gforth (`{ … }`) / Gforth locals (`{ … }`) | El Forth estándar no tiene locales y el módulo homologado (`naive_sort`) usa variables; el lector no necesita conocer una extensión / Standard Forth has no locals and the sibling module (`naive_sort`) uses variables; the reader needs no extension. |
| Un test por operación con ejecutor compartido y tabla de dueños / One test per operation with a shared executor and an owner table | Un test por estructura con un escenario y todas sus aserciones / One test per structure with a scenario and all its assertions | Da un test por operación sin duplicar el escenario, y el fallo nombra la operación y el caso (`linked-list-delete should absent value`) / It gives one test per operation without duplicating the scenario, and failures name the operation and the case. |
| Recorridos comprobados sobre una instancia de replay / Traversals checked on a replay instance | Vaciar la instancia del escenario / Draining the scenario instance | El único modo de avanzar es `get_head` + `delete`; vaciar el escenario lo rompería para los casos siguientes / The only way to advance is `get_head` + `delete`; draining the scenario would break the following cases. |
| `-1` como indicador de fallo de los valores / `-1` as the value failure indicator | `0`, que es la dirección nula / `0`, the null address | `0` es una dirección válida para el enlace ausente y podría confundirse con un valor; `-1` coincide además con los otros lenguajes del módulo / `0` is a valid address for the absent link and could be confused with a value; `-1` also matches the module's other languages. |

---

## 🔀 Adaptaciones idiomáticas / Idiomatic adaptations

| Especificación / Specification | Adaptación / Adaptation | Justificación / Justification |
|---|---|---|
| `Node`, `LinkedList`, `Stack` y `Queue` son tipos nuevos / `Node`, `LinkedList`, `Stack` and `Queue` are new types | Cuatro constantes de tamaño en celdas y un reparto de campos documentado / Four size constants in cells and a documented field layout | Forth no declara tipos: la forma del registro se documenta y las palabras de acceso la fijan / Forth does not declare types: the record shape is documented and the accessor words pin it down. |
| `init(value)` y `init()` inicializan la instancia / `init(value)` and `init()` initialise the instance | El valor vive en el bloque que reserva quien llama / The value lives in the block reserved by the caller | Forth no tiene constructores; `create … allot` reserva y la palabra `init` escribe el estado inicial / Forth has no constructors; `create … allot` reserves and the `init` word writes the initial state. |
| `set_next(next)` «devuelve un nodo nuevo si el lenguaje es inmutable» / `set_next(next)` "returns a new node when the language is immutable" | Escribe el enlace en la celda existente / Writes the link into the existing cell | Forth es mutable: la celda conserva su identidad y ninguna operación devuelve copias / Forth is mutable: the cell keeps its identity and no operation returns copies. |
| Variables locales del pseudocódigo (`previous`, `current`, `top`, `rear`) / Pseudocode local variables | Variables del diccionario (`ll-previous`, `ll-current`, `st-base`, …) / Dictionary variables | El Forth estándar no tiene locales y es el estilo ya usado en `naive_sort` / Standard Forth has no locals and this is the style already used by `naive_sort`. |
| Ausencia de enlace como «representación nativa» / Absent link as the "native representation" | Dirección nula `0` / Null address `0` | Forth no tiene `null`/`nil`; la dirección `0` no apunta a ninguna celda y es el centinela habitual / Forth has no `null`/`nil`; address `0` points to no cell and is the usual sentinel. |
| Caso nulo o entrada inválida / Null case or invalid input | **No aplica / Not applicable** | La especificación 06 no define entrada nula: sus casos son pasos sobre el mismo estado y todos los valores son enteros positivos / Specification 06 defines no null input: its cases are steps on the same state and every value is a positive integer. |
| Ciclo de vida de las celdas / Cell lifetime | Se reservan y no se liberan / They are reserved and never freed | El contrato no expone ninguna operación de destrucción; ver _Limitaciones conocidas_ / The contract exposes no destruction operation; see _Known limitations_. |
| `src/data_structures_basics.ext`, `test/…_test.ext`, `run_tests.ext` | `src/data_structures_basics.forth`, `test/data-structures-basics-tests.forth`, `test/run-tests.forth` + `test/test.forth` | Extensión y *naming* del lenguaje, y runner casero del repositorio / The language's extension and naming, and the repository's custom runner. |

---

## 🚨 Indicadores de fallo / Failure indicators

| Operación / Operation | Situación de fallo / Failure situation | Indicador / Indicator | Ejemplo / Example |
|---|---|---|---|
| `node-get-next` | Enlace ausente / Absent link | Dirección nula `0` / Null address `0` | `a node-get-next` → `0` |
| `linked-list-get-head` | Lista vacía / Empty list | `-1` | `l linked-list-get-head` → `-1` |
| `linked-list-delete` | Valor ausente / Absent value | `0` (falso); éxito `-1` (verdadero) / `0` (false); success `-1` (true) | `l 99 linked-list-delete` → `0` |
| `stack-pop` | Pila vacía / Empty stack | `-1` (el tope no se modifica si la pila ya estaba vacía / the top is unchanged when the stack was already empty) | `s stack-pop` → `-1` |
| `stack-peek` | Pila vacía / Empty stack | `-1` | `s stack-peek` → `-1` |
| `queue-dequeue` | Cola vacía / Empty queue | `-1` | `q queue-dequeue` → `-1` |
| `queue-peek` | Cola vacía / Empty queue | `-1` | `q queue-peek` → `-1` |
| Caso nulo o inválido / Null or invalid input | — | **No aplica / Not applicable** | La especificación no define entrada nula / The specification defines no null input |

**ES:** Las banderas usan el par del lenguaje: `-1` verdadero, `0` falso. `linked-list-is-empty`, `stack-is-empty` y `queue-is-empty` devuelven ese par, no un booleano propio.

**EN:** Flags use the language's own pair: `-1` true, `0` false. `linked-list-is-empty`, `stack-is-empty` and `queue-is-empty` return that pair, not a custom boolean.

---

## ✅ Cobertura de pruebas / Test coverage

**ES:** Los 15 casos de la especificación se aplican a las 23 operaciones: cada test reproduce el escenario completo de su ADT y solo comprueba las aserciones de la operación bajo prueba. La columna _Prueba_ nombra las palabras que comprueban cada caso.

**EN:** The 15 specification cases apply to the 23 operations: every test replays its ADT's full scenario and asserts only the assertions owned by the operation under test. The _Test_ column names the words that check each case.

| Caso de la especificación / Specification case | Cubierto / Covered | Prueba / Test | Notas / Notes |
|---|---|:--:|---|
| Node: initialize and observe value/link | Sí / Yes | `test-node-init`, `test-node-get-value`, `test-node-get-next` | `get_value` = 10; `get_next` = `0` |
| Node: initialize another node, link and traverse | Sí / Yes | `test-node-set-next`, `test-node-get-next`, `test-node-get-value` | El enlace es la celda `b`; `get_value(get_next(a))` = 20 |
| LinkedList: empty state | Sí / Yes | `test-linked-list-init`, `test-linked-list-is-empty`, `test-linked-list-size`, `test-linked-list-get-head` | `true`, `0`, `-1` |
| LinkedList: insert at both ends | Sí / Yes | `test-linked-list-insert-head`, `test-linked-list-insert-tail`, `test-linked-list-size`, `test-linked-list-get-head` | `size` = 4 y recorrido `5, 10, 20, 10` |
| LinkedList: delete first occurrence | Sí / Yes | `test-linked-list-delete`, `test-linked-list-size`, `test-linked-list-get-head` | Éxito; recorrido `5, 20, 10`; `size` = 3 |
| LinkedList: absent value | Sí / Yes | `test-linked-list-delete`, `test-linked-list-size`, `test-linked-list-get-head` | Fallo; recorrido y tamaño no cambian |
| LinkedList: empty the list | Sí / Yes | `test-linked-list-delete`, `test-linked-list-is-empty`, `test-linked-list-size`, `test-linked-list-get-head` | Tres borrados con éxito; `true`, `0`, `-1` |
| Stack: empty state and failed removal | Sí / Yes | `test-stack-init`, `test-stack-is-empty`, `test-stack-size`, `test-stack-peek`, `test-stack-pop` | `true`, `0`; `peek` y `pop` = `-1` |
| Stack: LIFO and non-mutating `peek` | Sí / Yes | `test-stack-push`, `test-stack-peek`, `test-stack-size` | `peek` = 30; `size` = 3 |
| Stack: removal and reuse | Sí / Yes | `test-stack-pop`, `test-stack-push`, `test-stack-is-empty`, `test-stack-size` | Resultados `30, 40, 20, 10`; `true`, `0` |
| Stack: empty after removal | Sí / Yes | `test-stack-pop`, `test-stack-is-empty` | `pop` = `-1`; sigue vacía / stays empty |
| Queue: empty state and failed removal | Sí / Yes | `test-queue-init`, `test-queue-is-empty`, `test-queue-size`, `test-queue-peek`, `test-queue-dequeue` | `true`, `0`; `peek` y `dequeue` = `-1` |
| Queue: FIFO and non-mutating `peek` | Sí / Yes | `test-queue-enqueue`, `test-queue-peek`, `test-queue-size` | `peek` = 10; `size` = 3 |
| Queue: removal and reuse | Sí / Yes | `test-queue-dequeue`, `test-queue-enqueue`, `test-queue-is-empty`, `test-queue-size` | Resultados `10, 20, 30, 40`; `true`, `0` |
| Queue: empty after removal | Sí / Yes | `test-queue-dequeue`, `test-queue-is-empty` | `dequeue` = `-1`; sigue vacía / stays empty |

**ES:** Total: **114 aserciones** repartidas en **23 tests** (uno por operación), sin casos omitidos.

**EN:** Total: **114 assertions** across **23 tests** (one per operation), with no omitted cases.

---

## ⚠️ Limitaciones conocidas / Known limitations

| Limitación / Limitation | Impacto / Impact | Alternativa o plan / Workaround or plan |
|---|---|---|
| Las celdas reservadas con `allocate` no se liberan / Cells reserved with `allocate` are never freed | Cada inserción o encolado deja memoria retenida hasta que termina el proceso / Every insertion or enqueue retains memory until the process ends | El contrato no expone ninguna operación de destrucción; añadir `free` sería una operación fuera de la especificación / The contract exposes no destruction operation; adding `free` would be an operation outside the specification. |
| Las palabras no son reentrantes / The words are not reentrant | Dos recorridos simultáneos sobre el mismo ADT se pisarían el estado intermedio / Two simultaneous traversals of the same ADT would overwrite each other's intermediate state | El estado vive en variables del diccionario, como en `naive_sort`; Forth estándar no ofrece otra cosa sin extensiones / State lives in dictionary variables, as in `naive_sort`; standard Forth offers nothing else without extensions. |
| `allocate throw` aborta si el montón se agota / `allocate throw` aborts when the heap is exhausted | Sin memoria, la palabra no devuelve un indicador: la excepción termina la interpretación / With no memory, the word returns no indicator: the exception ends interpretation | Es el contrato de `allocate` en Forth; la especificación no pide un caso de fallo por límite de capacidad / This is `allocate`'s contract in Forth; the specification asks for no capacity-limit failure case. |

---

## 📝 Notas de implementación / Implementation Notes

### 🧱 La celda y el reparto de campos / The cell and the field layout

**ES:** `Node` es dos celdas contiguas: valor y dirección del siguiente. Los tres ADT guardan direcciones de celdas (no valores) y un contador; `linked-list` y `queue` guardan además la cola, lo que deja las inserciones al final en `O(1)` sin recorrer la cadena. Todas las palabras reciben la **dirección** de la instancia, nunca su contenido.

**EN:** `Node` is two contiguous cells: value and the address of the next one. The three ADTs keep cell addresses (not values) and a counter; `linked-list` and `queue` also keep the tail, which leaves tail insertions at `O(1)` with no chain walk. Every word receives the instance's **address**, never its contents.

### ⚠️ El orden de `!` importa / `!` argument order matters

**ES:** `!` es `( x addr -- )`: el **valor** va debajo y la **dirección** arriba. Por eso `node-set-next` es `swap cell+ !`: sin el `swap`, `cell+` se aplicaría al enlace y no al nodo, y el enlace se escribiría en la celda equivocada. El mismo cuidado aparece en `stack-push` y en las inserciones al final.

**EN:** `!` is `( x addr -- )`: the **value** goes below and the **address** on top. That is why `node-set-next` is `swap cell+ !`: without the `swap`, `cell+` would apply to the link instead of the node and the link would be written into the wrong cell. The same care appears in `stack-push` and in tail insertions.

### 🧷 Conservar la dirección de la instancia / Keeping the instance address

**ES:** Las inserciones necesitan la dirección de la estructura dos veces (campo y contador) mientras usan una celda nueva. El patrón es `new-node >r  r@ over …  r> drop`: el `r@` copia la celda recién creada y `r> drop` equilibra la pila de retorno antes de salir.

**EN:** Insertions need the structure's address twice (field and counter) while using a fresh cell. The pattern is `new-node >r  r@ over …  r> drop`: `r@` copies the newly created cell and `r> drop` balances the return stack before returning.

### 🧪 Cómo funciona la suite / How the suite works

**ES:** El escenario de cada ADT se reproduce una vez por operación. Cada aserción declara sus **dueños** (`owners` / `owned?` / `assert-for`) y solo se comprueba cuando la operación bajo prueba está entre ellos; así hay un test por operación sin duplicar el escenario ni renunciar al estado compartido que pide la especificación. Los recorridos se comprueban **vaciando una instancia de replay** (`drain-replay`, con tope de `max-traversal` elementos para que una implementación que no elimine no cuelgue la suite), nunca la instancia del escenario.

**EN:** Each ADT's scenario is replayed once per operation. Every assertion declares its **owners** (`owners` / `owned?` / `assert-for`) and is checked only when the operation under test is among them; this yields one test per operation without duplicating the scenario or giving up the shared state the specification asks for. Traversals are checked by **draining a replay instance** (`drain-replay`, capped at `max-traversal` elements so an implementation that fails to remove cannot hang the suite), never the scenario instance.

### 💾 Memoria / Memory

**ES:** Cada inserción reserva una celda con `allocate` y ninguna operación la libera: el contrato no tiene `destroy` ni `free`. El borrado desengancha la celda pero no la devuelve al montón.

**EN:** Every insertion reserves a cell with `allocate` and no operation frees it: the contract has no `destroy` or `free`. Delete unlinks the cell but does not return it to the heap.

### 🚫 Caso nulo / Null case

**ES:** **No aplica.** La especificación 06 no define ninguna entrada nula o inválida; sus casos son pasos sucesivos sobre el mismo estado y todos los valores son enteros positivos que no chocan con el indicador de fallo `-1`. La ausencia que sí existe —el enlace de una celda— usa la dirección nula `0`, declarada en la cabecera del fuente.

**EN:** **Not applicable.** Specification 06 defines no null or invalid input; its cases are successive steps on the same state and every value is a positive integer that does not collide with the `-1` failure indicator. The one absence that does exist —a cell's link— uses the null address `0`, declared in the source header.

### 📁 Desviación de ubicación y nombres / Location and naming deviation

**ES:** La especificación espera `src/data_structures_basics.ext`, `test/data_structures_basics_test.ext` y `test/run_tests.ext`. Forth usa la extensión `.forth` y el *naming* `kebab-case` (`data-structures-basics-tests.forth`), que es la convención del lenguaje y la que ya seguían `numbers/` y `naive_sort/`. El punto de entrada **sí** existe y se añade `test/test.forth` con el framework, igual que en los dos módulos citados.

**EN:** The specification expects `src/data_structures_basics.ext`, `test/data_structures_basics_test.ext` and `test/run_tests.ext`. Forth uses the `.forth` extension and `kebab-case` naming (`data-structures-basics-tests.forth`), the language convention already followed by `numbers/` and `naive_sort/`. The entry point **does** exist and `test/test.forth` is added with the framework, as in both cited modules.

---

### 🌐 Otras implementaciones / Other implementations

Este proyecto también está implementado en otros lenguajes. Explora el [repositorio principal](https://github.com/yorche3/programming_languages) para ver todas las versiones.

This project is also implemented in other languages. Explore the [main repository](https://github.com/yorche3/programming_languages) to see all the versions.

---

## 🔍 Checklist de validación / Validation checklist

- [x] La suite nativa se ejecutó y su salida real está copiada en este README / Native suite was executed and its real output is copied into this README.
- [x] Cada caso de la especificación tiene su fila en _Cobertura de pruebas_ (o `Omitido` con razón) / Each specification case has its row in _Test coverage_ (or `Omitted` with reason).
- [x] Cada desviación del pseudocódigo o de la ubicación esperada está en _Adaptaciones idiomáticas_ / Each deviation from pseudocode or expected location is in _Idiomatic adaptations_.
- [x] Cada operación con fallo posible está en _Indicadores de fallo_ / Each operation with potential failure is in _Failure indicators_.
- [x] No hay rutas absolutas del autor, credenciales ni salidas inventadas / No author absolute paths, credentials, or fabricated outputs.
- [x] Los enlaces relativos resuelven dentro del repositorio y el documento es bilingüe / Relative links resolve within repository and document is bilingual.
- [x] Ninguna sección repite lo que ya dice la especificación / No section repeats what the specification already states.

---

## 📚 Referencias / References

| Tipo / Kind | Referencia / Reference |
|---|---|
| Especificación / Specification | [`06_Data_Structures_Basics.md`](https://yorche3.github.io/programming_languages/core/algorithms/06_Data_Structures_Basics/) |
| Acta de evidencia / Evidence record | [`docs/evidence/algorithms/data_structures_basics/forth.md`](https://github.com/yorche3/programming_languages/blob/main/docs/evidence/algorithms/data_structures_basics/forth.md) |
| Módulo homologado del lenguaje / Homologated module | [`../naive_sort/README.md`](../naive_sort/README.md) |
| Guía de inicialización / Initialisation guide | [`core/00_Project_Initialization_Guide.md`](https://yorche3.github.io/programming_languages/core/00_Project_Initialization_Guide/) |
| Adaptaciones idiomáticas / Idiomatic adaptations | [`AGENT_Template.md`](https://yorche3.github.io/programming_languages/AGENT_Template/) |
| Validación de la documentación / Documentation validation | [`WORKFLOW.md`](https://yorche3.github.io/programming_languages/WORKFLOW/) |
| Plantilla del README / README template | [`README_Template.md`](https://yorche3.github.io/programming_languages/README_Template/) |
| Documentación oficial del lenguaje / Language official docs | [Gforth Manual](https://gforth.org/manual/) |

---

*[← Volver a Algorithms Pure](../README.md) | [↑ Volver a Forth Core](../../README.md)*

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
