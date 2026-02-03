# Ejemplo: ./diskActivity.sh disco intervalo veces

disk="${1:-sda}"        # disco por defecto: sda
interval="${2:-1}"       # intervalo entre mediciones (segundos)
count="${3:-10}"         # número de muestras

iostat -d "$interval" "$count" | awk -v disk="$disk" '
$1 == disk {
    if (sample_count > 0) {   # saltar la primera lectura (promedio desde arranque)
        if (min_read == "" || $3 < min_read) min_read = $3;
        if (min_write == "" || $4 < min_write) min_write = $4;
    }
    sample_count++;
}
END {
    print  min_read, min_write;
}'

