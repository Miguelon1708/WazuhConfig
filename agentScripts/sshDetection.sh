if [ $# -lt 2 ]; then
	echo "NO HAY SUFICIENTES ARGUMENTOS"
fi

LINE=$(ssh -o PreferredAuthentications=none -o ConnectTimeout=5 -o StrictHostKeyChecking=no -tt -v $1@$2 2>&1 \
       | sed -n "s/.*Authentications that can continue: //Ip" \
       | head -n1)


if echo "$LINE" | grep -q "password"; then
    echo "ssh yes"
else
    echo "ssh no"
fi
