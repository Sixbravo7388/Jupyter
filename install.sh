#!/bin/bash

# Clear terminal for clean dashboard view
clear

# ==========================================
# 🌟 PREMIUM COLOR CODES & FX
# ==========================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# FUNCTION: TYPING EFFECT ANIMATION
type_effect() {
    local text="$1"
    local delay="$2"
    for (( i=0; i<${#text}; i++ )); do
        echo -n "${text:$i:1}"
        sleep "$delay"
    done
    echo ""
}

# FUNCTION: LOADING BAR ANIMATION
loading_bar() {
    local title="$1"
    echo -ne "${YELLOW}⏳ $title ${NC}[          ]"
    sleep 0.2
    echo -ne "\b\b\b\b\b\b\b\b\b\b\b[===       ]"
    sleep 0.2
    echo -ne "\b\b\b\b\b\b\b\b\b\b\b[======     ]"
    sleep 0.2
    echo -ne "\b\b\b\b\b\b\b\b\b\b\b[=========  ]"
    sleep 0.2
    echo -ne "\b\b\b\b\b\b\b\b\b\b\b[==========]"
    echo -e " ${GREEN}DONE!${NC}"
}

# AUTOMATED ROOT/SUDO PRIVILEGE CHECK
if [ "$(id -u)" -eq 0 ]; then
    SUDO_CMD=""
else
    SUDO_CMD="sudo"
fi

# ==========================================
# MAIN INTERACTIVE LIST MENU
# ==========================================
show_menu() {
    clear
    echo -e "${RED}==========================================================${NC}"
    echo -e "${WHITE}          [👹 DXD LABS PREMIUM VPS DASHBOARD 👹]          ${NC}"
    echo -e "${RED}==========================================================${NC}"
    echo -e "${WHITE}                ┌─────────────────────────┐               ${NC}"
    echo -e "${WHITE}                │   ${RED}█▀▀█ █──█ █▄─▄█ █▀▀█${WHITE}  │  <[SUKUNA V2] ${NC}"
    echo -e "${WHITE}                │   ${RED}█▄▄█ █▄▄█ █ █ █ █▄▄█${WHITE}  │               ${NC}"
    echo -e "${WHITE}                └─────────────────────────┘               ${NC}"
    echo -e "${PURPLE}                   (█)─(█)     (█)─(█)                   ${NC}"
    echo -e "${PURPLE}                  █████████   █████████                  ${NC}"
    echo -e "${RED}                 ███████████████████████                 ${NC}"
    echo -e "${RED}==========================================================${NC}"
    echo -e "${CYAN}  ____  _____ _   _ ____     ____    _    __  __ ___ _   _  ____ ${NC}"
    echo -e "${CYAN} |  _ \| ____| | | |  _ \   / ___|  / \  |  \/  |_ _| \ | |/ ___|${NC}"
    echo -e "${CYAN} | | | |  _| | | | | |_) | | |  _  / _ \ | |\/| || ||  \| | |  _ ${NC}"
    echo -e "${CYAN} | |_| | |___| |_| |  __/  | |_| |/ ___ \| |  | || || |\  | |_| |${NC}"
    echo -e "${CYAN} |____/|_____|\___/|_|      \____/_/   \_\_|  |_|___|_| \_|\____|${NC}"
    echo -e "${RED}==========================================================${NC}"
    echo ""
    echo -e "${YELLOW}👉 SELECT AN OPTION TO PROCEED FROM LIST:${NC}"
    echo ""
    echo -e "  ${CYAN}[1]${NC} Create & Boot Mobile-Optimized Ubuntu VPS Instance"
    echo -e "  ${CYAN}[2]${NC} Restart Existing VPS Instance"
    echo -e "  ${CYAN}[3]${NC} Modify TCP Port Forward Rules (SSH / WEB Desktop)"
    echo -e "  ${CYAN}[4]${NC} Remove/Clean VPS Cache Files"
    echo -e "  ${CYAN}[5]${NC} Exit Dashboard"
    echo ""
    echo -e "${RED}==========================================================${NC}"
    echo -ne "${WHITE}🔹 Enter Choice [1-5]: ${NC}"
    read -r CHOICE
    
    case $CHOICE in
        1) create_vps ;;
        2) restart_vps ;;
        3) configure_tcp ;;
        4) clean_vps ;;
        5) exit 0 ;;
        *) echo -e "${RED}❌ Invalid Choice! Please select 1-5.${NC}"; sleep 2; show_menu ;;
    esac
}

# STEP 1: CONFIGURE STORAGE & DOWNLOAD CLOUD ARCHITECTURE
create_vps() {
    clear
    echo -e "${RED}==========================================================${NC}"
    echo -e "${WHITE}⚙️  CONFIGURE YOUR VIRTUAL MACHINE SPECIFICATIONS${NC}"
    echo -e "${RED}==========================================================${NC}"
    echo ""
    
    echo -ne "${BLUE}🔹 Enter RAM Size in GB (Default: 48): ${NC}"
    read -r RAM_GB
    RAM_GB=${RAM_GB:-48}

    echo -ne "${BLUE}🔹 Enter CPU Cores (Default: 12): ${NC}"
    read -r CPU_CORES
    CPU_CORES=${CPU_CORES:-12}

    echo -ne "${BLUE}🔹 Enter Disk Space to ADD in GB (Default: 50): ${NC}"
    read -r DISK_ADD
    DISK_ADD=${DISK_ADD:-50}

    echo -ne "${BLUE}🔹 Create Username (Default: ubuntu): ${NC}"
    read -r USER_NAME
    USER_NAME=${USER_NAME:-ubuntu}

    echo -ne "${BLUE}🔹 Create Password (Default: 1234): ${NC}"
    read -r USER_PASS
    USER_PASS=${USER_PASS:-1234}

    echo -ne "${BLUE}🔹 Select Phone Screen Orientation [1] Landscape (1280x720) [2] Portrait (720x1280) (Default: 1): ${NC}"
    read -r ORIENT_CHOICE
    if [ "$ORIENT_CHOICE" == "2" ]; then
        MOBILE_RES="720x1280"
    else
        MOBILE_RES="1280x720"
    fi
    
    TCP_HOST_PORT=${TCP_HOST_PORT:-2222}
    TCP_GUEST_PORT=${TCP_GUEST_PORT:-22}
    WEB_HOST_PORT=${WEB_HOST_PORT:-6080}

    echo ""
    echo -e "${YELLOW}⏳ Installing core dependencies... Please wait.${NC}"
    echo ""
    
    $SUDO_CMD apt-get update -y > /dev/null 2>&1
    $SUDO_CMD apt-get install -y qemu-system-x86 qemu-utils wget cloud-image-utils curl > /dev/null 2>&1
    
    $SUDO_CMD mkdir -p /home/daytona > /dev/null 2>&1
    
    if [ ! -f "/home/daytona/ubuntu22.qcow2" ]; then
        echo -e "${YELLOW}📥 Downloading Ubuntu 22.04 Cloud Image to /home/daytona/...${NC}"
        $SUDO_CMD wget -q --show-progress https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img -O /home/daytona/ubuntu22.qcow2
        $SUDO_CMD chmod 666 /home/daytona/ubuntu22.qcow2
    else
        echo -e "${GREEN}✅ Existing Ubuntu Image Cache Detected at /home/daytona/.${NC}"
    fi
    
    loading_bar "Generating Mobile Cloud-Init Matrix"
    cat <<EOF > /home/daytona/user-data
#cloud-config
ssh_pwauth: True
chpasswd:
  list: |
    ${USER_NAME}:${USER_PASS}
  expire: False

packages:
  - xfce4
  - xfce4-goodies
  - tightvncserver
  - novnc
  - websockify
  - dbus-x11

runcmd:
  - mkdir -p /home/${USER_NAME}/.vnc
  - echo "${USER_PASS}" | vncpasswd -f > /home/${USER_NAME}/.vnc/passwd
  - chmod 600 /home/${USER_NAME}/.vnc/passwd
  - chown -R ${USER_NAME}:${USER_NAME} /home/${USER_NAME}/.vnc
  - cat << 'VNCFILES' > /home/${USER_NAME}/.vnc/xstartup
#!/bin/bash
xrdb \$HOME/.Xresources
startxfce4 &
VNCFILES
  - chmod +x /home/${USER_NAME}/.vnc/xstartup
  - chown ${USER_NAME}:${USER_NAME} /home/${USER_NAME}/.vnc/xstartup
  - su - ${USER_NAME} -c "vncserver :1 -geometry ${MOBILE_RES} -depth 24"
  - su - ${USER_NAME} -c "websockify --web /usr/share/novnc/ 6080 localhost:5901 &"
EOF

    cloud-localds /home/daytona/seed.img /home/daytona/user-data > /dev/null 2>&1
    loading_bar "Expanding Disk Space (+${DISK_ADD}GB)"
    $SUDO_CMD qemu-img resize /home/daytona/ubuntu22.qcow2 +${DISK_ADD}G > /dev/null 2>&1
    
    save_env
    boot_qemu
}

# STEP 2: NETWORK CONTROL MODIFIER
configure_tcp() {
    clear
    echo -e "${YELLOW}==========================================================${NC}"
    echo -e "${WHITE}🔄⚙️  MANAGE CUSTOM TCP PORT FORWARDING RULES ${NC}"
    echo -e "${YELLOW}==========================================================${NC}"
    echo ""
    if [ -f ".vps_env" ]; then
        source .vps_env
    fi
    echo -e "Current Target Host SSH Port  : ${CYAN}${TCP_HOST_PORT:-2222}${NC}"
    echo -e "Current Target Host Desktop Port: ${CYAN}${WEB_HOST_PORT:-6080}${NC}"
    echo ""
    echo -ne "${BLUE}🔹 Enter NEW External Host SSH Port (Default: 2222): ${NC}"
    read -r NEW_HOST_PORT
    TCP_HOST_PORT=${NEW_HOST_PORT:-2222}

    echo -ne "${BLUE}🔹 Enter NEW External Host Mobile Desktop Port (Default: 6080): ${NC}"
    read -r NEW_WEB_PORT
    WEB_HOST_PORT=${NEW_WEB_PORT:-6080}
    
    save_env
    echo ""
    echo -e "${GREEN}✅ TCP Rules Updated Successfully!${NC}"
    sleep 2
    show_menu
}

save_env() {
    cat <<EOF > .vps_env
RAM_GB=${RAM_GB:-48}
CPU_CORES=${CPU_CORES:-12}
USER_NAME=${USER_NAME:-ubuntu}
USER_PASS=${USER_PASS:-1234}
TCP_HOST_PORT=${TCP_HOST_PORT:-2222}
TCP_GUEST_PORT=${TCP_GUEST_PORT:-22}
WEB_HOST_PORT=${WEB_HOST_PORT:-6080}
MOBILE_RES=${MOBILE_RES:-1280x720}
EOF
}

# STEP 3: POPOUT LINK AND RUN THE MASTER EXECUTION COMMAND
boot_qemu() {
    if [ -f ".vps_env" ]; then
        source .vps_env
    fi

    # Terminate conflicting active instances
    pkill -f "qemu-system-x86_64.*ubuntu22.qcow2" > /dev/null 2>&1

    TCP_HOST_PORT=${TCP_HOST_PORT:-2222}
    TCP_GUEST_PORT=${TCP_GUEST_PORT:-22}
    WEB_HOST_PORT=${WEB_HOST_PORT:-6080}
    RAM_VALUE="${RAM_GB:-48}G"

    clear
    echo -e "${GREEN}==========================================================${NC}"
    type_effect "👹 DATA SYSTEM SYNCHRONIZED! PIPING TERMINAL CHANNELS..." 0.02
    echo -e "${GREEN}==========================================================${NC}"
    echo ""
    
    sshx_log=$(mktemp)
    curl -sSf https://sshx.io/get | sh -s run > "$sshx_log" 2>&1 &
    
    sleep 4
    SSHX_URL=$(grep -o 'https://sshx.io/s/[a-zA-Z0-9]*' "$sshx_log" | head -n 1)
    rm -f "$sshx_log"

    clear
    echo -e "${GREEN}==========================================================${NC}"
    echo -e "🎉       DEUP GAMING & DXD LABS - VM NETWORK ACTIVE        "
    echo -e "${GREEN}==========================================================${NC}"
    echo -e "${WHITE}👤 Username   : ${CYAN}${USER_NAME:-ubuntu}${NC}"
    echo -e "${WHITE}🔑 Password   : ${CYAN}${USER_PASS:-1234}${NC}"
    echo -e "${WHITE}⚙️  Resources  : ${CYAN}${RAM_VALUE} RAM | ${CPU_CORES:-12} Cores${NC}"
    echo -e "${WHITE}📱 Display Res : ${CYAN}${MOBILE_RES:-1280x720}${NC}"
    echo -e "${WHITE}🚀 SSH Port    : ${YELLOW}Host Port ${TCP_HOST_PORT} -> VM Port ${TCP_GUEST_PORT}${NC}"
    echo -e "${WHITE}🌐 Desktop Port: ${YELLOW}Host Port ${WEB_HOST_PORT} -> VM Port 6080${NC}"
    echo -e "${RED}----------------------------------------------------------${NC}"
    if [ -n "$SSHX_URL" ]; then
        echo -e "${YELLOW}🔥 POPOUT LIVE ACCESS WEB LINK (Copy & Paste in Browser):${NC}"
        echo -e "${GREEN}👉 $SSHX_URL 👈${NC}"
    else
        echo -e "${RED}⚠️ Tunnel proxy loading slow. Direct local network ports are listening.${NC}"
    fi
    echo -e "${RED}----------------------------------------------------------${NC}"
    echo -e "${WHITE}👉 SSH Connection : ssh ${USER_NAME:-ubuntu}@localhost -p ${TCP_HOST_PORT}${NC}"
    echo -e "${WHITE}👉 Mobile Desktop: http://localhost:${WEB_HOST_PORT}/vnc.html${NC}"
    echo -e "${GREEN}==========================================================${NC}"
    echo ""
    
    qemu-system-x86_64 \
        -hda /home/daytona/ubuntu22.qcow2 \
        -m "$RAM_VALUE" \
        -smp "${CPU_CORES:-12}" \
        -drive file=/home/daytona/seed.img,format=raw \
        -nographic \
        -netdev user,id=net0,hostfwd=tcp::${TCP_HOST_PORT}-:${TCP_GUEST_PORT},hostfwd=tcp::${WEB_HOST_PORT}-:6080 \
        -device e1000,netdev=net0
}

# RESTART PIPELINE
restart_vps() {
    if [ -f "/home/daytona/ubuntu22.qcow2" ] && [ -f "/home/daytona/seed.img" ]; then
        echo -e "${GREEN}🔄 Restarting existing server architecture...${NC}"
        sleep 1
        boot_qemu
    else
        echo -e "${RED}❌ No active configuration blocks found! Build module using Option 1.${NC}"
        sleep 3
        show_menu
    fi
}

# CLEAN PIPELINE
clean_vps() {
    echo -e "${RED}⚠️ Purging system storage components and configurations...${NC}"
    pkill -f "qemu-system-x86_64.*ubuntu22.qcow2" > /dev/null 2>&1
    pkill sshx > /dev/null 2>&1
    $SUDO_CMD rm -rf /home/daytona/user-data /home/daytona/seed.img /home/daytona/ubuntu22.qcow2 .vps_env
    sleep 1
    echo -e "${GREEN}✅ Workspace successfully wiped fresh!${NC}"
    sleep 2
    show_menu
}

# EXECUTE TRIGGER
show_menu
