#!/usr/bin/env bash
#Descripcion: Scrip con multiples Funciones utiles
#Autor: Luca, Alfredo, Dani Berzosa, Frank
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

#Nombre: f_ranking
#Descripcion: Muestra un ranking de los 10 comandos mas usados del historial
#Parmetros entrada: niguno
#Parametros de salida: ninguno

f_ranking() {
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

#Nombre: f_ayuda
#Descripcion: Muestra un ranking de los 10 comandos mas usados del historial
#Parmetros entrada: niguno
#Parametros de salida: ninguno

f_ayuda() {

  cat <<FIN
Scrip de funciones utiles multiples, sintaxtis: . funciones.sh [param]

Parametros:

	h		Muesta esta ayuda
	r		Muestra ranking comandos mas usados
	u		Muestra uid del usuario
	bi		Comprueba si un  binario esta isntalado ej: . funciones.sh bi [bin]
	c		Compruba si hay conexion a internet
	ro		Comprueba si eres root
	pd		Revisa si un paquete esta disponible ej: . funciones.sh pd [package]
	pi		Revisa si un paquete esta instalado ej: . funciones.sh pi [package]
	bp		Busca el nombre del paquete al que pertenece un binario
			ej: . funciones.sh bp [bin]
	ipv4		Muestra por pantalla la ipv4 de la maquina para una interfaz introducida
			ej: .funciones.sh ipv4 [int]
FIN

}

#Nombre: f_paquete_instado
#Descripcion: Funcion que permite ver si hay un paquete instalado o no
#Parmetros entrada: una cadena que contiene el nombre del paquete ($2)
#Parametros de salida: 0 si se encuentra instalado, 1 si no

f_paquete_instalado() {

  dpkg -s "$1" &>/dev/null

  if [ $? -eq 0 ]; then
    return 0
  else
    return 1
  fi
}

#Nombre: f_parametros
#Descripcion: Comprueba que se han introducido argumentos al script, para ello revisa si el argumento 1 esta vacio
#Parmetros entrada: el argumento nº1 del script ($1)
#Parametros de salida: 0 si se a introducido un argumento, 1 si no

f_parametros() {

  if [ "$1" = "" ]; then
    echo "Error: no se han introducido argumentos."
    return 1
  fi
}

#Nombre: f_obtener_ipv4
#Descripcion: Devuelve la ipv4 de la maquina
#Parmetros entrada: ninguno
#Parametros de salida: ninguo

f_obtener_ipv4() {

  ip a | grep -E "$1" | grep -Eo '([0-9]{1,3}\.){3}([0-9]){1,3}' | head -n 1

}

#Nombre: f_bin_instalado
#Descripcion: Comprueba si un binario introducido se ha instalado
#Parmetros entrada: Una cadena con el nombre del binario ($2)
#Parametros de salida: 0 si esta instalado, 1 si no

f_bin_instalado() {

  command -v "$1" >/dev/null 2>&1

}

#Nombre: f_hay_conexion
#Descripcion: Comprueba si hay conexion a internet
#Parmetros entrada: ninguno
#Parametros de salida: 0 si hay coexion, 1 si no

f_hay_conexion() {

  ping -c 1 8.8.8.8 &>/dev/null

  if [ $? -eq 0 ]; then
    return 0
  else
    return 1
  fi
}

#Nombre: f_uid
#Descripcion: Comprueba la uid del usuario que esta usando el script
#Parmetros entrada: ninguno
#Parametros de salida: ninguno

f_uid() {

  uid=$(id -u)
  return "$uid"
}

#Nombre: f_eres_root
#Descripcion: Comprueba si el usuario es root
#Parmetros entrada: ninguno
#Parametros de salida: 0 si es root, 1 si no

f_eres_root() {
  uid=$(f_uid)
  if [ $uid -eq 0 ]; then
    return 0
  else
    return 1
  fi

}

#Nombre: f_paquete_disponible
#Descripcion: Comprueba si un paquete esta disponible en el repositorio
#Parmetros entrada: una cadena con el nombre del paquete ($2)
#Parametros de salida: 0 si esta disponible, 1 si no

f_paquete_disponible() {

  if apt-file search "$1" | grep "/bin/$1$" | awk -F: '{print $1}' >/dev/null; then
    return "0"
  else
    return "1"
  fi
}

#Nombre: f_buscar_paquetes
#Descripcion: Comprueba el nombre del paquete al que pertenece el binario que pasa como argumento
#Parmetros entrada: una cadena con el nombre del paquete ($2)
#Parametros de salida: ninguno

f_buscar_paquetes() {
    apt-file search "$1" | grep "bin/$1$"
}


#--------------Zona  CODIGO PRINCIPAL SCRIPT--------------#

f_parametros $1

if [ $? -eq 1 ]; then
  f_ayuda
else
  case "$1" in
  "r")
    f_ranking
    ;;
  "h")
    f_ayuda
    ;;
  "pi")
    if $(f_paquete_instalado "$2"); then
      echo "El paquete esta instalado"
    else
      echo "El paquete no esta instalado"
    fi
    ;;
  "ipv4")
    f_obtener_ipv4 "$2"
    ;;
  "u")
    echo $(f_uid)
    ;;
  "bi")
    if $(f_bin_instalado "$2"); then
      echo "El binario esta instalado"
    else
      echo "El binario no esta instalado"
    fi
    ;;
  "pd")
    if $(f_paquete_disponible "$2"); then
      echo "El paquete esta disponible"
    else
      echo "El paquete no esta disponible"
    fi
    ;;
  "ro")
    if $(f_eres_root); then
      echo "Eres root"
    else
      echo "No eres root"
    fi
    ;;
  "c")
    if $(f_hay_conexion); then
      echo "Hay conexion"
    else
      echo "No hay conexion"
    fi
    ;;
  "bq")
    f_buscar_paquetes "$2"
    ;;
  esac
fi