: main ( -- )
  cr ." Enter your name: "
  pad 80 accept          \ lee hasta 80 caracteres en pad, deja longitud
  cr ." Hello, " pad swap type ." !" cr   \ saludo + nombre + signo
  cr
;
main
bye