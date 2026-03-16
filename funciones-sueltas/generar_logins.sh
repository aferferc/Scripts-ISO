#!/usr/bin/env bash

#Nombre: f_generar_logins_universal
#Descripcion: Genera identificadores en minúsculas procesando nombres y apellidos. Compatible con /bin/sh y /bin/bash
#Parametros entrada: la ruta del fichero origen ($1) la ruta del fichero destino $(2)
#Parametros Salida: ninguno


f_generar_logins_universal() {

  if [ ! -r "$1" ]; then
    echo "Error: No se puede leer el fichero origen"
    return 1
  fi

  while IFS=';' read -r nombre apellido1 apellido2 dni; do
    iniciales=""
    for palabra in $nombre; do
      inicial=$(echo "$palabra" | cut -c1)
      iniciales="$iniciales$inicial"
    done
    apellidos=""
    for palabra in $apellido1 $apellido2; do
      palabra_sin_espacios=$(echo "$palabra" | tr -d ' ')
      tres_letras=$(echo "$palabra_sin_espacios" | cut -c1-3)
      apellidos="$apellidos$tres_letras"
    done
    caracteres_dni=$(echo "$dni" | tail -c 4)
    login=$(echo "${iniciales}${apellidos}${caracteres_dni}" | tr '[:upper:]' '[:lower:]')
    echo "$login" >> "$2"
  done < "$1"
  return 0
}

f_generar_logins_universal $1 $2

