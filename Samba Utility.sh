#!/bin/bash

# Detect Homebrew install location
if [[ -x "/opt/homebrew/sbin/samba-dot-org-smbd" ]]; then
  BREW_PREFIX="/opt/homebrew"
elif [[ -x "/usr/local/sbin/samba-dot-org-smbd" ]]; then
  BREW_PREFIX="/usr/local"
else
  echo "❌ Samba not found."
  read -p "Do you want to install Samba via Homebrew? [y/N]: " install_choice
  if [[ "$install_choice" =~ ^[Yy]$ ]]; then
    echo "🔧 Installing Samba..."
  if command -v brew >/dev/null 2>&1; then
        brew install samba || { echo "❌ Installation failed. Exiting."; exit 1; }
        echo "✅ Samba installed successfully."
  else
    echo "❌ Samba is required. Exiting."
    exit 1
  fi
    BREW_PREFIX="$(brew --prefix)"
  else
    echo "❌ Homebrew is not installed. Please install Homebrew first: https://brew.sh"
    exit 1
  fi
fi

SMBD="$BREW_PREFIX/sbin/samba-dot-org-smbd"
NMBD="$BREW_PREFIX/sbin/nmbd"
SMB_CONF="$BREW_PREFIX/etc/smb.conf"
LOG_FILE="$BREW_PREFIX/var/log/samba/log.smbd"

GREEN="\033[0;32m"
RED="\033[0;31m"
CYAN="\033[0;36m"
NC="\033[0m"

# Show current status before menu
echo -e "${CYAN}Current Samba status:${NC}"
if pgrep -f "$SMBD" > /dev/null; then
  echo -e "✅ smbd is ${GREEN}running${NC}"
else
  echo -e "❌ smbd is ${RED}not running${NC}"
fi
echo ""
echo -e "${CYAN}== Samba Utility ==${NC}"
echo "Choose an option:"
echo "1) Start Samba"
echo "2) Stop Samba"
echo "3) Restart Samba"
echo "4) Show Status"
echo "5) Show Last Logs"
echo "6) Show config file in Finder"
echo "7) Backup Configuration"
echo "8) Test Configuration"
echo "9) Run in Debug Mode"
echo "10) Exit"
read -p "Enter choice [1-10]: " choice

check_config_file() {
  if [[ ! -f "$SMB_CONF" ]]; then
    echo -e "${RED}smb.conf not found at:$NC $SMB_CONF"
    read -p "📁 Do you want to open the folder in Finder to create the file? [y/N]: " create_choice
    if [[ "$create_choice" =~ ^[Yy]$ ]]; then
      open -R "$SMB_CONF"
    fi
    return 1
  fi
  return 0
}

start_samba() {
  check_config_file || return

  echo -e "${CYAN}Checking configuration...${NC}"
  # Only show errors, suppress normal dump
  if ! testparm -s "$SMB_CONF" >/dev/null; then
    echo -e "${RED}Invalid configuration file.${NC}"
    return
  fi

  echo -e "${CYAN}Starting smbd...${NC}"
  sudo "$SMBD" -s "$SMB_CONF" || { echo -e "${RED}Failed to start smbd${NC}"; return; }

  echo -e "${CYAN}Starting nmbd...${NC}"
  sudo "$NMBD" -s "$SMB_CONF" || { echo -e "${RED}Failed to start nmbd${NC}"; return; }

  echo -e "${GREEN}Samba started successfully.${NC}"
}

restart_samba() {
  check_config_file || return
  stop_samba
  sleep 1
  start_samba
}

test_config() {
  check_config_file || return
  echo -e "${CYAN}Testing smb.conf...${NC}"
  # Silent testparm
  if ! testparm -s "$SMB_CONF" >/dev/null; then
    echo -e "${RED}Configuration has errors.${NC}"
  else
    echo -e "${GREEN}smb.conf is valid.${NC}"
  fi
}

status_samba() {
  echo -e "${CYAN}Checking Samba status...${NC}"
  pgrep -f "$SMBD" > /dev/null &&     echo -e "✅ smbd is ${GREEN}running${NC}" ||     echo -e "❌ smbd is ${RED}not running${NC}"
  pgrep -f "$NMBD" > /dev/null &&     echo -e "✅ nmbd is ${GREEN}running${NC}" ||     echo -e "❌ nmbd is ${RED}not running${NC}"
}

show_logs() {
  echo -e "${CYAN}== Last Samba Logs ==${NC}"
  [[ -f "$LOG_FILE" ]] && tail -n 20 "$LOG_FILE" || echo -e "${RED}Log file not found.${NC}"
}


backup_config() {
  check_config_file || return
  backup_file="${SMB_CONF}.backup.$(date +%Y%m%d-%H%M%S)"
  cp "$SMB_CONF" "$backup_file" && echo -e "${GREEN}Backup created: $backup_file${NC}" || echo -e "${RED}Failed to create backup.${NC}"
}

debug_mode() {
  check_config_file || return
  echo -e "${CYAN}Starting smbd in debug mode...${NC}"
  sudo "$SMBD" -i -d 3 -s "$SMB_CONF"
}

open_config_finder() {
  echo -e "${CYAN}Opening smb.conf in Finder...${NC}"
  if [[ -f "$SMB_CONF" ]]; then
    open -R "$SMB_CONF"
  else
    echo -e "${RED}smb.conf not found at: $SMB_CONF${NC}"
  fi
}

case "$choice" in
  1) start_samba ;;
  2) stop_samba ;;
  3) restart_samba ;;
  4) status_samba ;;
  5) show_logs ;;
  7) test_config ;;
  8) backup_config ;;
  9) debug_mode ;;
  10) echo -e "${CYAN}Goodbye!${NC}" ;;
  6) open_config_finder ;;
  *) echo -e "${RED}Invalid choice.${NC}" ;;
esac