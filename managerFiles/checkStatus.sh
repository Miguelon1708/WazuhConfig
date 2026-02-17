#! /bin/bash

> /tmp/temp.txt
> /home/wazuh/WazuhConfig/managerFiles/logs #CONFIGURE 1
while read rawline; do
        line=$(echo "$rawline" | awk '{print $1}')
        echo $line >> /home/wazuh/WazuhConfig/managerFiles/logs #CONFIGURE 1
        salida=$(timeout 5 ssh -n wazuh@$line 'date')
        quienSoy=$(whoami)
        echo $quienSoy >> /home/wazuh/WazuhConfig/managerFiles/logs #CONFIGURE 1
        echo $salida >> /home/wazuh/WazuhConfig/managerFiles/logs #CONFIGURE 1
        filtered=$(echo "$salida" | awk '{print $2, $3, $4}')
        forTheCheck=$(echo "$filtered" | tr -d ' \t\n')
        if [[ -z $forTheCheck ]]; then
                echo "$rawline" >> /tmp/temp.txt
                echo nada >> /home/wazuh/WazuhConfig/managerFiles/logs #CONFIGURE 1
        else
                echo 'La salida para el pc' $line 'es: '$filtered >> /home/wazuh/WazuhConfig/managerFiles/logs #CONFIGURE 1
                echo "$line" "$filtered" >> /tmp/temp.txt
        fi
done < /home/wazuh/WazuhConfig/managerFiles/mon_ips #CONFIGURE 2
mv /tmp/temp.txt /home/wazuh/WazuhConfig/managerFiles/mon_ips #CONFIGURE 2
