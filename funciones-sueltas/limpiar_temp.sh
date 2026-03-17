#Borra archivos antiguos en un directorio específico.
#Entrada:
#  $1: Ruta del directorio.
#  $2: Antigüedad en días (ej: 7 para borrar archivos de más de una semana).
#Devuelve:
#  0: Limpieza realizada.
#  1: Directorio no encontrado.


f_limpiar_temporales() {

    if [[ ! -d "$1" ]]; then
        return 1
    fi

    find "$1" -type f -mtime +"$2" -delete

    return 0
}
f_limpiar_temporales $1 $2


