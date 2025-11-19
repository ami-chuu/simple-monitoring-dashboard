#!/bin/bash

# ===== Colors =====
GRAY="\e[1;30m"
RED="\e[1;31m"
GREEN="\e[1;32m"
WHITE="\e[1;37m"
YELLOW="\e[1;33m"
RESET="\e[0m"

# ===== Warning =====
echo -e "${YELLOW}Do you want to uninstall${RESET} ${GREEN}Netdata${RESET} ${YELLOW}and associated files? [Y/n]${RESET}"
read -r confirmCleanup
if [[ "$confirmCleanup" =~ ^[Nn]$ ]]; then
    echo -e "${RED}Cleanup aborted${RESET}"
    exit 1
fi

# ===== Stopping Netdata service =====
echo -e "${GRAY}Stopping${RESET} ${GREEN}Netdata${RESET} ${GRAY}service...${RESET}"
if systemctl is-active --quiet netdata; then
    sudo systemctl stop netdata
fi

# ===== Removing Netdata =====
echo -e "${GRAY}Removing${RESET} ${GREEN}Netdata${RESET}${GRAY}...${RESET}"
if wget -O /tmp/netdata-kickstart.sh https://get.netdata.cloud/kickstart.sh; then
    sudo chmod +x /tmp/netdata-kickstart.sh
    sudo sh /tmp/netdata-kickstart.sh --uninstall
    echo -e "${GREEN}Netdata uninstalled.${RESET}"
else
    echo -e "${YELLOW}Failed to download uninstall script. Trying to uninstalling manually...${RESET}"

    # Extracting prefixes from .environment
    if [[ -f /etc/netdata/.environment ]]; then
        prefixes=$(grep NETDATA_PREFIX /etc/netdata/.environment | cut -d '"' -f 2)
    else
        echo -e "${RED}ERROR: /etc/netdata/.environment not found. Cannot run manual uninstall.${RESET}"
        exit 1
    fi

    if [[ -z "$prefixes" ]]; then
        echo -e "${RED}Could not detect NETDATA_PREFIX. Aborting uninstall.${RESET}"
        exit 1
    fi

    # Run manual uninstaller
    if [[ -x "${prefixes}/usr/libexec/netdata/netdata-uninstaller.sh" ]]; then
        sudo "${prefixes}/usr/libexec/netdata/netdata-uninstaller.sh" --yes --force --env /etc/netdata/.environment
        echo -e "${GREEN}Manual uninstall completed.${RESET}"
    else
        echo -e "${RED}Manual uninstaller not found at:${RESET} ${WHITE}${prefixes}/usr/libexec/netdata/netdata-uninstaller.sh${RESET}"
        exit 1
    fi
fi

echo -e "${GREEN}Netdata Cleanup complete!${RESET}"
exit 0