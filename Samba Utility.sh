#!/bin/bash

# Paths
SMB_CONF="/opt/homebrew/etc/smb.conf"
SMBD="/opt/homebrew/sbin/samba-dot-org-smbd"
NMBD="/opt/homebrew/sbin/nmbd"

# Colors
GREEN="\033[0;32m"
RED="\033[0;31m"
CYAN="\033[0;36m"
NC="\033[0m" # No Color

# Header
echo -e "${CYAN}== Samba Manager ==${NC}"
echo "Choose an option:"
echo "1) Start Samba"
echo "2) Stop Samba"
echo "3) Restart Samba"
echo "4) Show Status"
echo "5) Exit"
read -p "Enter choice [1-5]: " choice

# Functions
start_samba() {
  echo -e "${CYAN}Starting smbd...${NC}"
  sudo "$SMBD" -s "$SMB_CONF" || { echo -e "${RED}Failed to start smbd${NC}"; return; }
  
  echo -e "${CYAN}Starting nmbd...${NC}"
  sudo "$NMBD" -s "$SMB_CONF" || { echo -e "${RED}Failed to start nmbd${NC}"; return; }

  echo -e "${GREEN}Samba started successfully.${NC}"
}

stop_samba() {
  echo -e "${CYAN}Stopping Samba processes...${NC}"
  sudo pkill -f "$SMBD"
  sudo pkill -f "$NMBD"
  echo -e "${GREEN}Samba stopped.${NC}"
}

restart_samba() {
  stop_samba
  sleep 1
  start_samba
}

status_samba() {
  echo -e "${CYAN}Checking Samba status...${NC}"
  if pgrep -f "$SMBD" > /dev/null; then
    echo -e "✅ smbd is ${GREEN}running${NC}"
  else
    echo -e "❌ smbd is ${RED}not running${NC}"
  fi

  if pgrep -f "$NMBD" > /dev/null; then
    echo -e "✅ nmbd is ${GREEN}running${NC}"
  else
    echo -e "❌ nmbd is ${RED}not running${NC}"
  fi
}

# Handle input
case "$choice" in
  1) start_samba ;;
  2) stop_samba ;;
  3) restart_samba ;;
  4) status_samba ;;
  5) echo -e "${CYAN}Goodbye!${NC}" ;;
  *) echo -e "${RED}Invalid choice.${NC}" ;;
esac