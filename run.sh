#!/bin/bash

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root." 
   exit 1
fi

# Function to get IP input from user
get_ip_input() {
    local ip_var_name=$1
    local default_ip=$2
    local user_input

    if [ -z "$default_ip" ]; then
        read -p "Please enter the $ip_var_name: " user_input
    else
        read -p "Please enter the $ip_var_name [Press enter to use $default_ip]: " user_input
        user_input=${user_input:-$default_ip}
    fi

    echo $user_input
}

# Welcome message
echo " __          __             _              _____ ____  "
echo " \ \        / /            | |       /\   |_   _/ __ \ "
echo "  \ \  /\  / /_ _ _____   _| |__    /  \    | || |  | |"
echo "   \ \/  \/ / _\` |_  / | | | '_ \  / /\ \   | || |  | |"
echo "    \  /\  / (_| |/ /| |_| | | | |/ ____ \ _| || |__| |"
echo "     \/  \/ \__,_/___|\__,_|_| |_/_/    \_\_____\____/ "
echo "                                                       "
echo "                                                       "

# Prompt for installation option
echo "Please select an option:"
echo "1. Install Wazuh from Scratch (Debian, Ubuntu, etc)"
echo "2. Install Wazuh from Scratch (RHEL, CentOS, etc)"
echo "3. Uninstall Wazuh from your system"
read -p "Enter your choice (1, 2, or 3): " choice

if [ "$choice" -eq 1 ]; then
    # Debian/Ubuntu installation script
    # Ask user for IPs
    indexer_ip=$(get_ip_input "indexer-node-ip")
    manager_ip=$(get_ip_input "wazuh-manager-ip" "$indexer_ip")
    dashboard_ip=$(get_ip_input "dashboard-node-ip" "$indexer_ip")

    # First requirements
    sudo apt update
    sudo apt install -y curl tar grep

    # Wazuh installation
    cd /tmp
    sudo curl -sO https://packages.wazuh.com/4.5/wazuh-install.sh
    sudo curl -sO https://packages.wazuh.com/4.5/config.yml

    # Basic configuration
    sudo sed -i "s/<indexer-node-ip>/$indexer_ip/g" config.yml
    sudo sed -i "s/<wazuh-manager-ip>/$manager_ip/g" config.yml
    sudo sed -i "s/<dashboard-node-ip>/$dashboard_ip/g" config.yml

    # Generate config files
    sudo bash wazuh-install.sh --generate-config-files

    # Show the admin password to user with a note to save it
    echo "Please save the following admin password:"
    sudo tar -axf wazuh-install-files.tar wazuh-install-files/wazuh-passwords.txt -O | grep -P "'admin'" -A 1

    # Install Wazuh indexer
    sudo bash wazuh-install.sh --wazuh-indexer node-1

    # Start cluster
    sudo bash wazuh-install.sh --start-cluster

    # Install Wazuh server
    sudo bash wazuh-install.sh --wazuh-server wazuh-1

    # Install Wazuh dashboard
    sudo bash wazuh-install.sh --wazuh-dashboard dashboard

    echo "Wazuh installation is complete."

elif [ "$choice" -eq 2 ]; then
    # RHEL/CentOS installation script
    # Ask user for IPs
    indexer_ip=$(get_ip_input "indexer-node-ip")
    manager_ip=$(get_ip_input "wazuh-manager-ip" "$indexer_ip")
    dashboard_ip=$(get_ip_input "dashboard-node-ip" "$indexer_ip")

    # First requirements
    sudo yum update -y
    sudo yum install -y curl tar grep

    # Wazuh installation
    cd /tmp
    sudo curl -sO https://packages.wazuh.com/4.5/wazuh-install.sh
    sudo curl -sO https://packages.wazuh.com/4.5/config.yml

    # Basic configuration
    sudo sed -i "s/<indexer-node-ip>/$indexer_ip/g" config.yml
    sudo sed -i "s/<wazuh-manager-ip>/$manager_ip/g" config.yml
    sudo sed -i "s/<dashboard-node-ip>/$dashboard_ip/g" config.yml

    # Generate config files
    sudo bash wazuh-install.sh --generate-config-files

    # Show the admin password to user with a note to save it
    echo "Please save the following admin password:"
    sudo tar -axf wazuh-install-files.tar wazuh-install-files/wazuh-passwords.txt -O | grep -P "'admin'" -A 1

    # Install Wazuh indexer
    sudo bash wazuh-install.sh --wazuh-indexer node-1

    # Start cluster
    sudo bash wazuh-install.sh --start-cluster

    # Install Wazuh server
    sudo bash wazuh-install.sh --wazuh-server wazuh-1

    # Install Wazuh dashboard
    sudo bash wazuh-install.sh --wazuh-dashboard dashboard

    echo "Wazuh installation is complete."

elif [ "$choice" -eq 3 ]; then
    # Uninstall Wazuh from /tmp folder
    cd /tmp
    sudo bash wazuh-install.sh --uninstall

    echo "Wazuh uninstallation from your system is complete."

else
    echo "Invalid choice. Please run the script again and select either 1, 2, or 3."
fi
