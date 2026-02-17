# WazuhConfig

A pre-configured Wazuh environment for Linux endpoints.

## Project Structure
```
WazuhConfig/
├── LICENSE
├── README.md
├── agentScripts
│   ├── agentConfig.sh
│   ├── agentInstall.sh
│   └── wazuh-agent_4.13.1-1_amd64.deb
└── managerFiles
    ├── checkStatus.sh
    ├── dashboards.ndjson
    ├── managerConfig.sh
    ├── managerRulesDecoders.sh
    └── variableTypes.txt
```

## Requirements

The agent installation must be performed on a Linux endpoint (DEB/RPM) using the **wazuh** user. Most monitoring scripts are configured this way. If you want to use a different user, you can modify the `/var/ossec/etc/ossec.conf` file accordingly.

## Installation

### Manager Installation

Before installing the agents, it is necessary to install the Wazuh Manager central components: Server, Indexer and Dashboard. This project covers the All-in-one installation.

First, install the default central components using the command below.
It is provided in the Wazuh *quickstart* page.
```bash
curl -sO https://packages.wazuh.com/4.14/wazuh-install.sh && sudo bash ./wazuh-install.sh -a
```
While the installation is running, you can continue by downloading the file `managerFiles/dashboards.ndjson` on the computer where you are going to access the Wazuh Dashboard. It is important that you **download** it and don't use the *Save As...* option, to avoid corrupting the file. 

<img width="1899" height="664" alt="image" src="https://github.com/user-attachments/assets/0c2e3c58-b03a-4ef0-87c1-b527b0d3eeae" />

Once the manager finished the installation, the program will give you the credentials to access the Wazuh Dashboard. There, open the upper left corner menu and navigate to `Dashboard management -> Dashboards management -> Saved objects`and click on *import* and *Check for existing objects -> Request action on conflict*.
If there is any conflict, choose *Overwrite*.

The next step is running the variable configuration script to make Wazuh recognize the variable types in the Dashboard.

```
cd WazuhConfig/managerFiles/
chmod +x managerConfig.sh managerRulesDecoders.sh
sudo ./managerConfig.sh
```

Then, just run the second configuration script, which configures the local rules and decoders.
```
sudo ./managerRulesDecoders.sh
```

And finally, to avoid conflicts regarding variable types, it is necessary to reindex some files. In the Dashboard's upper left menu (the same used in the previous steps to import the dashboards object), go to `Indexer Management -> Dev tools` and paste the next lines, **changing "yyyy.mm.dd"** to the current date with the same format (Example: 2026.03.25). Then, run each chunk of code.
```
POST _reindex
{
  "source": {
    "index": "wazuh-alerts-4.x-yyyy.mm.dd"
  },
  "dest": {
    "index": "wazuh-alerts-4.x-backup"
  }
}

DELETE /wazuh-alerts-4.x-yyyy.mm.dd

POST _reindex
{
  "source": {
    "index": "wazuh-alerts-4.x-backup"
  },
  "dest": {
    "index": "wazuh-alerts-4.x-yyyy.mm.dd"
  }
}
DELETE /wazuh-alerts-4.x-backup
GET /wazuh-alerts-4.x-yyyy.mm.dd

```
And with this, the installation should be complete. Go to `Dashboards management -> Index Patterns -> wazuh-alerts-` and search for the variable `recibidos`. If the type is 'number', it is correct. If you experience any errors later in the dashboards visualizations, repeat the re-indexing step and reload the `wazuh-alerts-` index with clicking the icon on the upper right corner.


### Agent Installation
Once the manager has been installed successfully, you can install the Agent on your Linux endpoint (DEB/RPM). To install it, navigate to the `agentScripts` folder and run this command to make the files executable:
```bash
cd WazuhConfig/agentScripts/
chmod +x agentConfig.sh agentInstall.sh diskActivity.sh net_analysis.sh sshDetection.sh
```

Then, just run the installation script ` agentInstall.sh` and follow the steps.
```bash
./agentInstall.sh
```
Finally, run the configuration script `agentConfig.sh`.
```bash
./agentConfig.sh
```

## More configuration options

### Manager configuration options

#### Email alerts
It is possible to send email alerts as a response to some important security events. In this [link](https://wazuh.com/blog/how-to-send-email-notifications-with-wazuh/), it is shown how to quickly set up email alerts using Postfix as a server relay.

#### Blacklisting, whitelisting, time-ranged logins
In the "Agent control" Dashboard, there are multiple empty bar graphs that show different things. Wazuh allows to set up blacklists, whitelists and a time range in which, if anyone logs into a monitored server, a security alert will pop up.

link para usarlas
para blacklisting, vale con `/var/ossec/etc/lists/malicious-ioc/malicious-ip`
para whitelisting, se recomienda crear la lista wltest, pues ya existe una regla que la analiza.
para time-ranged ... ya está configurado, se puede cambiar en la regla del local local_rules.xml

#### Last time alive check
In the "Agent control" Dashboard there is also a large graph that displays the last time a monitored server reported that it was active. To get this functionality to work, you need to use the `checkStatus.sh` script, and configure some things in it:

- Change the files commented with `#CONFIGURE 1` to the file where you want the script to write its logs.
- Change the files commented with `#CONFIGURE 2` to the file that contains the IP directions that you want to track.
- Add the following lines into the last `<ossec_config>` section of the `/var/ossec/etc/ossec.conf` 
```
  <localfile>
    <log_format>syslog</log_format>
    <location>/home/admin/tools/status/monitored_ips</location> #CONFIGURE 2
  </localfile>
```
- For the script to work correctly, it must be executed by a user whose SSH keys are trusted by the servers being monitored.
- Add the following lines into the last `<ossec_config>` section of the `/var/ossec/etc/ossec.conf`
```
  <localfile>
    <log_format>full_command</log_format>
    <command>sudo -u wazuh /home/admin/tools/status/checkStatus.sh</command>
    <frequency>900</frequency>
  </localfile>
```
And change the command to the path of the configured script. The user executing the command must be the one whose keys trusted by the servers being monitored.

#### AI command analysis
This functionality is currently under development.

### Agent configuration options

After running the configuration script, there are still a lot of things that you can set up to achieve the configuration that best fits your needs.

#### File Integrity Monitoring
The File Integrity Monitoring (FIM) is a really useful tool that allows you to keep track of the changes on files inside a directory.
[Explain how to change the ossec.conf file]
