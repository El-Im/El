#!/bin/bash

R='\033[0;101m'
RED='\033[0;91m'
GREEN='\033[0;92m'
YELLOW='\033[0;93m'
BLUE='\033[1;94m'  
NC='\033[0m'
rai() {
    TEXT="Sukses Login"
    COLORS=("\033[1;91m" "\033[1;93m" "\033[1;92m" "\033[1;96m" "\033[1;94m" "\033[1;95m")
    NC="\033[0m"

    for (( i=0; i<${#TEXT}; i++ )); do
        COLOR_INDEX=$((i % ${#COLORS[@]})) 
        echo -ne "${COLORS[COLOR_INDEX]}${TEXT:i:1}${NC}"
        sleep 0.02 
    done
    echo ""
    sleep 0.5
}
bai() {
    TEXT="wa.me/6289529159381"
    COLORS=("\033[1;91m" "\033[1;93m" "\033[1;92m" "\033[1;96m" "\033[1;94m" "\033[1;95m")
    NC="\033[0m"

    for (( i=0; i<${#TEXT}; i++ )); do
        COLOR_INDEX=$((i % ${#COLORS[@]})) 
        echo -ne "${COLORS[COLOR_INDEX]}${TEXT:i:1}${NC}"
        sleep 0.02 
    done
    echo ""
    sleep 0.5
}
progress_bar() {
    bar_length=10
    duration=0
    step=$((duration * 10 / bar_length)) 
    
    echo -ne "${GREEN}Memuat: <"
    for ((i = 0; i < bar_length; i++)); do
        echo -ne "■"
        sleep .$step
    done
    echo -e ">[100%]${NC}"
    sleep 2.5
}
import_bar() {
    bar_length=13
    duration=0
    step=$((duration * 10 / bar_length)) 
    
    echo -ne "${BLUE}MengImport Data:${GREEN} <"
    for ((i = 0; i < bar_length; i++)); do
        echo -ne "■"
        sleep .$step
    done
    echo -e ">${BLUE} [100%]${NC}"
    sleep 2.5
}
exit_bar() {
    bar_length=30
    duration=5
    step=$((duration * 10 / bar_length)) 
    
    echo -ne "${GREEN}Keluar: <"
    for ((i = 0; i < bar_length; i++)); do
        echo -ne "■"
        sleep .$step
    done
    echo -e ">[100%]${NC}"
    sleep 2.5
}

# Sambutan
welcome() {
    clear
    sleep 0.2
    echo -e "${YELLOW}Node 2 Installer By Xeno${NC}"
    sleep 1
    echo -e "${R}${RED}Warning:${NC} MEMERLUKAN TOKEN${NC}"
    sleep 1.1
    echo -e "${BLUE}Buy Token Di XenoHost ${NC}"
    bai
    sleep 1.5
    echo -e "${GREEN}LANJUT!!!${NC}"
    sleep 2
    echo ""
    progress_bar
    clear
}

check_packages() {
    local packages=("docker" "nginx" "git" "certbot" "python3-certbot-nginx" "jq")
    for pkg in "${packages[@]}"; do  
        if ! command -v "$pkg" &>/dev/null; then  
            echo -e "${YELLOW}Downloading $pkg...${NC}"  
            yes | sudo apt install -y "$pkg"
            clear 
        else  
            echo -e "${GREEN}$pkg Installed...${NC}"  
        fi  
    done
}

# untuk ngecek token
check_token() {
    GITHUB_USER="imastudent112"
    GITHUB_REPO="Key"
    GITHUB_RAW_URL="https://raw.githubusercontent.com/$GITHUB_USER/$GITHUB_REPO/main/Key.txt"

    echo -e "${YELLOW}MASUKAN AKSES TOKEN :${NC}"  
    read -s USER_TOKEN  
    USER_TOKEN=$(echo "$USER_TOKEN" | tr -d '[:space:]' | tr '[:lower:]' '[:upper:]')  

    TOKEN_LIST=$(curl -s "$GITHUB_RAW_URL" | tr -d '\r' | tr '[:lower:]' '[:upper:]')

IFS=$'\n' read -rd '' -a TOKEN_ARRAY <<< "$TOKEN_LIST"

for token in "${TOKEN_ARRAY[@]}"; do
    if [[ "$USER_TOKEN" == "$token" ]]; then
        progress_bar
        rai
        return  
    fi  
done
        progress_bar
echo -e "${RED}Token salah!${NC}"
    while true; do
        echo -e "${NC}Berminat Masukan Token Ulang? ${YELLOW}(Y/n)${NC}"  
        read -r choice  
case "$choice" in
            [yY])
                echo -e "${GREEN}Otewe Restart... Masukin Ulang Token${NC}"
                clear
        progress_bar
        sleep 0.8
                check_token
                return
                ;;
            [nNñÑńŃņŅňŇ]) 
                echo -e "${RED}Nice Have A Nice Day.${NC}"  
                exit_bar
                sleep 1
               rm -rf Full_AutoNodeV4.sh
               exit 1
                ;;
            *) 
                echo -e "${RED}Lu Pick Apa Bzir.${NC}"
                ;;
        esac
    done
}
# untuk menginstal Wings
wings() {
    clear
    echo -e "${RED}Sebelum Memulai Pasang Buat Node Dulu Di Panel
${NC}"
    sleep 2

    while true; do  
        echo -e "${YELLOW}INSTALL WINGS MOHON ISI DATA${NC}"
        read -p "$(echo -e "${YELLOW}ID Node: ${NC}")" ID
        read -p "$(echo -e "${YELLOW}Token Pterodactyl: ${NC}")" PLT 
        read -p "$(echo -e "${YELLOW}Web Panel URL (tanpa / di akhir): https://${NC}")" WEB
        read -p "$(echo -e "${YELLOW}Assign Node IP (tanpa / di akhir) : https://${NC}")" ANI
        echo -e "${RED}WARNING:${YELLOW} URL harus https://example.com tanpa / di akhir.${NC}"
        import_bar
        echo -e "${GREEN}Sukses Import"
        sleep 1

        text="Melakukan Pengecekan Node"
        echo -ne "${YELLOW}"
        for ((i=0; i<${#text}; i++)); do
            echo -ne "${text:$i:1}"
            sleep 0.01
        done
        echo -e "${NC}"

        NODE_RESPONSE=$(curl -s -H "Authorization: Bearer $PLT" -H "Accept: Application/json" "https://$WEB/api/application/nodes/$ID")

NODE_CHECK=$(echo "$NODE_RESPONSE" | jq -r '.attributes.id' 2>/dev/null)

if [[ "$NODE_CHECK" == "null" || -z "$NODE_CHECK" ]]; then
    echo -e "${RED}Node Ga Ada atau Token Salah! Isi data ulang.${NC}"
    sleep 2
    clear
    continue
fi
    echo -e "${GREEN}Node ditemukan! Gass Install.${NC}"
    sleep 2
        echo -e "${YELLOW}Mengecek Status Wings...${NC}"
        if systemctl is-active --quiet wings; then
            echo -e "${GREEN}Wings udah Jalan! Kalau Mau Fix Wings Mohon Stop Wings Dulu${NC}"
            return
        fi

        echo -e "${RED}Wings belum Nyala. Install Di Mulai${NC}"
        sleep 2

        if ! command -v docker &>/dev/null; then  
            curl -fsSL https://get.docker.com/ | bash -s -- --channel stable
            sudo systemctl enable --now docker
        fi

        sudo mkdir -p /etc/pterodactyl
        ARCH=$(uname -m)
        [[ "$ARCH" == "x86_64" ]] && ARCH="amd64"
        [[ "$ARCH" == "aarch64" ]] && ARCH="arm64"

        curl -L -o /usr/local/bin/wings "https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_$ARCH" || {  
            echo -e "${RED}Gagal mengunduh Wings!${NC}"  
            rm -rf Full_AutoNodeV4.sh
           exit 1
        }
        sudo chmod u+x /usr/local/bin/wings
        cd /etc/pterodactyl
        sudo wings configure --panel-url "https://$WEB" --token "$PLT" --node "$ID"

        yes | sudo apt update
        yes | sudo apt install -y certbot python3-certbot-nginx

        if command -v nginx &>/dev/null; then  
            certbot certonly --nginx -d "$ANI" --email Buddyhostofc@gmail.com --agree-tos --non-interactive -v || {  
                echo -e "${RED}Gagal mendapatkan sertifikat!${NC}"  
                rm -rf Full_AutoNodeV4.sh
               exit 1
            }
            systemctl restart nginx
        fi  

        git clone https://github.com/imastudent112/Wings-service.git
        cd Wings-service
        cp wings.service /etc/systemd/system/
        sudo systemctl daemon-reload
        sudo systemctl enable --now wings
        sudo systemctl start wings
        break
    done
}

cek_wings() {
    if systemctl is-active --quiet wings; then  
        echo -e "${GREEN}Wings Is Actived.${NC}"  
    else  
        systemctl restart wings  
        sleep 3
    fi
}

# akhir
selesai() {
    echo -e "${GREEN}Silahkan Check Di $WEB ${NC}"
    exit_bar
    sleep 1
    rm -rf Full_AutoNodeV4.sh
   exit 1
}

# Jalankan semua fungsI
welcome
check_token
check_packages
wings
cek_wings
selesai
