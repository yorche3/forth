# Data Structures Advanced — Forth

Implementación de la especificación [07_Data_Structures_Advanced](https://yorche3.github.io/programming_languages/core/algorithms/07_Data_Structures_Advanced/) en **Forth** (Gforth 0.7.3), con un único archivo fuente y el runner de pruebas casero del repositorio.

Implementation of the [07_Data_Structures_Advanced](https://yorche3.github.io/programming_languages/core/algorithms/07_Data_Structures_Advanced/) specification in **Forth** (Gforth 0.7.3), with a single source file and the repository's custom test runner.

**ES:** El módulo implementa un árbol binario de búsqueda (`BinaryTree` sobre `TreeNode`) y un grafo dirigido con vértices explícitos (`Graph` sobre `GraphNode`). Forth no declara tipos ni clases; la base `Node` con el valor se modela como **valor embebido** en cada nodo hijo en la celda 0, sin un tipo base independiente ni herencia. Las estructuras se asignan sobre bloques de celdas y no se delega el registro ni las adyacencias en colecciones de la biblioteca estándar.

**EN:** The module implements a binary search tree (`BinaryTree` over `TreeNode`) and a directed graph with explicit vertices (`Graph` over `GraphNode`). Forth does not declare types or classes; the `Node` value base is modeled as an **embedded value** in each child node at cell 0, with no independent base type or inheritance. Structures are allocated over blocks of cells, and neither the registry nor adjacencies delegate to standard-library collections.

---

## 📂 Archivos y estructura / Files & Structure

| Archivo / File | Propósito / Purpose |
|---|---|
| [`src/data_structures_advanced.forth`](src/data_structures_advanced.forth) | Implementación de las palabras de `TreeNode`, `BinaryTree`, `GraphNode` y `Graph`, constantes de tamaño y ayudantes de adyacencia / Implementation of `TreeNode`, `BinaryTree`, `GraphNode`, and `Graph` words, size constants, and adjacency helpers |
| [`test/test.forth`](test/test.forth) | Framework de testing unitario: `init-tests`, `set-label`, `assert-equals`, `test-report` / Minimal unit-test framework |
| [`test/data-structures-advanced-tests.forth`](test/data-structures-advanced-tests.forth) | Suite: 23 casos ejecutables (24 de la especificación menos adaptación inmutable no representable) con 180 aserciones / Suite: 23 executable test cases (24 from specification minus unrepresentable immutable adaptation) with 180 assertions |
| [`test/run-tests.forth`](test/run-tests.forth) | Punto de entrada: carga dependencias, ejecuta los tests y reporta el resultado / Entry point: loads dependencies, runs the tests, and reports results |
| `.gitignore` | Reglas de exclusión de archivos temporales de Git / Git ignore rules |

**Estructura de directorios / Directory structure:**

```text
data_structures_advanced/
├── src/
│   └── data_structures_advanced.forth       # Implementación: TreeNode, BinaryTree, GraphNode, Graph
├── test/
│   ├── test.forth                           # Framework de testing unitario
│   ├── data-structures-advanced-tests.forth # 23 casos de prueba ejecutables
│   └── run-tests.forth                      # Punto de entrada
├── .gitignore                               # Ignorados por Git
└── README.md
```

**Desviación respecto a la ubicación esperada / Deviation from expected location:**

**ES:** La especificación propone `src/data_structures_advanced.ext`, `test/data_structures_advanced_test.ext` y `test/run_tests.ext`. Aquí se utiliza la extensión `.forth` y la convención de nomenclatura `kebab-case` para palabras y archivos de test (`data-structures-advanced-tests.forth`, `run-tests.forth`), consistente con `data_structures_basics/`, `naive_sort/` y `numbers/`. Se incluye `test/test.forth` con el framework casero común.

**EN:** The specification suggests `src/data_structures_advanced.ext`, `test/data_structures_advanced_test.ext`, and `test/run_tests.ext`. Here the `.forth` extension and `kebab-case` naming convention are used for words and test files (`data-structures-advanced-tests.forth`, `run-tests.forth`), consistent with `data_structures_basics/`, `naive_sort/`, and `numbers/`. `test/test.forth` is included providing the shared custom framework.

**Reparto de celdas / Cell layout:**

**ES:** En Forth los registros se gestionan mediante bloques de memoria contiguos. Las constantes de tamaño definen el número de celdas requeridas:

**EN:** In Forth records are managed through contiguous memory blocks. Size constants define the number of required cells:

```forth
3 cells constant /tree-node     \ celda 0: valor, celda 1: izquierdo, celda 2: derecho
2 cells constant /binary-tree   \ celda 0: raiz, celda 1: contador
3 cells constant /graph-node    \ celda 0: etiqueta, celda 1: bloque vecinos, celda 2: siguiente vertice
3 cells constant /graph         \ celda 0: cabeza de vertices, celda 1: contador vertices, celda 2: contador aristas
```

---

## 🛠️ Enfoque y construcción / Approach & Build

**ES:** El módulo se diseñó e implementó manualmente, sin herramientas de scaffolding ni dependencias externas. Se sigue el enfoque idiomático de Forth:
- La base `Node` se implementa como **valor embebido** en la primera celda de `TreeNode` y `GraphNode`, satisfaciendo la opción formal de la especificación sin simular herencia inexistente.
- Los nodos de árbol (`tree-node`) y los vértices del grafo (`graph-node`) se asignan dinámicamente en el heap con `allocate`.
- El registro canónico de vértices de `Graph` es una lista enlazada simple construida y recorrida manualmente en `find-graph-node`, sin usar tablas hash ni diccionarios.
- La secuencia de vecinos de cada vértice se almacena en un bloque dinámico propio de celdas contiguas donde la celda 0 indica la cantidad y las siguientes contienen las etiquetas vecinas ordenadas ascendentemente y sin duplicados. Al añadir aristas, se reasigna el bloque en orden manual mediante `nb-insert`.
- `graph-get-neighbors` asigna y devuelve una copia nueva en heap para aislar la representación interna; quien llama debe liberar la dirección devuelta con `free`.

**EN:** The module was designed and implemented manually without scaffolding tools or external dependencies. It follows the idiomatic Forth approach:
- The `Node` base is implemented as an **embedded value** in the first cell of `TreeNode` and `GraphNode`, fulfilling the specification's explicit option without simulating nonexistent inheritance.
- Tree nodes (`tree-node`) and graph vertices (`graph-node`) are dynamically allocated on the heap using `allocate`.
- The canonical vertex registry of `Graph` is a singly linked list constructed and traversed manually in `find-graph-node`, without hash tables or dictionaries.
- Each vertex's neighbor sequence is stored in a dedicated contiguous heap block where cell 0 stores the count and subsequent cells contain sorted, deduplicated neighbor labels. When adding edges, the block is reallocated in manual sorted order via `nb-insert`.
- `graph-get-neighbors` allocates and returns a fresh copy on the heap to isolate internal representation; callers free non-null addresses with `free`.

---

## 📄 Configuración clave / Key Configuration

**ES:** No aplica: Forth es interpretado directamente con Gforth (`gforth 0.7.3`) y no utiliza archivos de manifiesto, gestor de dependencias ni proyectos de construcción.

**EN:** Not applicable: Forth is directly interpreted with Gforth (`gforth 0.7.3`) and uses no manifest files, package managers, or build project files.

---

## 🚀 Compilación y ejecución / Build & Run

### Verificación estática y carga / Static check and load

```bash
gforth -e "warnings on" src/data_structures_advanced.forth -e bye
```

**Salida real / Actual output:** sin salida, código de salida `0` (el módulo carga limpiamente sin errores ni advertencias).

### Ejecutar pruebas unitarias / Run unit tests

```bash
cd test
gforth run-tests.forth
```

**Salida real / Actual output:**

```text

tests runned 180 
passed 180 
failed 0 
```

---

## 🧠 Algoritmos y operaciones / Algorithms & Operations

| Operación / Operation | Entrada → salida / Input → output | Complejidad / Complexity | Notas / Notes |
|---|---|---|---|
| `tree-node-init` | `node value → —` | `O(1)` | Inicializa valor embebido y enlaces izquierdo/derecho en `0` (ausentes) / Initialises embedded value and left/right links to `0` (absent). |
| `tree-node-get-value` | `node → value` | `O(1)` | Lee la celda 0 / Reads cell 0. |
| `tree-node-get-left` | `node → left` | `O(1)` | Retorna dirección de hijo izquierdo o `0` / Returns left child address or `0`. |
| `tree-node-get-right` | `node → right` | `O(1)` | Retorna dirección de hijo derecho o `0` / Returns right child address or `0`. |
| `tree-node-set-left` | `node left → —` | `O(1)` | Modifica el enlace izquierdo in-place / Updates left link in-place. |
| `tree-node-set-right` | `node right → —` | `O(1)` | Modifica el enlace derecho in-place / Updates right link in-place. |
| `binary-tree-init` | `tree → —` | `O(1)` | Raíz a `0` y contador a `0` / Root to `0` and count to `0`. |
| `binary-tree-insert` | `tree value → success` | `O(h)` | Inserción en ABB; ignora duplicados sin alterar tamaño; retorna `-1` (éxito) / BST insertion; ignores duplicates without increasing size; returns `-1` (success). |
| `binary-tree-contains` | `tree value → flag` | `O(h)` | Búsqueda por ramas del ABB; bandera `-1` (encontrado) o `0` (ausente) / BST branch lookup; flag `-1` (found) or `0` (absent). |
| `binary-tree-is-empty` | `tree → flag` | `O(1)` | Comprueba si el contador es `0` / Checks if counter is `0`. |
| `binary-tree-size` | `tree → count` | `O(1)` | Retorna el contador almacenado / Returns stored count. |
| `graph-node-init` | `node label → —` | `O(1)` | Inicializa etiqueta embebida, bloque vecinos a `0` y siguiente a `0` / Initialises embedded label, neighbors block to `0`, and next to `0`. |
| `graph-init` | `graph → —` | `O(1)` | Cabeza de vértices a `0`, contadores de vértices y aristas a `0` / Vertex head to `0`, vertex and edge counters to `0`. |
| `graph-add-vertex` | `graph label → success` | `O(V)` | Registro canónico enlazado manual; idempotente ante duplicados / Manual linked canonical registry; idempotent on duplicate. |
| `graph-add-edge` | `graph u v → success` | `O(V + d(u))` | Exige extremos existentes; bucles y duplicados soportados; adyacencia ordenada / Requires existing endpoints; loops and duplicates supported; sorted adjacency. |
| `graph-has-edge` | `graph u v → flag` | `O(V + d(u))` | Búsqueda de `u` y escaneo lineal de vecinos ordenados / Lookup of `u` and linear scan of sorted neighbors. |
| `graph-get-neighbors` | `graph u → addr count success` | `O(V + d(u))` | Copia aislada en heap de vecinos; `success = 0` si `u` no existe / Isolated heap copy of neighbors; `success = 0` if `u` missing. |
| `graph-is-empty` | `graph → flag` | `O(1)` | Comprueba si la cabeza de vértices es `0` / Checks if vertex head is `0`. |
| `graph-vertex-count` | `graph → count` | `O(1)` | Retorna el número de vértices registrados / Returns count of registered vertices. |
| `graph-edge-count` | `graph → count` | `O(1)` | Retorna el número de aristas dirigidas / Returns count of directed edges. |

---

## 🧩 Decisiones de diseño / Design decisions

| Decisión / Decision | Alternativa considerada / Alternative | Razón / Reason |
|---|---|---|
| Base `Node` como valor embebido en celda 0 / `Node` base as embedded value in cell 0 | Emular herencia mediante punteros a una estructura base / Emulating inheritance via pointers to a base structure | Forth no dispone de herencia nativa y la especificación declara explícitamente el valor embebido como forma válida; evita indirecciones innecesarias / Forth lacks native inheritance and the specification explicitly allows embedded values; avoids unnecessary indirection. |
| Bloque contiguo reasignable para vecinos / Contiguous reallocatable block for neighbors | Lista enlazada de vecinos / Linked list of neighbors | Un bloque compacto con contador en celda 0 simplifica la copia defensiva requerida por la especificación y optimiza la lectura contigua / A compact block with count at cell 0 simplifies defensive copying required by the specification and optimizes contiguous reads. |
| Retorno triple `( addr count success )` en `graph-get-neighbors` / Triple return `( addr count success )` in `graph-get-neighbors` | Retornar solo dirección nula `0` ante fallo / Returning only null address `0` on failure | Permite distinguir inequívocamente entre un vértice inexistente (`success = 0`) y un vértice existente sin vecinos (`count = 0, success = -1`) / Allows distinguishing unambiguously between a missing vertex (`success = 0`) and an existing vertex with empty neighbors (`count = 0, success = -1`). |
| Inserción de vértices al frente de la lista / Vertex insertion at the front of the list | Inserción al final con puntero a cola / Tail insertion with tail pointer | `add_vertex` tiene complejidad `O(V)` por la verificación previa de duplicados; insertar al frente requiere solo `O(1)` tras la búsqueda y ahorra un puntero por grafo / `add_vertex` has `O(V)` complexity due to duplicate checking; front insertion requires `O(1)` after lookup and saves a pointer per graph. |

---

## 🔀 Adaptaciones idiomáticas / Idiomatic adaptations

| Especificación / Specification | Adaptación / Adaptation | Justificación / Justification |
|---|---|---|
| `TreeNode` y `GraphNode` derivan de `Node(value)` / `TreeNode` and `GraphNode` derive from `Node(value)` | Valor embebido en la celda 0 del bloque / Embedded value in cell 0 of block | Forth no tiene herencia de tipos; la especificación permite expresamente la reutilización por valor embebido / Forth lacks type inheritance; the specification explicitly allows embedded value reuse. |
| Adaptación inmutable de `TreeNode` / Immutable adaptation of `TreeNode` | **Omitido / Omitted** | Las celdas en Forth son mutables; no existe representación inmutable en el lenguaje para `TreeNode` / Cells in Forth are mutable; there is no immutable representation in the language for `TreeNode`. |
| Ausencia de enlaces (`null`/`nil`) / Absence of links (`null`/`nil`) | Dirección nula `0` / Null address `0` | Forth no tiene `null` nativo; la dirección `0` representa ausencia de nodo o bloque / Forth has no native `null`; address `0` represents absence of node or block. |
| Banderas booleanas / Boolean flags | `-1` para verdadero (`true`), `0` para falso (`false`) / `-1` for true, `0` for false | Convención y representación canónica estándar de banderas en Forth / Forth's standard canonical flag convention and representation. |
| `src/data_structures_advanced.ext`, `test/data_structures_advanced_test.ext`, `run_tests.ext` | `src/data_structures_advanced.forth`, `test/data-structures-advanced-tests.forth`, `test/run-tests.forth` + `test/test.forth` | Extensión `.forth` y estilo `kebab-case` idiomáticos del repositorio / `.forth` extension and idiomatic `kebab-case` naming for the repository. |

---

## 🚨 Indicadores de fallo / Failure indicators

| Operación / Operation | Situación de fallo / Failure situation | Indicador / Indicator | Ejemplo / Example |
|---|---|---|---|
| `tree-node-get-left` | Enlace izquierdo ausente / Absent left link | `0` (dirección nula) / `0` (null address) | `node tree-node-get-left` → `0` |
| `tree-node-get-right` | Enlace derecho ausente / Absent right link | `0` (dirección nula) / `0` (null address) | `node tree-node-get-right` → `0` |
| `binary-tree-contains` | Valor ausente en árbol / Absent value in tree | `0` (`false`) | `tree 99 binary-tree-contains` → `0` |
| `graph-add-edge` | Al menos un extremo no existe / At least one endpoint missing | `0` (`false`) | `graph 10 99 graph-add-edge` → `0` |
| `graph-has-edge` | Arista ausente o vértice `u` inexistente / Absent edge or missing vertex `u` | `0` (`false`) | `graph 10 30 graph-has-edge` → `0` |
| `graph-get-neighbors` | Vértice consultado inexistente / Missing queried vertex | `0 0 0` (`addr=0, count=0, success=false`) | `graph 99 graph-get-neighbors` → `0 0 0` |
| Entrada nula / Null input | **No aplica / Not applicable** | Todos los valores son enteros o direcciones representables / All values are representable integers or addresses | La especificación no define casos de entrada nula / Specification defines no null input cases |

---

## ✅ Cobertura de pruebas / Test coverage

| Caso de la especificación / Specification case | Cubierto / Covered | Prueba / Test | Notas / Notes |
|---|---|:--:|---|
| TreeNode: Crear un nodo de árbol / Create a tree node | Sí / Yes | `test-tree-node-create` | Valor inicial verificado en 10 / Initial value verified as 10 |
| TreeNode: Enlaces iniciales ausentes / Absent initial links | Sí / Yes | `test-tree-node-absent-links` | `get_left()` y `get_right()` devuelven `0` / Both return `0` |
| TreeNode: Enlazar dos hijos / Link two children | Sí / Yes | `test-tree-node-link-children` | Hijos 20 y 30 enlazados y verificados / Children 20 and 30 linked and verified |
| TreeNode: Recorrer cada enlace / Traverse each link | Sí / Yes | `test-tree-node-traverse-links` | Recorrido a hijos y confirmación de ausencia en nietos / Traversal to children and absent grandchildren |
| TreeNode: Desenlazar hijos / Unlink children | Sí / Yes | `test-tree-node-unlink-children` | Enlace a `0` preserva valores y enlace restante / Setting link to `0` preserves remaining values and link |
| TreeNode: Adaptación inmutable / Immutable adaptation | Omitido / Omitted | N/A | No representable: las celdas en Forth son mutables / Not representable: Forth cells are mutable |
| BinaryTree: Crear vacío / Create empty | Sí / Yes | `test-tree-create-empty` | `is_empty` = `true`, `size` = 0, `contains(50)` = `false` |
| BinaryTree: Insertar la raíz / Insert the root | Sí / Yes | `test-tree-insert-root` | Éxito, `size` = 1, `is_empty` = `false`, `contains(50)` = `true` |
| BinaryTree: Insertar menor y mayor / Insert lower and higher | Sí / Yes | `test-tree-insert-lower-higher` | Éxito en 50, 30, 70; `size` = 3, los tres presentes / Success for 50, 30, 70; size = 3, all present |
| BinaryTree: Ramas de varios niveles / Multilevel branches | Sí / Yes | `test-tree-multilevel` | Inserción de 50, 30, 70, 20, 40; `size` = 5, todos presentes / Insert 50, 30, 70, 20, 40; size = 5, all present |
| BinaryTree: Valor ausente en árbol no vacío / Missing value in nonempty tree | Sí / Yes | `test-tree-missing-value` | `contains(99)` = `false`, `contains(50)` = `true`, `size` = 1 |
| BinaryTree: Duplicado idempotente / Idempotent duplicate | Sí / Yes | `test-tree-duplicate` | Reinsertar 30 retorna éxito, `size` permanece 3 / Reinserting 30 returns success, size remains 3 |
| BinaryTree: Inserciones ordenadas / Ordered insertions | Sí / Yes | `test-tree-ordered-insertions` | Inserciones de 20, 30, 40, 50, 70; `size` = 5, `contains(99)` = `false` |
| Graph: Crear vacío / Create empty | Sí / Yes | `test-graph-create-empty` | `is_empty` = `true`, conteos 0/0, `has_edge` y `get_neighbors` fallan |
| Graph: Vértice aislado / Isolated vertex | Sí / Yes | `test-graph-isolated-vertex` | Vértice 10: 1 vértice, 0 aristas, vecinos vacíos (`count` = 0, `success` = `true`) |
| Graph: Etiquetas no consecutivas y arista dirigida / Nonconsecutive labels and directed edge | Sí / Yes | `test-graph-directed-edge` | Vértices 10, 70; arista (10,70); reversa (70,10) ausente / Edge (10,70); reverse absent |
| Graph: Vértice duplicado conserva adyacencia / Duplicate vertex preserves adjacency | Sí / Yes | `test-graph-duplicate-vertex` | Reinsertar vértice 10 preserva adyacencia `[30]` y conteos / Readding 10 preserves `[30]` |
| Graph: Arista duplicada / Duplicate edge | Sí / Yes | `test-graph-duplicate-edge` | Reinsertar arista (10,30) no duplica aristas ni vecinos / Reinserting (10,30) does not duplicate |
| Graph: Extremo inexistente sin mutación / Missing endpoint without mutation | Sí / Yes | `test-graph-missing-endpoint` | Fallos en aristas con 98 y 99; no altera vértices, aristas ni adyacencias / Failures leave graph intact |
| Graph: Vecinos ordenados y contadores / Sorted neighbours and counts | Sí / Yes | `test-graph-sorted-neighbours` | Vecinos de 10 son `[30, 50, 70]`; 4 vértices, 4 aristas / Neighbors of 10 are `[30, 50, 70]` |
| Graph: Consulta de arista ausente / Missing-edge query | Sí / Yes | `test-graph-missing-edge-query` | `has_edge(10,30)` = `false`; conteos 2 vértices, 0 aristas |
| Graph: Vecinos de vértice inexistente / Neighbours of missing vertex | Sí / Yes | `test-graph-missing-vertex-neighbours` | `get_neighbors(99)` retorna `success` = `false`, distinguishable de vecinos vacíos |
| Graph: Bucle y duplicado / Self-loop and duplicate | Sí / Yes | `test-graph-self-loop` | Arista (10,10) dos veces; vecinos `[10]`, 1 vértice, 1 arista / Loop (10,10) twice; 1 vertex, 1 edge |
| Graph: Aislamiento del resultado de vecinos / Neighbour-result isolation | Sí / Yes | `test-graph-neighbour-isolation` | Copia en heap desacoplada del estado interno del grafo / Heap copy decoupled from internal graph state |

**ES:** Total: **180 aserciones** ejecutadas en **23 pruebas**, con un caso omitido (`Adaptación inmutable`) debidamente documentado por mutabilidad inherente del lenguaje.

**EN:** Total: **180 assertions** executed across **23 tests**, with one omitted case (`Immutable adaptation`) properly documented due to the language's inherent mutability.

---

## ⚠️ Limitaciones conocidas / Known limitations

| Limitación / Limitation | Impacto / Impact | Alternativa o plan / Workaround or plan |
|---|---|---|
| Celdas dinámicas de nodos y vértices no se liberan automáticamente / Node and vertex cells are not automatically freed | Cada nodo de árbol o vértice reservado en heap permanece durante la sesión / Each allocated tree node or vertex persists for the session duration | El contrato no define operaciones destructoras (`destroy`/`free_tree`); las copias de vecinos sí son liberadas explícitamente por quien llama / The contract defines no destructor operations; neighbor copies are explicitly freed by caller. |
| Reasignación de bloques de vecinos / Reallocation of neighbor blocks | Cada nueva arista realiza una reasignación con copia del bloque de vecinos / Each added edge performs a reallocated copy of the neighbor block | Adecuado para grafos con adyacencia acotada; cumple con la complejidad `O(V + d(u))` exigida / Suitable for bounded adjacency graphs; satisfies required `O(V + d(u))` complexity. |
| Recursión no reentrante por variables de módulo / Non-reentrant module variables | `find-graph-node` y ayudantes usan variables globales auxiliares (`bt-cur`, `gn-head`, etc.) / `find-graph-node` and helpers use auxiliary global variables | Comportamiento estándar en Forth tradicional sin modelo de hilos o reentrancia concurrente / Standard behavior in traditional Forth without concurrency or thread models. |

---

## 📝 Notas de implementación / Implementation Notes

### 🧱 Representación de datos y valor embebido / Data representation & embedded value

**ES:** Como Forth carece de sistema de tipos o herencia orientada a objetos, se adopta la alternativa de valor embebido permitida por la especificación:
- En `TreeNode`, la celda 0 contiene el valor numérico, la celda 1 el enlace izquierdo y la celda 2 el enlace derecho.
- En `GraphNode`, la celda 0 contiene la etiqueta del vértice, la celda 1 el puntero al bloque dinámico de vecinos y la celda 2 el enlace al siguiente vértice en el registro canónico.

**EN:** Since Forth lacks a type system or object-oriented inheritance, the embedded value approach allowed by the specification is adopted:
- In `TreeNode`, cell 0 stores the numeric value, cell 1 the left link, and cell 2 the right link.
- In `GraphNode`, cell 0 stores the vertex label, cell 1 the pointer to the dynamic neighbors block, and cell 2 the link to the next vertex in the canonical registry.

### 🔍 Aislamiento de vecinos / Neighbor isolation

**ES:** `graph-get-neighbors` reserva con `allocate` un bloque de celdas nuevo y copia allí los valores de los vecinos ordenados. Devuelve la terna `( addr count success )`. La suite de pruebas verifica este aislamiento comprobando que modificar la copia no altera el grafo y liberando la memoria con `free` tras cada inspección.

**EN:** `graph-get-neighbors` allocates a fresh block of cells with `allocate` and copies the sorted neighbor values into it. It returns the triple `( addr count success )`. The test suite verifies this isolation by asserting that modifying the copy does not alter the graph, and frees the memory with `free` after inspection.

### 🚫 Caso nulo / Null case

**ES:** **No aplica.** La especificación 07 no define casos de entrada nula; todos los valores de prueba y etiquetas son números enteros positivos que no colisionan con indicadores o direcciones nulas.

**EN:** **Not applicable.** Specification 07 defines no null input cases; all test values and labels are positive integers that do not collide with indicators or null addresses.

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
| Especificación / Specification | [`07_Data_Structures_Advanced.md`](https://yorche3.github.io/programming_languages/core/algorithms/07_Data_Structures_Advanced/) |
| Primera base del lenguaje / First language reference | `data_structures_basics` — [`../data_structures_basics/README.md`](../data_structures_basics/README.md) |
| Segunda base del lenguaje / Second language reference | `numbers` — [`../../foundations/numbers/README.md`](../../foundations/numbers/README.md) |
| Guía de inicialización / Initialisation guide | [`core/00_Project_Initialization_Guide.md`](https://yorche3.github.io/programming_languages/core/00_Project_Initialization_Guide/) |
| Adaptaciones idiomáticas / Idiomatic adaptations | [`AGENT_Template.md`](https://yorche3.github.io/programming_languages/AGENT_Template/) |
| Validación de la documentación / Documentation validation | [`WORKFLOW.md`](https://yorche3.github.io/programming_languages/WORKFLOW/) |
| Plantilla del README / README template | [`README_Template.md`](https://yorche3.github.io/programming_languages/README_Template/) |
| Documentación oficial del lenguaje / Language official docs | [Gforth Manual](https://gforth.org/manual/) |

---

*[← Volver a Algorithms Pure](../README.md) | [↑ Volver a Forth Core](../../README.md)*

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
