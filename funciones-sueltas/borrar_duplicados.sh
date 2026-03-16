#!/usr/bin/env bash

#Nombre: f_borrar_duplicados
#Descripcion: Identifica y elimina archivos duplicados en un directorio basado en su hash (contenido) y opcionalmente por patrón de nombre.
#Parametros entrada: la ruta del directorio ($1) modo ($2) puede ser CHECK o DELETE
#Parametros Salida: 0 si tiene exito, 1 si no


f_borrar_duplicados() {

  if [ ! -d "$1" ] || [ ! -r "$1" ]; then
    return 1
  fi
  if [ "$2" != "DELETE" ] && [ "$2" != "CHECK" ]; then
    echo "Error: Introduzca un modo valido"
    return 1
  fi
  lista_hash=""
  lista_archivos=""
  for archivo in $(find "$1" -type f); do
    duplicado=0
    i=1
    for hash in $lista_hash; do
      original=$(echo "$lista_archivos" | awk "NR==$i")
      if f_verificar_hash "$archivo" "$hash"; then
        echo "Fichero original: $original"
	echo "Fichero duplicado: $archivo"
        if [ "$2" = "DELETE" ]; then
	  rm -f "$archivo"
	fi
        duplicado=1
      fi
      i=$((i+1))
    done
    if [ "$duplicado" -eq 0 ]; then
      nuevo_hash=$(md5sum "$archivo" | cut -d' ' -f1)
      lista_hash="$lista_hash $nuevo_hash"
      lista_archivos="$lista_archivos
$archivo"
    fi
  done
  return 0

}



f_verificar_hash(){

  hash=$(md5sum "$1" | cut -d' ' -f1)
  if [ "$hash" = "$2" ]; then
    return 0
  else
    return 1
  fi

}

f_borrar_duplicados $1 $2

