#Nombre: f_limpiar_temporales
#Descripción: Borra archivos antiguos en un directorio específico.
#Parmetros entrada: Ruta del directorio ($1) antiguedad en dias ($2)
#Parametros de salida: Devuelve un 0 si tiene un formato correcto y 1 si no e imprime por la salida de error el error


f_limpiar_temporales() {

    if [[ ! -d "$1" ]]; then
        return 1
    fi

    find "$1" -type f -mtime +"$2" -delete

    return 0
}


f_limpiar_temporales $1 $2