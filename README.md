# WazuhConfig
A pre-configured version of Wazuh (Linux Endpoints).

## Project structure:
```
WazuhConfig/
├── agentScripts
│   ├── agentConfig.sh
│   ├── agentInstall.sh
│   ├── diskActivity.sh
│   ├── net_analysis.sh
│   └── sshDetection.sh
├── LICENSE
└── README.md
```

## Installation
### Manager Instalation


hola asi se instalael manager
### Agent instalation
Once the manager has been installed succesfully, you can install the Agent in your Linux endpoint (DEB/RPM).
To install it, go to the agentScripts folder and run this command to make the files executable:
```
cd WazuhConfig/agentScripts/
chmod +x agentConfig.sh agentInstall.sh diskActivity.sh net_analysis.sh sshDetection.sh
```
