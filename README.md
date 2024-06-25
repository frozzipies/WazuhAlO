## Wazuh AIO (All in One)
Automate your Wazuh installation, configuration, and setup with this easy-to-use bash script. This script is designed for Linux (Debian, Ubuntu, RHEL, CentOS, etc) systems and simplifies the process of installing and configuring Wazuh components, including the Wazuh Indexer, Wazuh Manager, Wazuh Dashboard, and many other Wazuh configurations

## Features
- Automated Installation: Easily install Wazuh on Debian/Ubuntu or RHEL/CentOS systems with minimal user input.
- IP Configuration: Prompt users to configure indexer, manager, and dashboard IP addresses for seamless setup.
- Config File Generation: Automatically generate configuration files based on user input.
- Cluster Setup: Includes options to start Wazuh cluster services after installation for scalability.
- Uninstallation: Provides an option to completely uninstall Wazuh from the system.
- Fail2ban, IPtables, Suricata, etc Integration (soon)

## Prerequisites
This script should be run with `root` privileges. You can use sudo to execute it.

## Usage
1. Clone the repository `git clone https://github.com/frozzipies/WazuhAlO/ && cd WazuhAIO`
2. Run the script `sudo bash run.sh`
3. Choose an option based on what you need
   
![image](https://github.com/frozzipies/WazuhAlO/assets/97401702/c592c9b9-50ad-4f43-96b0-04090b04e3ea)

## Note
This tool is currently under development. Stay tuned for updates and improvements
