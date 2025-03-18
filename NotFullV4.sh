#!/bin/bash

RED='\033[1;31m'    
GREEN='\033[1;32m'  
YELLOW='\033[1;33m' 
BLUE='\033[1;34m'   
BLACK='\033[0;30m'
NC='\033[0m'        # Puteh

progress_bar() {
    bar_length=10
    duration=0
    step=$((duration * 10 / bar_length)) 
    
    echo -ne "${GREEN}Memuat: <"
    for ((i = 0; i < bar_length; i++)); do
        echo -ne "="
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
    echo -e "${RED}Warning:${BLUE} MEMERLUKAN TOKEN${NC}"
    sleep 1.1
    echo -e "${YELLOW}Buy Token Di XenoHost${NC}"
    sleep 1.5
    echo -e "${GREEN}LANJUT!!!${NC}"
    sleep 2.4
    echo ""
    progress_bar
    clear
}
# untuk mengecek dan menginstal paket yang diperlukan
check_packages() {
    local packages=("docker" "nginx" "git" "certbot" "python3-certbot-nginx" "jq")
    for pkg in "${packages[@]}"; do  
        if ! command -v "$pkg" &>/dev/null; then  
            echo -e "${YELLOW}Downloading $pkg...${NC}"  
            sudo apt install -y "$pkg"
            clear 
        else  
            echo -e "${GREEN}$pkg Installed...${NC}"  
        fi  
    done
}

# untuk mengecek token pengguna
check_token() {
    GITHUB_USER="imastudent112"
    GITHUB_REPO="Key"
    GITHUB_RAW_URL="https://raw.githubusercontent.com/$GITHUB_USER/$GITHUB_REPO/main/Key.txt"

    echo -e "${YELLOW}MASUKAN AKSES TOKEN :${NC}"  
    read -s USER_TOKEN  
    USER_TOKEN=$(echo "$USER_TOKEN" | tr -d '[:space:]' | tr '[:lower:]' '[:upper:]')  

    # Ambil daftar token dan hilangkan spasi yang mungkin ada
    TOKEN_LIST=$(curl -s "$GITHUB_RAW_URL" | tr -d '\r' | tr '[:lower:]' '[:upper:]')

# Pastikan setiap token diproses per baris
IFS=$'\n' read -rd '' -a TOKEN_ARRAY <<< "$TOKEN_LIST"

# Cek apakah token ada dalam daftar
for token in "${TOKEN_ARRAY[@]}"; do
    if [[ "$USER_TOKEN" == "$token" ]]; then
        progress_bar
        echo -e "${GREEN}Token valid! Login berhasil.${NC}"  
        sleep 2
        return  
    fi  
done
        progress_bar
echo -e "${RED}Token salah!${NC}"
    while true; do
        echo -e "${YELLOW}Lanjut pakai Token Giveaway? (y/n/x untuk ulang)${NC}"  
        read -r choice  

        case "$choice" in
            [yYýY]) 
        progress_bar
        sleep 0.6
                clear
                check_ga_token
                return
                ;;
            [xX]) 
                clear
                echo -e "${GREEN}Otewe Restart... Masukin Ulang Token${NC}"
        progress_bar
        sleep 0.8
                check_token
                return
                ;;
            [nNñÑńŃņŅňŇ]) 
                echo -e "${RED}Acces Di Tolak.${NC}"  
                sleep 1
                exit 1
                ;;
            *) 
                echo -e "${RED}Pilihan tidak valid! coba lagi.${NC}"
                ;;
        esac
    done
}

# untuk mengecek token giveaway
check_ga_token() {
    echo -e "${YELLOW}MASUKAN TOKEN GIVEAWAY :${NC}"  
    read -s USER_TOKEN_GA  
    USER_TOKEN_GA=$(echo "$USER_TOKEN_GA" | tr -d '[:space:]' | tr '[:lower:]' '[:upper:]')  

    GITHUB_GIVEAWAY_URL="https://raw.githubusercontent.com/$GITHUB_USER/$GITHUB_REPO/main/Giveaway.txt"
    
    # Simpan hasil curl ke variabel dengan `IFS=$'\n'` untuk membaca per baris
    IFS=$'\n' GA_TOKEN_LIST=($(curl -s "$GITHUB_GIVEAWAY_URL"))

    # Cek apakah token yang diketik ada dalam daftar
     for token2 in "${GA_TOKEN_LIST[@]}"; do
    if [ "$USER_TOKEN_GA" == "$token2" ]; then
        progress_bar
        sleep 0.5
        echo -e "${GREEN}Token Giveaway valid! Login Sukses.${NC}"  
        sleep 2
        return  
    fi
done
        progress_bar
        sleep 0.5
    echo -e "${RED}Token Giveaway salah!${NC}"  
    sleep 2
    exit 1  
}
# untuk menginstal Wings
wings() {
    clear
    echo -e "${RED}WAJIB PASANG NODE DULU${NC}"
    sleep 2

    while true; do  
        echo -e "${YELLOW}INSTALL WINGS MOHON ISI DATA${NC}"
        read -p "$(echo -e "${YELLOW}ID Node: ${NC}")" ID
        read -p "$(echo -e "${YELLOW}Token Pterodactyl: ${NC}")" PLT 
        read -p "$(echo -e "${YELLOW}Web Panel URL (tanpa / di akhir): https://${NC}")" WEB
        read -p "$(echo -e "${YELLOW}Assign Node IP: https://${NC}")" ANI
        echo -e "${RED}WARNING:${YELLOW} URL harus format https://example.com tanpa slash di akhir.${NC}"
        progress_bar
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

        echo -e "${RED}Wings belum berjalan! Memulai Instalasi...${NC}"
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
            exit 1  
        }
        sudo chmod u+x /usr/local/bin/wings
        cd /etc/pterodactyl
        sudo wings configure --panel-url "https://$WEB" --token "$PLT" --node "$ID"

        sudo apt update
        sudo apt install -y certbot python3-certbot-nginx

        if command -v nginx &>/dev/null; then  
            certbot --nginx -d "$ANI" --email Buddyhostofc@gmail.com --agree-tos --non-interactive -v || {  
                echo -e "${RED}Gagal mendapatkan sertifikat!${NC}"  
                exit 1  
            }
            systemctl restart nginx
        fi  

        git clone https://github.com/imastudent112/Wings-service.git
        cd Wings-service
        cp wings.service /etc/systemd/system/
        sudo systemctl daemon-reload
        sudo systemctl enable --now wings
        break
    done
}

#untuk mengecek Wings sudah berjalan
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
    echo -e "${GREEN}Silahkan Check Di Panel/Web${NC}"
    sleep 2
}

welcome
check_packages
check_token
wings
cek_wings
selesai