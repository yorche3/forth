: main ( -- )
  cr ." Enter your name: "
  pad 80 accept          \ lee hasta 80 caracteres en pad, deja longitud
  cr ." Hello, " pad swap type   \ imprime saludo + nombre
  cr
;
main
bye