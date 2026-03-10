#!/usr/bin/env bash
#Descripcion: Script con multiples Funciones utiles
#Autor: Luca, Alfredo, Dani Berzofa, Frank
#Version: 3



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

#Descripcion f_ranking: Muestra un ranking de los 10 comandos mas usados del historial
#No tiene entradas ni salidas

f_ranking(){
  if [ -r ~/.bash_history ]; then
    historial=$(cat ~/.bash_history | awk '{print $1}' | sort | uniq -c | sort -nr | head)
    echo "Los comandos mas usados son:"
    for i in 2 4 6 8 10 12 14 16 18 20; do
      echo $historial | cut -d' ' -f$i
    done
  else
    echo "No se a encontrado el fichero .bash_history en su directorio de usuario"
  fi
}

#Descripcion f_ayuda: Muestra la ayuda del script
#No tiene entradas  ni salidas

f_ayuda(){

  cat <<FIN
Scrip de funciones utiles multiples, sintaxtis: . funciones.sh [param]

Parametros:

	h		Muesta esta ayuda
	r		Muestra ranking comandos mas usados
	u		Muestra uid del usuario
	bi		Comprueba si un  binario esta isntalado ej: . funciones.sh bi [bin]
	c		Compruba si hay conexion a internet
	r		Comprueba si eres root
	pd		Revisa si un paquete esta disponible ej: . funciones.sh pd [package]
	pi		Revisa si un paquete esta instalado ej: . funciones.sh pi [package]
	bp		Busca el nombre del paquete al que pertenece un binario
			ej: . funciones.sh bp [bin]
FIN

}

#Descripcion f_parametros: Comprueba que se han introducido argumentos al script
#No tiene entrada, si salida

f_parametros() {
    if [ $# -eq 0 ]; then
        echo "Error: no se han introducido argumentos."
        exit 1
    fi
}

f_parametros "$@"

echo "Argumentos recibidos: $@"


#Descripcion f_paquete_instalado: Funcion que permite ver si hay un paquete instalado o no
#Tiene entrada, no salida

f_paquete_instalado() {
    dpkg -s "$1" &> /dev/null

    if [ $? -eq 0 ]; then
        return 0
    else
        return 1
    fi
}


#--------------Zona  CODIGO PRINCIPAL SCRIPT--------------#

if [ $1 = "r" ]; then
  f_ranking
else
  f_ayuda
fi

