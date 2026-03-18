#!/usr/bin/env bash

#Nombre: f_log
#Descripción: Registra un evento en un archivo de log cronológico.
#Parmetros entrada: Mensaje de texto a registrar ($1), ruta del fichero .log ($2)
#Parametros de salida: Devuelve un 0 si se guarda correctamente y 1 si hay un error de permisos
#O el punto de montaje es incorrecto

f_log(){

  mensaje="$1"
  archivo="$2"
  if [ "$mensaje" = "" ]; then
    echo "Error: mensaje vacío"
    return 1
  fi
  if [ "$archivo" = "" ]; then
    archivo="/var/log/sysadmin.log"
  fi
  timestamp="$(date '+%y-%m-%d %H:%M:%S') $mensaje"

  if echo "$timestamp" >> "$archivo"; then
    return 0
  else
    echo "Error: No se pudo escribir en $archivo (¿tienes permisos de sudo?)"
    return 1
  fi
}

if f_log "$1" "$2"; then
    echo "Resultado:Evento registrado."

fi
