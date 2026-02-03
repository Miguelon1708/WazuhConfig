# ./net_analysis segundos interfaz
# ejemplo: ./net_analysis 10 eth0
SEGUNDOS=$1
INICIO1=$(cat /sys/class/net/$2/statistics/tx_bytes)
INICIO2=$(cat /sys/class/net/$2/statistics/rx_bytes)

sleep $SEGUNDOS
FINAL1=$(cat /sys/class/net/$2/statistics/tx_bytes)
FINAL2=$(cat /sys/class/net/$2/statistics/rx_bytes)

DIFERENCIA1=$(($FINAL1-$INICIO1))
derivada1=$(( $DIFERENCIA1/$SEGUNDOS )) #transmitidos

DIFERENCIA2=$(($FINAL2-$INICIO2))
derivada2=$(( $DIFERENCIA2/$SEGUNDOS )) #enviados

echo $derivada1 $derivada2
