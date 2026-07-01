# Hello, User! — Forth

Implementación de la especificación [02_Hello_User](https://yorche3.github.io/programming_languages/core/foundations/02_Hello_User/) en **Forth**, ejecutado con **Gforth**.

Lee un nombre desde la entrada estándar y saluda al usuario.

---

## 📂 Archivos y estructura / Files & Structure

| Archivo | Propósito |
|---------|-----------|
| [`hello_user.forth`](hello_user.forth) | Código fuente: solicita un nombre al usuario y saluda. |

**Estructura de directorios esperada:**

```text
hellouser/
├── hello_user.forth    # Código fuente
└── README.md           # Este archivo
```

---

## 🛠️ Enfoque y construcción / Approach & Build

**ES:** Este programa introduce tres conceptos nuevos respecto a `helloworld`:

1. **Entrada de usuario** — `accept` lee una línea desde la entrada estándar.
2. **Área de buffer temporal** — `pad` es un área de memoria predefinida en Forth para uso temporal.
3. **Manipulación de cadenas en la pila** — `swap type` combina la cadena en `pad` con la longitud obtenida de `accept`.

**EN:** This program introduces three new concepts compared to `helloworld`:

1. **User input** — `accept` reads a line from standard input.
2. **Temporary buffer area** — `pad` is a predefined memory area in Forth for temporary use.
3. **Stack-based string manipulation** — `swap type` combines the string in `pad` with the length from `accept`.

---

## 📄 Archivos de configuración clave / Key Configuration Files

### `hello_user.forth`

**ES:** El flujo del programa es:

1. Imprimir `"Enter your name: "` con `cr ." ... "`.
2. Leer una línea desde `stdin` con `accept`, almacenándola en `pad` y obteniendo su longitud.
3. Imprimir `"Hello, "` seguido del nombre usando `swap type`.

**EN:** Program flow:

1. Print `"Enter your name: "` with `cr ." ... "`.
2. Read a line from `stdin` with `accept`, storing it in `pad` and getting its length.
3. Print `"Hello, "` followed by the name using `swap type`.

```forth
: main ( -- )
  cr ." Enter your name: "
  pad 80 accept          \ lee hasta 80 caracteres en pad, deja longitud
  cr ." Hello, " pad swap type   \ imprime saludo + nombre
  cr
;
main
bye
```

| Elemento | Propósito |
|----------|-----------|
| `cr` | Carriage return: imprime un salto de línea |
| `." ..."` | Palabra que imprime una cadena literal |
| `pad` | Dirección de un buffer temporal de 256 bytes (estándar en Forth) |
| `80` | Límite máximo de caracteres a leer (por seguridad) |
| `accept` | Lee una línea desde `stdin` al buffer `pad`; deja en la pila la longitud leída |
| `pad swap type` | Lleva la dirección del buffer a la cima, intercambia con la longitud (`swap`) e imprime la cadena (`type`) |

> **ES:** `accept ( addr n -- n' )` lee hasta `n` caracteres desde el teclado y los almacena en la dirección `addr`. Devuelve la cantidad real de caracteres leídos (sin incluir el salto de línea).
> **EN:** `accept ( addr n -- n' )` reads up to `n` characters from the keyboard and stores them at address `addr`. It returns the actual number of characters read (excluding the newline).

> **ES:** `type ( addr n -- )` imprime `n` caracteres desde la dirección `addr` en la salida estándar. Es la palabra complementaria de `accept` para mostrar cadenas.
> **EN:** `type ( addr n -- )` prints `n` characters starting at address `addr` to standard output. It's the complementary word to `accept` for displaying strings.

> **ES:** `swap ( n1 n2 -- n2 n1 )` intercambia los dos valores superiores de la pila. Se usa aquí porque `pad` deja su dirección, y `accept` deja la longitud encima. Para que `type` reciba `( addr n )` en el orden correcto, hay que intercambiarlos.
> **EN:** `swap ( n1 n2 -- n2 n1 )` exchanges the top two values on the stack. It's used here because `pad` leaves its address, and `accept` leaves the length on top. For `type` to receive `( addr n )` in the correct order, they need to be swapped.

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
cd core/foundations/hellouser
gforth hello_user.forth
```

**Salida esperada / Expected output:**

```text
Enter your name: Ada
Hello, Ada!
```

> **ES:** El programa espera a que el usuario escriba su nombre y presione Enter antes de mostrar el saludo.
> **EN:** The program waits for the user to type their name and press Enter before showing the greeting.

---

## 📝 Notas de implementación / Implementation Notes

- **ES:** `pad` es un buffer de 256 bytes predefinido en la especificación ANS Forth. Es ideal para operaciones temporales como lectura de entrada del usuario.
- **EN:** `pad` is a 256-byte buffer predefined in the ANS Forth specification. It's ideal for temporary operations like reading user input.
- **ES:** A diferencia de lenguajes como C donde se usa `fgets` + eliminación manual del `\n`, en Forth `accept` ya descarta el salto de línea, simplificando el procesamiento.
- **EN:** Unlike languages like C where `fgets` + manual `\n` removal is needed, in Forth `accept` already discards the newline, simplifying processing.
- **ES:** Forth usa la pila como mecanismo principal de paso de datos. `pad swap type` es un ejemplo típico de cómo se manipulan direcciones y longitudes mediante palabras de la pila.
- **EN:** Forth uses the stack as its primary data passing mechanism. `pad swap type` is a typical example of how addresses and lengths are manipulated using stack words.

---

### 🌐 Otras implementaciones / Other implementations

Este proyecto también está implementado en otros lenguajes. Explora el [repositorio principal](https://github.com/yorche3/programming_languages) para ver todas las versiones.

---

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
