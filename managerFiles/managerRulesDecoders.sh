#!/usr/bin/env bash

cat >> /var/ossec/etc/rules/local_rules.xml << EOF

<group name="custom rules">

<!-- CPU, Memory and Disk usage -->
<rule id="100054" level="3">
  <decoded_as>general_health_check</decoded_as>
  <description>CPU | MEMORY | DISK usage metrics</description>
</rule>

<!-- High memory usage -->
<rule id="100055" level="5">
  <if_sid>100054</if_sid>
  <field name="memory_usage_%" type="pcre2">^[8-9]\d|100</field>
  <description>Memory usage is high: \$(memory_usage_%)%</description>
  <options>no_full_log</options>
</rule>

<!-- High CPU usage -->
<rule id="100056" level="5">
  <if_sid>100054</if_sid>
  <field name="cpu_usage_%" type="pcre2">^[8-9]\d|100</field>
  <description>CPU usage is high: \$(cpu_usage_%)%</description>
  <options>no_full_log</options>
</rule>

<!-- High disk usage -->
<rule id="100057" level="5">
  <if_sid>100054</if_sid>
  <field name="disk_usage_%" type="pcre2">[7-9]\d|100</field>
  <description>Disk space is running low: \$(disk_usage_%)%</description>
  <options>no_full_log</options>
</rule>

<rule id="100100" level="10" frequency="8" timeframe="270">
  <if_matched_sid>100055</if_matched_sid>
  <description>MEMORIA RAM ALTA DURANTE MÁS DE 4 MINUTOS</description>
</rule>

<rule id="100101" level="10" frequency="8" timeframe="270">
  <if_matched_sid>100056</if_matched_sid>
  <description>CPU ALTA DURANTE MÁS DE 4 MINUTOS</description>
</rule>

<!-- Load average check -->
<rule id="100058" level="3">
  <decoded_as>load_average_check</decoded_as>
  <description>load average metrics</description>
</rule>

<!-- memory check -->
<rule id="100059" level="3">
  <decoded_as>memory_check</decoded_as>
  <description>Memory metrics</description>
</rule>

<!-- Disk check -->
<rule id="100060" level="3">
  <decoded_as>disk_check</decoded_as>
  <description>Disk metrics</description>
</rule>


<rule id="100080" level="3">
  <decoded_as>ssh_test</decoded_as>
  <description>SSH test</description>
  <options>no_full_log</options>
</rule>


<rule id="100081" level="8">
  <if_sid>100080</if_sid>
  <field name="ssh_test_response" type="pcre2">^yes</field>
  <description>SSH con contraseña habilitado.</description>
  <options>no_full_log</options>
</rule>

<rule id="100082" level="3">
  <if_sid>100080</if_sid>
  <field name="ssh_test_response" type="pcre2">^no</field>
  <description>SSH con contraseña NO habilitado.</description>
  <options>no_full_log</options>
</rule>

<rule id="100102" level="9">
  <if_sid>5715</if_sid>
  <time>9 pm - 8 am</time>
  <description>Login exitoso fuera del horario permitido.</description>
  <group>login_time,pci_dss_10.2.5,pci_dss_10.6.1,gpg13_7.1,gpg13_7.2,gdpr_IV_35.7.d,gdpr_IV_32.2,hipaa_164.312.b,nist_800_53_AU.14,nist_800_53_AC.7,nist_800_53_AU.6,</group>
</rule>

<rule id="100103" level="3">
  <decoded_as>disk_act</decoded_as>
  <description>Disk activity</description>
</rule>

<rule id="100104" level="5">
  <if_sid>100103</if_sid>
  <field name="read_kb" type="pcre2">^(5[0-9]{4,}\.00|[6-9][0-9]{4,}\.00|[1-9][0-9]{5,}\.00)$</field>
  <field name="write_kb" type="pcre2">^(5[0-9]{4,}\.00|[6-9][0-9]{4,}\.00|[1-9][0-9]{5,}\.00)$</field>
  <description>Mínimo de lectura y escritura altos.</description>
  <options>no_full_log</options>
</rule>

<rule id="100105" level="10" frequency="5" timeframe="360">
  <if_matched_sid>100104</if_matched_sid>
  <description>Mínimos altos en lectura y escritura durante 5 chequeos seguidos.</description>
</rule>

<rule id="100106" level="14">
    <if_sid>5715</if_sid>
    <list field="srcip" lookup="not_match_key">etc/lists/wltest</list>
    <description>Login fuera de la whitelist.</description>
    <group>authentication_failed,authentication_success,pci_dss_10.2.4,pci_dss_10.2.5</group>
</rule>

<rule id="100107" level="3">
  <decoded_as>gemini_logs</decoded_as>
  <description>Captura de comandos</description>
</rule>

<rule id="100108" level="5">
  <if_sid>100107</if_sid>
  <field name="danger" type="pcre2">^yes</field>
  <description>COMPORTAMIENTO PELIGROSO DETECTADO EN AGENTE \$(id): \$(description)</description>
</rule>

<rule id="100109" level="3">
  <decoded_as>net_activity</decoded_as>
  <description>Tráfico de red (bytes)</description>
</rule>

<rule id="100110" level="3">
  <decoded_as>status_logs</decoded_as>
  <description>Captura de status</description>
</rule>


</group>

EOF


cat >> /var/ossec/etc/decoders/local_decoder.xml << EOF

<!-- CPU, memory, disk metric -->
<decoder name="general_health_check">
     <program_name>general_health_check</program_name>
</decoder>

<decoder name="general_health_check1">
  <parent>general_health_check</parent>
  <prematch>ossec: output: 'general_health_metrics':\.</prematch>
  <regex offset="after_prematch">(\S+) (\S+) (\S+)</regex>
  <order>cpu_usage_%, memory_usage_%, disk_usage_%</order>
</decoder>

<!-- load average metric -->
<decoder name="load_average_check">
     <program_name>load_average_check</program_name>
</decoder>

<decoder name="load_average_check1">
  <parent>load_average_check</parent>
  <prematch>ossec: output: 'load_average_metrics':\.</prematch>
  <regex offset="after_prematch">(\S+), (\S+), (\S+)</regex>
  <order>1min_loadAverage, 5mins_loadAverage, 15mins_loadAverage</order>
</decoder>

<!-- Memory metric -->
<decoder name="memory_check">
     <program_name>memory_check</program_name>
</decoder>

<decoder name="memory_check1">
  <parent>memory_check</parent>
  <prematch>ossec: output: 'memory_metrics':\.</prematch>
  <regex offset="after_prematch">(\S+) (\S+)</regex>
  <order>memory_used_bytes, memory_available_bytes</order>
</decoder>

<!-- Disk metric -->
<decoder name="disk_check">
     <program_name>disk_check</program_name>
</decoder>

<decoder name="disk_check1">
  <parent>disk_check</parent>
  <prematch>ossec: output: 'disk_metrics':\.</prematch>
  <regex offset="after_prematch">(\S+) (\S+)</regex>
  <order>disk_used_bytes, disk_free_bytes</order>
</decoder>

<!-- SSH testing -->
<decoder name="ssh_test">
     <program_name>ssh_test</program_name>
</decoder>

<decoder name="ssh_test_2">
  <parent>ssh_test</parent>
  <prematch>ossec: output: 'ssh_test_command':\.</prematch>
  <regex offset="after_prematch">\S+ (\S+)</regex>
  <order>ssh_test_response</order>
</decoder>

<decoder name="disk_act">
     <program_name>disk_act</program_name>
</decoder>

<decoder name="disk_activity">
  <parent>disk_act</parent>
  <prematch>ossec: output: 'disk_activity':\.</prematch>
  <regex offset="after_prematch">(\S+) (\S+)</regex>
  <order>read_kb, write_kb</order>
</decoder>

<decoder name="disk_activity1">
  <parent>disk_act</parent>
  <prematch>ossec: output: 'disk_act':\.</prematch>
  <regex offset="after_prematch">(\S+) (\S+)</regex>
  <order>read_kb, write_kb</order>
</decoder>

<decoder name="gemini_logs">
  <prematch>COMMAND ANALYSIS: </prematch>
  <regex offset="after_prematch">(\S+) (\S+) (\.*)</regex>
  <order>id, danger, description</order>
</decoder>

<decoder name="net_activity">
  <program_name>net_activity</program_name>
</decoder>

<decoder name="net_activity1">
  <parent>net_activity</parent>
  <prematch>ossec: output: 'net_activity':\.</prematch>
  <regex offset="after_prematch">(\S+) (\S+)</regex>
  <order>transmitidos_kb, recibidos_kb</order>
</decoder>

<decoder name="status_logs">
  <prematch></prematch>
  <regex>(\S+) (\.*)</regex>
  <order>ip, last_check</order>
</decoder>

EOF

sudo systemctl restart wazuh-manager
