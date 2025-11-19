#!/bin/bash

# ===== Colors =====
GRAY="\e[1;30m"
GREEN="\e[1;32m"
WHITE="\e[1;37m"
RESET="\e[0m"

# ===== Setup greeting =====
echo -e "${GREEN}Netdata${RESET} ${WHITE}installation script${RESET}"

# ===== Select options =====
echo -e "${GRAY}Do you want${RESET} ${WHITE}automatic updates${RESET}${GRAY}?${RESET} ${WHITE}[Y/n]${RESET}"
read -r autoUpd
echo -e "${GRAY}Do you want${RESET} ${WHITE}nightly releases${RESET}${GRAY}?${RESET} ${WHITE}[Y/n]${RESET}"
read -r nightlyRls
echo -e "${GRAY}Do you want${RESET} ${WHITE}contribute anonymous statistics${RESET}${GRAY}?${RESET} ${WHITE}[Y/n]${RESET}"
read -r anonStat
echo -e "${GRAY}Do you want${RESET} ${WHITE}to connect the node to${RESET} ${GREEN}Netdata Cloud${RESET}${GRAY}?${RESET} ${WHITE}[Y/n]${RESET}"
read -r nodeConnect
if [[ "$nodeConnect" =~ ^[Yy]$ ]]; then
    echo -e "${GRAY}Please write your${RESET} ${WHITE}claim token${RESET}${GRAY}:${RESET}"
    read -r claimToken
fi

# ===== Installation =====
installCommand="wget -O /tmp/netdata-kickstart.sh https://get.netdata.cloud/kickstart.sh && sh /tmp/netdata-kickstart.sh"
dotEnv=""
echo -e "${GRAY}Installing${RESET} ${GREEN}Netdata${RESET}${GRAY}...${RESET}"

# ===== Apply options =====
if [[ "$autoUpd" =~ ^[Nn]$ ]]; then
    installCommand+=" --no-updates"
    dotEnv+=" --no-updates"
fi
if [[ "$nightlyRls" =~ ^[Nn]$ ]]; then
    installCommand+=" --stable-channel"
    dotEnv+=" --stable-channel"
fi
if [[ "$anonStat" =~ ^[Nn]$ ]]; then
    installCommand+=" --disable-telemetry"
    dotEnv+=" --disable-telemetry"
fi
if [[ "$nodeConnect" =~ ^[Yy]$ ]]; then
    installCommand+=" --claim-token \"$claimToken\""
    dotEnv+=" --claim-token \"$claimToken\""
fi

# ===== Run installation =====
echo -e "${WHITE}Running${RESET}${GRAY}: ${installCommand}${RESET}"
sudo bash -c "$installCommand"

# ===== Creating .environment file =====
echo -e "${GRAY}Writing configuration to${RESET} ${WHITE}/etc/netdata/.environment${RESET}"
sudo tee /etc/netdata/.environment >/dev/null <<EOF
NETDATA_PREFIX="$dotEnv"
NETDATA_ADDED_TO_GROUPS=""
EOF

# ===== Finishing the setup =====
echo -e "${GREEN}Netdata installed succesfully!${RESET}"
exit 0