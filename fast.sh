#!/bin/bash

# Warna
RED='\033[0;91m' GREEN='\033[0;92m' YELLOW='\033[0;93m' NC='\033[0m'

# Cek Token
check_token() {
    local TOKEN_LIST=$(curl -s "https://raw.githubusercontent.com/imastudent112/Key/main/Key.txt" | tr -d '\r' | tr '[:lower:]' '[:upper:]')
    echo -ne "${YELLOW}MASUKAN AKSES TOKEN: ${NC}"; read -s USER_TOKEN
    USER_TOKEN=$(echo "$USER_TOKEN" | tr -d '[:space:]' | tr '[:lower:]' '[:upper:]')

    grep -q "^$USER_TOKEN$" <<< "$TOKEN_LIST" || { echo -e "\n${RED}Token Salah!${NC}"; rm -rf fast.sh; exit 1; }
    echo -e "\n${GREEN}Sukses Login!${NC}"
}

# Install Paket
install_packages() {
    local packages=("docker" "nginx" "git" "certbot" "python3-certbot-nginx" "jq")
    echo -e "${YELLOW}Menginstal paket yang diperlukan...${NC}"
    parallel -j 4 "dpkg -s {} &>/dev/null || apt install -y {}" ::: "${packages[@]}"
}

# Instal Wings
install_wings() {
    clear
    while true; do  
        echo -e "${RED}Isi Data Node Sebelum Lanjut!${NC}"
        read -p "$(echo -e "${YELLOW}ID Node: ${NC}")" ID
        read -p "$(echo -e "${YELLOW}Token Pterodactyl: ${NC}")" PLT 
        read -p "$(echo -e "${YELLOW}Web Panel URL: https://${NC}")" WEB
        read -p "$(echo -e "${YELLOW}Assign Node IP: ${NC}")" ANI

        # Cek Node
        NODE_RESPONSE=$(curl -s -H "Authorization: Bearer $PLT" -H "Accept: Application/json" "https://$WEB/api/application/nodes/$ID")
        NODE_CHECK=$(echo "$NODE_RESPONSE" | jq -r '.attributes.id' 2>/dev/null)

        if [[ "$NODE_CHECK" == "null" || -z "$NODE_CHECK" ]]; then
            echo -e "${RED}Node Ga Ada atau Token Salah! Isi data ulang.${NC}"
            sleep 0.5
            clear
            continue
        fi

        echo -e "${GREEN}Node ditemukan! Gass Install.${NC}"
        sleep 1

        # Instal Docker
        if ! command -v docker &>/dev/null; then
            curl -fsSL https://get.docker.com/ | bash -s -- --channel stable
            systemctl enable --now docker
        fi

        # Download & Setup Wings
        ARCH=$(uname -m)
        [[ "$ARCH" == "x86_64" ]] && ARCH="amd64"
        [[ "$ARCH" == "aarch64" ]] && ARCH="arm64"

        mkdir -p /etc/pterodactyl
        curl -L -o /usr/local/bin/wings "https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_$ARCH"
        chmod u+x /usr/local/bin/wings

        # Konfigurasi Wings
        wings configure --panel-url "https://$WEB" --token "$PLT" --node "$ID"

        # Setup SSL 
        if command -v nginx &>/dev/null; then
            certbot certonly --nginx -d "$ANI" --email Buddyhostofc@gmail.com --agree-tos --non-interactive -v
            systemctl restart nginx
        fi

        # Clone dan Pasang Service
        git clone --depth=1 https://github.com/imastudent112/Wings-service.git /root/Wings-service
        cp /root/Wings-service/wings.service /etc/systemd/system/
        systemctl daemon-reload
        systemctl enable --now wings
        rm -rf /root/Wings-service

        break
    done
}

check_token
install_packages
install_wings
rm -rf fast.sh
echo -e "${GREEN}Instalasi Selesai!${NC}"