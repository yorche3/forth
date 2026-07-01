# 🚀 Foundations — Forth

Implementaciones de la [Fase 0 — Fundamentos](https://yorche3.github.io/programming_languages/ROADMAP/#fase-0--fundamentos--foundations--completada) en **Forth** (Gforth): `helloworld`, `hellouser`, `unit_test/calculator` y `numbers`.

---

## 📖 Módulos / Modules

| Módulo | Especificación | Enfoque | Tests | Estado |
|--------|---------------|---------|:-----:|:------:|
| [`helloworld/`](helloworld/) | [01_Hello_World](https://yorche3.github.io/programming_languages/core/foundations/01_Hello_World/) | `gforth` (archivo único) | — | ✅ |
| [`hellouser/`](hellouser/) | [02_Hello_User](https://yorche3.github.io/programming_languages/core/foundations/02_Hello_User/) | `gforth` (archivo único) | — | ✅ |
| [`unit_test/calculator/`](unit_test/calculator/) | [03_Unit_Test_Calculator](https://yorche3.github.io/programming_languages/core/foundations/03_Unit_Test_Calculator/) | `gforth` + test framework casero | 5 | ✅ |
| [`numbers/`](numbers/) | [04_Numbers](https://yorche3.github.io/programming_languages/core/foundations/04_Numbers/) | `gforth` + test framework casero | 22 | ✅ |

---

## 📁 Estructura / Structure

```text
foundations/
├── helloworld/                   # 01_Hello_World
│   ├── hello_world.forth         # Imprime "Hello, World! from Forth!"
│   └── README.md
│
├── hellouser/                    # 02_Hello_User
│   ├── hello_user.forth          # Lee nombre y saluda
│   └── README.md
│
├── unit_test/
│   └── calculator/               # 03_Unit_Test_Calculator
│       ├── src/
│       │   └── calculator.forth  # 5 operaciones aritméticas
│       ├── test/
│       │   ├── test.forth        # Framework de testing
│       │   ├── calculator_tests.forth  # 5 tests
│       │   └── run_tests.forth   # Punto de entrada
│       └── README.md
│
└── numbers/                      # 04_Numbers
    ├── src/
    │   └── numbers.forth         # 15 funciones + 4 helpers
    ├── test/
    │   ├── test.forth            # Framework de testing
    │   ├── numbers-rec-tests.forth   # 11 tests recursivos
    │   ├── numbers-ite-tests.forth   # 11 tests iterativos
    │   └── run-tests.forth       # Punto de entrada
    └── README.md
```

---

## 🛠️ Patrón común / Common Pattern

| Característica | Descripción |
|---------------|-------------|
| **Intérprete** | Gforth (GNU Forth) |
| **Build system** | Ninguno — Forth es interpretado, se ejecuta directamente con `gforth` |
| **Test framework** | Framework casero (`test.forth`) — palabras `init-tests`, `assert-equals`, `test-report` |
| **Dependencias** | Ninguna — solo palabras nativas de Forth |
| **Separación** | `src/` (implementación), `test/` (tests) |
| **Formato de nombres** | Palabras en kebab-case: `sum-first-n-rec`, `factorial-ite`, etc. |
| **Convención de pila** | Comentarios `( antes -- después )` documentan el efecto en la pila de datos |

---

## 🚀 Ejecución rápida / Quick Run

```bash
# Hello, World!
cd helloworld && gforth hello_world.forth

# Hello, User!
cd hellouser && gforth hello_user.forth

# Calculator Tests
cd unit_test/calculator/test && gforth run_tests.forth

# Numbers Tests
cd numbers/test && gforth run-tests.forth
```

---

### 🌐 Otras implementaciones / Other implementations

Este proyecto también está implementado en otros lenguajes. Explora el [repositorio principal](https://github.com/yorche3/programming_languages) para ver todas las versiones.

---

## ▶️ Siguiente / Next

👉 Después de fundamentos, continúa con [Fase 1 — Algoritmos Puros](https://yorche3.github.io/programming_languages/ROADMAP/#fase-1--algoritmos-puros--algorithms-pure-).  
👉 After foundations, continue with [Phase 1 — Algorithms Pure](https://yorche3.github.io/programming_languages/ROADMAP/#fase-1--algoritmos-puros--algorithms-pure-).

---

*[← Volver a Forth](../README.md)*

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
