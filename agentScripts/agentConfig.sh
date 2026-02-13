#!/usr/bin/env bash
echo "Configuración del agente";
echo "----------------------";
echo "Introduce el nombre de la interfaz de red a monitorizar: "
read interfaz
disco=$(lsblk | awk '$NF == "/" {print $1}' | sed 's/[^a-zA-Z0-9]//g')

cat >> /var/ossec/etc/ossec.conf << EOF
<ossec_config>

  <!-- CPU, memory, disk metric -->
  <localfile>
     <log_format>full_command</log_format>
     <command>echo \$(top -bn1 | grep Cpu | awk '{print \$2+\$4+\$6+\$12+\$14+\$16}' ; free -m | awk 'NR==2{printf "%.2f\t\t\n", \$3*100/\$2 }' ; df -h | awk '\$NF=="/"{print \$5}'|sed 's/%//g')</command>
     <alias>general_health_metrics</alias>
     <out_format>\$(timestamp) \$(hostname) general_health_check: \$(log)</out_format>
     <frequency>15</frequency>
  </localfile>

<!-- load average metrics -->
  <localfile>
     <log_format>full_command</log_format>
     <command>uptime | grep load | awk '{print \$(NF-2),\$(NF-1),\$NF}' | sed 's/\,\([0-9]\{1,2\}\)/.\1/g'</command>
     <alias>load_average_metrics</alias>
     <out_format>\$(timestamp) \$(hostname) load_average_check: \$(log)</out_format>
     <frequency>15</frequency>
  </localfile>

<!-- memory metrics -->
  <localfile>
     <log_format>full_command</log_format>
     <command>free --bytes| awk 'NR==2{print \$3,\$7}'</command>
     <alias>memory_metrics</alias>
     <out_format>\$(timestamp) \$(hostname) memory_check: \$(log)</out_format>
     <frequency>15</frequency>
  </localfile>

<!-- disk metrics -->
  <localfile>
     <log_format>full_command</log_format>
     <command>df -B1 | awk '\$NF=="/"{print \$3,\$4}'</command>
     <alias>disk_metrics</alias>
     <out_format>\$(timestamp) \$(hostname) disk_check: \$(log)</out_format>
     <frequency>15</frequency>
  </localfile>

  <localfile>
     <log_format>full_command</log_format>
     <command>/home/wazuh/sshDetection.sh wazuh localhost</command>
     <alias>ssh_test_command</alias>
     <out_format>\$(timestamp) \$(hostname) ssh_test: \$(log)</out_format>
     <frequency>60</frequency>
  </localfile>

  <localfile>
     <log_format>full_command</log_format>
     <command>/home/wazuh/diskActivity.sh $disco 1 20</command>
     <alias>disk_activity</alias>
     <out_format>\$(timestamp) \$(hostname) disk_activity: \$(log)</out_format>
     <frequency>60</frequency>
  </localfile>

  <localfile>
     <log_format>full_command</log_format>
     <command>/home/wazuh/net_analysis.sh 30 $interfaz</command>
     <alias>net_activity</alias>
     <out_format>\$(timestamp) \$(hostname) net_activity: \$(log)</out_format>
     <frequency>30</frequency>
  </localfile>

</ossec_config>
EOF
sudo systemctl restart wazuh-agent
