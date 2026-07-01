# Hello, World! — Forth

Implementación de la especificación [01_Hello_World](https://yorche3.github.io/programming_languages/core/foundations/01_Hello_World/) en **Forth**, ejecutado con **Gforth**.

---

## 📂 Archivos y estructura / Files & Structure

| Archivo | Propósito |
|---------|-----------|
| [`hello_world.forth`](hello_world.forth) | Código fuente: imprime `"Hello, World! from Forth!"` en la consola. |

**Estructura de directorios esperada:**

```text
helloworld/
├── hello_world.forth   # Código fuente
└── README.md           # Este archivo
```

---

## 🛠️ Enfoque y construcción / Approach & Build

**ES:** Este proyecto usa **Forth** con **Gforth** y sigue un enfoque minimalista: un único archivo fuente, sin dependencias externas, ejecutado directamente con `gforth`.

Características:
- **Sin dependencias externas** — solo usa palabras nativas de Forth (`.`, `."`, `cr`, `bye`).
- **Ejecución directa** — un solo comando `gforth` ejecuta el programa.
- **Sin archivo de proyecto** — no necesita Makefile ni sistema de compilación.
- **Estilo clásico** — definición de palabra `main`, invocación explícita y salida con `bye`.

**EN:** This project uses **Forth** with **Gforth** and follows a minimalist approach: a single source file, no external dependencies, executed directly with `gforth`.

Features:
- **No external dependencies** — only uses native Forth words (`.` , `."`, `cr`, `bye`).
- **Direct execution** — a single `gforth` command runs the program.
- **No project file** — no Makefile or build system needed.
- **Classic style** — `main` word definition, explicit invocation, and exit with `bye`.

---

## 📄 Archivos de configuración clave / Key Configuration Files

### `hello_world.forth`

**ES:** Define la palabra `main` que imprime el saludo, la invoca y sale del intérprete.

**EN:** Defines the `main` word that prints the greeting, invokes it, and exits the interpreter.

```forth
: main  ( -- ) 
  ." Hello, World! from Forth!" cr ;
main
bye
```

| Elemento | Propósito |
|----------|-----------|
| `: main` | Inicia la definición de la palabra `main` |
| `( -- )` | Comentario de pila: no toma ni deja nada en la pila |
| `." ..."` | Palabra que imprime una cadena literal entre comillas |
| `cr` | Carriage return: imprime un salto de línea |
| `;` | Finaliza la definición de la palabra |
| `main` | Invoca (ejecuta) la palabra `main` |
| `bye` | Sale del intérprete de Forth |
| Sin `main()` obligatorio | En Forth no hay un punto de entrada fijo; el código se ejecuta secuencialmente |

> **ES:** `."` es la palabra de Forth para imprimir cadenas literales. Todo lo que sigue entre comillas hasta la comilla de cierre se muestra en la salida estándar. Es equivalente al `printf` de C o `println` de otros lenguajes.
> **EN:** `."` is the Forth word for printing literal strings. Everything between the opening quote and the closing quote is displayed to standard output. It's equivalent to C's `printf` or other languages' `println`.

> **ES:** `bye` es una palabra que termina la ejecución del intérprete de Forth y devuelve el control al sistema operativo. Sin `bye`, el intérprete quedaría esperando entrada del usuario.
> **EN:** `bye` is a word that terminates the Forth interpreter and returns control to the operating system. Without `bye`, the interpreter would wait for user input.

---

## 🚀 Compilación y ejecución / Build & Run

### Requisito: Tener Gforth instalado

```bash
# Linux (Debian/Ubuntu)
sudo apt install gforth

# Linux (Fedora)
sudo dnf install gforth

# macOS (con Homebrew)
brew install gforth

# Windows
# Descargar desde: https://gforth.org/
```

### Ejecutar

```bash
cd core/foundations/helloworld
gforth hello_world.forth
```

**Salida esperada / Expected output:**

```text
Hello, World! from Forth!
```

> **ES:** Si se omite `bye` al final del archivo, el intérprete de Forth quedará en modo interactivo esperando comandos del usuario. Para salir en ese caso, escribe `bye` y presiona Enter.
> **EN:** If `bye` is omitted at the end of the file, the Forth interpreter will remain in interactive mode waiting for user commands. To exit in that case, type `bye` and press Enter.

---

## 📝 Notas de implementación / Implementation Notes

- **ES:** Forth es un lenguaje interpretado basado en pila. No requiere compilación explícita; Gforth ejecuta el código directamente.
- **EN:** Forth is a stack-based interpreted language. It doesn't require explicit compilation; Gforth executes the code directly.
- **ES:** Las palabras `: ... ;` definen nuevas palabras (subrutinas/funciones) que quedan disponibles en el diccionario de Forth.
- **EN:** The `: ... ;` words define new words (subroutines/functions) that become available in the Forth dictionary.
- **ES:** Los comentarios de pila `( -- )` son una convención estándar en Forth para documentar el efecto de una palabra sobre la pila de datos.
- **EN:** Stack comments `( -- )` are a standard convention in Forth to document a word's effect on the data stack.
- **ES:** Forth usa notación polaca inversa (RPN): primero los operandos, luego el operador.
- **EN:** Forth uses Reverse Polish Notation (RPN): operands first, operator second.

---

### 🌐 Otras implementaciones / Other implementations

Este proyecto también está implementado en otros lenguajes. Explora el [repositorio principal](https://github.com/yorche3/programming_languages) para ver todas las versiones.

---

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
