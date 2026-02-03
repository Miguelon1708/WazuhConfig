if [ $# -lt 2 ]; then
	echo "NO HAY SUFICIENTES ARGUMENTOS"
fi

# ssh -o PreferredAuthentications=none -o ConnectTimeout=5 -o StrictHostKeyChecking=no -tt -v $1@$2 2>&1 | sed -n "s/.*Authentications that can continue: //Ip" | head -n1 | grep -q password

# ssh -o PreferredAuthentications=none -o ConnectTimeout=3 -o StrictHostKeyChecking=no -tt -v wazuh@localhost 2>&1 | sed -n "s/.*Authentications that can continue: //Ip" | head -n1

LINE=$(ssh -o PreferredAuthentications=none -o ConnectTimeout=5 -o StrictHostKeyChecking=no -tt -v $1@$2 2>&1 \
       | sed -n "s/.*Authentications that can continue: //Ip" \
       | head -n1)

#echo $LINE

if echo "$LINE" | grep -q "password"; then
    echo "ssh yes"
else
    echo "ssh no"
fi
