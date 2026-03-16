
#Nombre: f_puerto_abierto
#Descripcion: Verifica si un servicio está escuchando en un puerto específico.
#Parametros entrada: Direccion IP o hostname y el numero de puerto a comprobar
#Parametros salida: 0 si el puerto esta abierto y responde,1 si esta cerrado
#o inalcanzable

f_puerto_abierto(){

#-w 2 para que no se quede buscando infinitamente si el puerto esta cerrado
 nc -z -w 2 "$1" "$2" > /dev/null 2>&1

if [  $? -eq 0 ]; then
  echo "El puerto esta abierto y responde"
  return 0
else
  echo "El puerto esta cerrado o es inalcanzable"
  return 1
fi

}
