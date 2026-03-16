#!/bin/bash

#Nombre: f_verificar_hash
#Descripcion: Indica la integridad de un archivo mediante md5.
#Parametros entrada: la ruta del archivo
#Parametros Salida: muestra si coincide el hash, verificando la integridad


f_verificar_hash(){

  hash=$(md5sum "$1" | cut -d' ' -f1)
  if [ "$hash" = "$2" ]; then
    return 0
  else
    return 1
  fi

}



f_verificar_hash $1 $2
