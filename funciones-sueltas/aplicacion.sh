f_paquete_instalado() {
  dpkg -s "$1" >/dev/null 2>&1 && echo "0" || echo "1"
}

f_paquete_instalado "$1"
