# Algorithms Pure — Forth

Implementaciones de la [Fase 1 — Algoritmos Puros](https://yorche3.github.io/programming_languages/ROADMAP/#fase-1--algoritmos-puros--algorithms-pure-) en **Forth** (Gforth): ordenamientos elementales, estructuras de datos propias, ordenamientos óptimos y distribuidos, y búsqueda.

Los módulos de esta fase trabajan sobre **celdas de memoria**: una secuencia es una dirección (`addr`) más un número de elementos (`count`), y el contrato ordena **in-place**.

---

## 📋 Módulos

| # | Módulo | Descripción | Tests |
|---|--------|-------------|:-----:|
| [05](naive_sort/) | [Naive Sort](https://yorche3.github.io/programming_languages/core/algorithms/05_Naive_Sort/) | Selection, Bubble e Insertion Sort ($O(n^2)$) sobre celdas | 78 |
| [06](data_structures_basics/) | [Data Structures Basics](https://yorche3.github.io/programming_languages/core/algorithms/06_Data_Structures_Basics/) | Node, LinkedList, Stack y Queue sobre celdas enlazadas | 114 |

---

## 📂 Estructura

```text
algorithms/
├── naive_sort/                  # 05_Naive_Sort
│   ├── src/
│   │   └── naive_sort.forth     # selection-sort, bubble-sort, insertion-sort
│   ├── test/
│   │   ├── test.forth           # Framework de testing unitario
│   │   ├── naive-sort-tests.forth
│   │   └── run-tests.forth      # Punto de entrada
│   └── README.md
└── data_structures_basics/      # 06_Data_Structures_Basics
    ├── src/
    │   └── data_structures_basics.forth  # Node, LinkedList, Stack, Queue
    ├── test/
    │   ├── test.forth           # Framework de testing unitario
    │   ├── data-structures-basics-tests.forth
    │   └── run-tests.forth      # Punto de entrada
    └── README.md
```

---

## 🛠️ Patrón común / Common Pattern

| Característica | Descripción |
|---------------|-------------|
| **Runtime** | Gforth (intérprete; no hay compilación separada) |
| **Estructura** | `src/` + `test/`, creadas a mano (`mkdir -p src test`) |
| **Contrato** | Palabras con la dirección primero: `( addr count -- )` al ordenar e `( instancia … -- )` en los ADT |
| **Naming** | Palabras en `kebab-case`; variables globales para el estado de los bucles y los recorridos |
| **Tests** | Runner casero `test.forth`: `init-tests`, `assert-equals`, `test-report` |
| **Entrada** | `cd test && gforth run-tests.forth` |
| **Artefactos** | Ninguno: Forth interpretado, sin `.gitignore` de módulo |
| **Indicador de fallo** | `-1` en las operaciones que devuelven un entero y dirección nula `0` para el enlace ausente (`data_structures_basics`); en `naive_sort` no aplica: no existe representación de array inválido |
| **Memoria** | `naive_sort` ordena in-place sobre lo recibido; `data_structures_basics` reserva cada celda con `allocate` y no las libera |

---

## 🚀 Compilación rápida / Quick Build

```bash
# Naive Sort Tests
cd naive_sort/test
gforth run-tests.forth

# Data Structures Basics Tests
cd data_structures_basics/test
gforth run-tests.forth
```

---

### 🌐 Otras implementaciones / Other implementations

Este proyecto también está implementado en otros lenguajes. Explora el [repositorio principal](https://github.com/yorche3/programming_languages) para ver todas las versiones.

---

## ▶️ Siguiente / Next

👉 Continúa con los módulos pendientes de esta fase en el [Roadmap](https://yorche3.github.io/programming_languages/ROADMAP/).
👉 Continue with the pending modules of this phase in the [Roadmap](https://yorche3.github.io/programming_languages/ROADMAP/).

---

*[← Volver a Core](../README.md)*

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
