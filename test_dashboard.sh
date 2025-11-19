#!/bin/bash

# ===== Colors =====
GRAY="\e[1;30m"
GREEN="\e[1;32m"
WHITE="\e[1;37m"
YELLOW="\e[1;33m"
RESET="\e[0m"

# ===== Check stress-ng installed =====
if ! command -v stress-ng &> /dev/null; then
    echo -e "${YELLOW}stress-ng not found.${RESET} ${GRAY}Installing..."
    sudo apt-get update
    sudo apt-get install -y stress-ng
fi

# ===== CPU Stress Test =====
echo -e "${GRAY}Starting${RESET} ${GREEN}CPU${RESET} ${WHITE}stress test${RESET}${GRAY}..."
sudo stress-ng --cpu 0 --cpu-method all --timeout 60

# ===== RAM Stress Test =====
echo -e "${GRAY}Starting${RESET} ${GREEN}Memory${RESET} ${WHITE}stress test${RESET}${GRAY}..."
sudo stress-ng --vm 1 --vm-bytes 80% --timeout 60

# ===== Disk Stress Test =====
echo -e "${GRAY}Starting${RESET} ${GREEN}Disk I/O${RESET} ${WHITE}stress test${RESET}${GRAY}..."
sudo stress-ng --hdd 1 --hdd-opts direct --timeout 60

echo -e "${GREEN}Stress test completed!"
exit 0