#!/usr/bin/env bash
#Descripcion: Scrip con multiples Funciones utiles
#Autor: Luca, Alfredo, Dani Berzosa, Frank
#Version: 27

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
      veces=$(($i - 1))
      echo "$(echo $historial | cut -d' ' -f$i)" "$(echo $historial | cut -d' ' -f$veces)"  veces
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
			ej: . funciones.sh ipv4 [int]
	vipv4		Valida una ipv4 pasada como una cadena ej: . funciones.sh vipv4 [ip]
	lt		Limpia los ficheros mas antiguos de una cadena especificada en un direcorio
			ej: . funciones.sh lt [dir] [tiempo-en-dias]
	gl		Genera logins universales a partir de un .csv formateado
			ej: . funciones.sh gl [fich-origen] [fich-destino]
	pa		Revisa si un puerto esta habierto ej: . funciones.sh [host] [puerto]
	l		Guarda un mesaje a un log(por defecto en/var/log/sysadmin.log)
			ej: . funciones.sh l [mensaje] [ruta-fich]
	el		Revisa si hay espacio libre en un punto de montaje segun un espacio
			introducido
			ej: . funciones.sh el [dir] [espacio-minimo-en-porcentaje(ej: 10)]
	vh		Verificar el hash de un fichero respecto a uno proporcionado
			ej: . funciones.sh vh [fich] [hash]
	bd		Revisa los ficheros duplicados de un directorio y permite elimnarlos
			ej: .funciones.sh bd [dir] [modo(CHECK-DELETE)]
FIN

}

#Nombre: f_paquete_instado
#Descripcion: Funcion que permite ver si hay un paquete instalado o no
#Parmetros entrada: una cadena que contiene el nombre del paquete ($2)
#Parametros de salida: 0 si se encuentra instalado, 1 si no

f_paquete_instalado() {

  dpkg -s "$1" >/dev/null 2>&1

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

  if [ "$1" = "" ]; then
    echo "Debes introducir la interfaz a comprobar"
  else
    ip a | grep -E "$1" | grep -Eo '([0-9]{1,3}\.){3}([0-9]){1,3}' | head -n 1
  fi

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

  ping -c 1 8.8.8.8 >/dev/null 2>&1

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
  id -u
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
  paquete=$(apt-file search "$1" | grep "/bin/$1$" | awk -F: '{print $1}')
  if [ "$paquete" = "" ]; then
    return 1
  else
    return 0
  fi
}

#Nombre: f_buscar_paquetes
#Descripcion: Comprueba el nombre del paquete al que pertenece el binario que pasa como argumento
#Parmetros entrada: una cadena con el nombre del paquete ($2)
#Parametros de salida: ninguno

f_buscar_paquetes() {
    apt-file search "$1" | grep "bin/$1$" | head -n 1
}

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


#Nombre: f_limpiar_temporales
#Descripción: Borra archivos antiguos en un directorio específico.
#Parmetros entrada: Ruta del directorio ($1) antiguedad en dias ($2)
#Parametros de salida: Devuelve un 0 si tiene exito y 1 si no encuentra el directorio


f_limpiar_temporales() {

    if [[ ! -d "$1" ]]; then
        return 1
    fi

    find "$1" -type f -mtime +"$2" -delete

    return 0
}

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

#Nombre: f_puerto_abierto
#Descripcion: Verifica si un servicio está escuchando en un puerto específico.
#Parametros entrada: Direccion IP o hostname y el numero de puerto a comprobar
#Parametros salida: 0 si el puerto esta abierto y responde,1 si esta cerrado
#o inalcanzable

f_puerto_abierto(){

#-w 2 para que no se quede buscando infinitamente si el puerto esta cerrado
 nc -z -w 2 "$1" "$2" > /dev/null 2>&1

if [  $? -eq 0 ]; then
  return 0
else
  return 1
fi

}

#Nombre: f_log
#Descripción: Registra un evento en un archivo de log cronológico.
#Parmetros entrada: Mensaje de texto a registrar ($1), ruta del fichero .log ($2)
#Parametros de salida: Devuelve un 0 si se guarda correctamente y 1 si hay un error de permisos
#O el punto de montaje es incorrecto

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


#Nombre: f_espacio_libre
#Descripcion: Comprueba si un punto de montaje tiene suficiente espacio libre.
#Parmetros entrada: Punto de montaje y porcentaje minimo de espacio libre requerido(solo el numero).
#Parametros de salida: Devuelve un 0 si hay espacio suficiente y 1 si no lo hay
#O el punto de montaje es incorrecto

f_espacio_libre(){

  usado=$( df "$1" | tail -1 | awk '{print $5}' | tr -d '%')
  libre=$((100 - usado))

  if [ ! -d "$1" ]; then
    echo "No existe el punto de montaje"
    return 1
  fi

  if [ "$libre" -ge "$2" ]; then
    echo "Hay espacio suficiente"
    return 0
  else
    return 1
  fi

}


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
  find "$1" -type f | while IFS= read -r archivo; do
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
    if f_paquete_instalado "$2"; then
      echo "El paquete esta instalado"
    else
      echo "El paquete no esta instalado"
    fi
    ;;
  "ipv4")
    f_obtener_ipv4 "$2"
    ;;
  "u")
    f_uid
    ;;
  "bi")
    if f_bin_instalado "$2"; then
      echo "El binario esta instalado"
    else
      echo "El binario no esta instalado"
    fi
    ;;
  "pd")
    if f_paquete_disponible "$2"; then
      echo "El paquete esta disponible"
    else
      echo "El paquete no esta disponible"
    fi
    ;;
  "ro")
    if f_eres_root; then
      echo "Eres root"
    else
      echo "No eres root"
    fi
    ;;
  "c")
    if f_hay_conexion; then
      echo "Hay conexion"
    else
      echo "No hay conexion"
    fi
    ;;
  "bp")
    f_buscar_paquetes "$2"
    ;;
  "vipv4")
    if f_es_ip_valida "$2"; then
      echo "Resultado: La IP $1 es válida."
    fi
    ;;
  "lt")
    if f_limpiar_temporales "$2" "$3"; then
      echo "Limpieza realizada conexito"
    else
      echo "No se ha encontrado el directorio"
    fi
    ;;
  "gl")
    f_generar_logins_universal
    ;;
  "pa")
    if f_puerto_abierto "$2" "$3"; then
      echo "El puerto esta abierto y responde"
    else
      echo "El puerto esta cerrado o es inalcanzable"
    fi
    ;;
  "l")
    f_log "$2" "$3"
    ;;
  "el")
    if f_espacio_libre "&2" "$3"; then
      echo "Hay espacio libre"
    else
      echo "No hay espacio libre"
    fi
    ;;
  "vh")
    if f_verificar_hash "$2" "$3"; then
      echo "El hash coincide"
    else
      echo "El hash no coincide"
    fi
    ;;
  "bd")
    if f_borrar_duplicados "$2" "$3"; then
      echo "Ficheros duplicados eliminados con exito"
    else
      echo "Error, el directorio no existe o no tienes permisos sobre el"
    fi
    ;;
  *)
    f_ayuda
    ;;
  esac
fi
