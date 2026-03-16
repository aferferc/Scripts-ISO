#Variables f_espacio_libre

usado=$( df "$1" | tail -1 | awk '{print $5}' | tr -d '%')
libre=$((100 - usado))

#Nombre: f_espacio_libre
#Descripcion: Comprueba si un punto de montaje tiene suficiente espacio libre.
#Parmetros entrada: Punto de montaje y porcentaje minimo de espacio libre requerido(solo el numero).
#Parametros de salida: Devuelve un 0 si hay espacio suficiente y 1 si no lo hay
#O el punto de montaje es incorrecto

f_espacio_libre(){

if [ ! -d "$1" ]; then
  echo "No existe el punto de montaje"
  return 1
fi

if [ "$libre" -ge "$2" ]; then
  echo "Hay espacio suficiente"
  return 0
else
  echo "No hay espacio suficiente"
  return 1
fi

}
