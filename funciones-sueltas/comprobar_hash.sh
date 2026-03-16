#!/bin/bash

#Nombre: f_verificar_hash
#Descripcion: Indica la integridad de un archivo mediante md5.
#Parametros entrada: ruta del fichero ($1) hash esperado ($2)
#Parametros Salida: 0 si coincide, 1 de lo contrario


f_verificar_hash(){

  hash=$(md5sum "$1" | cut -d' ' -f1)
  if [ "$hash" = "$2" ]; then
    return 0
  else
    return 1
  fi

}



f_verificar_hash $1 $2
