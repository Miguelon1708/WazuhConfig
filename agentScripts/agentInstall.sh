#!/usr/bin/env bash

echo "Instalación del agente";
echo "----------------------";
echo "Introduce la IP del servidor (donde está el wazuh-manager):"
read ipservidor
echo "Introduce el tipo de sistema operativo en el que se instalará el agente (1. DEB, 2. RPM):"
read tipo
echo "Introduce el nombre del agente."
echo "Mínimo 2 caracteres. Permitidos: A-Z, a-z, 0-9, ".", "-", "_" :"
read nombre
longitud=${#nombre}
#echo $longitud
#si da tiempo, meter comrpobación de Regex y longitud del string.
if [[ $tipo == "1" ]]; then
	#echo Estás en un sistema de tipo DEB.
	#echo El comando sería el siguiente:
	wget https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.13.1-1_amd64.deb && sudo WAZUH_MANAGER=$ipservidor WAZUH_AGENT_NAME=$nombre dpkg -i ./wazuh-agent_4.13.1-1_amd64.deb	
elif [[ $tipo == "2" ]]; then
	#echo Estás en un sistema de tipo RPM
	#echo El comande sería el siguiente:
	curl -o wazuh-agent-4.13.1-1.x86_64.rpm https://packages.wazuh.com/4.x/yum/wazuh-agent-4.13.1-1.x86_64.rpm && sudo WAZUH_MANAGER=$ipservidor WAZUH_AGENT_NAME=$nombre rpm -ihv wazuh-agent-4.13.1-1.x86_64.rpm
else
	echo Error. Introduce una opción válida !!
	exit 0
fi;
sudo systemctl daemon-reload
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent

mv sshDetection.sh diskActivity.sh net_analysis.sh /home/wazuh
