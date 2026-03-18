#!/usr/bin/env bash

#Nombre: f_es_ip_valida
#Descripción: Valida sintácticamente si una cadena tiene formato de IPv4.
#Parmetros entrada: Cadena de texto a validar ($1).
#Parametros de salida: Devuelve un 0 si tiene un formato correcto y 1 si no e imprime por la salida de error el error

f_es_ip_valida(){

  ip=$(echo $1 | grep -Eo '^[0-9]{1,3}(\.[0-9]{1,3}){3}$')

  if [ "$ip" = "" ]; then
     echo "Error ip no valida" >&2
     return 1
  else
     return 0
  fi
}

if f_es_ip_valida "$1"; then
    echo "Resultado: La IP $1 es válida."
fi
