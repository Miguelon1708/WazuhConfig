#!/bin/bash

awk '/"data": \{/{found=1; print; next} 
     found && /"properties": \{/ {print; system("cat variableTypes.txt"); found=0; next}
     1' /etc/filebeat/wazuh-template.json > temp && mv temp /etc/filebeat/wazuh-template.json

sudo filebeat setup -index-management
