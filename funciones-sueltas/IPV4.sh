#!/usr/bin/env bash
#Función para ver si la ip tiene el formato ipv4
#Descripción: Valida sintácticamente si una cadena tiene formato de IPv4.
#Entrada: $1: Cadena de texto a validar.
#Devuelve:
#0: Formato de IP correcto.
#1: Formato inválido (imprime error por stderr).
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
