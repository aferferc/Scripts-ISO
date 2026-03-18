#!/usr/bin/env bash
#f_log
#Descripción: Registra un evento en un archivo de log cronológico.
#Entrada:W
#  $1: Mensaje de texto a registrar.
#  $2: (Opcional) Ruta del archivo de log. Por defecto /var/log/sysadmin.log.
#Devuelve:
#  0: Registro guardado correctamente.
#  1: Error de permisos al escribir en el archivo.

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
