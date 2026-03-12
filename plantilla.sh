#! /usr/bin/env bash

cat << FIN > "$1.sh"
#!/usr/bin/env bash
#Descripcion:
#Autor:
#Version:



#-------------------------COLORES-------------------------#
ROJO='\033[0;31m'
VERDE='\033[0;32m'
AMARILLO='\033[0;33m'
CIAN='\033[0;36m'

NEGRITA='\033[1]'
ERR='\033[1;31m'
OK='\033[1;32m'
WARN='\033[1;33m'

NC='\033[0m' # No Color (restablecer)

#--------------Zona declaracion de VARIABLES--------------#



#--------------Zona declaracion de FUNCIONES--------------#

#Nombre: f_ejemplo
#Funcion: Sirve de ejemplo para la declaracion de funciones
#Parametros de entrada: ninguno
#Paramtros de salida: ninguno
f_ejemplo(){

}

#--------------Zona  CODIGO PRINCIPAL SCRIPT--------------#


FIN
