# WazuhConfig

A pre-configured version of Wazuh for Linux endpoints.

## Project Structure (update when finished)
```
WazuhConfig/
├── agentScripts/
│   ├── agentConfig.sh
│   ├── agentInstall.sh
│   ├── diskActivity.sh
│   ├── net_analysis.sh
│   └── sshDetection.sh
├── LICENSE
└── README.md
```

## Requirements

The agent installation must be performed on a Linux endpoint (DEB/RPM) using the **wazuh** user. Most monitoring scripts are configured this way. If you want to use a different user, you can modify the `/var/ossec/etc/ossec.conf` file accordingly.

## Installation

### Manager Installation
[Add instructions here on how to install the manager]

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

### Manager config options add here

#### Email alerts

#### add more

### Agent configuration options

After running the configuration script, there are still a lot of things that you can set up to achieve the configuration that best fits your needs.

#### File Integrity Monitoring
The File Integrity Monitoring (FIM) is a really useful tool that allows you to keep track of the changes on files inside a directory.
[Explain how to change the ossec.conf file]
