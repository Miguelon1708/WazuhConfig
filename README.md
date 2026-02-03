# WazuhConfig

A pre-configured version of Wazuh for Linux Endpoints.

## Project Structure
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

## Installation

### Manager Installation
[Add instructions here on how to install the manager]

### Agent Installation
Once the manager has been installed successfully, you can install the Agent on your Linux endpoint (DEB/RPM). To install it, navigate to the `agentScripts` folder and run this command to make the files executable:
```bash
cd WazuhConfig/agentScripts/
chmod +x agentConfig.sh agentInstall.sh diskActivity.sh net_analysis.sh sshDetection.sh
```
