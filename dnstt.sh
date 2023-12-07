
#!/bin/bash

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CORTITLE='\033[1;41m'
SCOLOR='\033[0m'

banner='
 ___ _    _____      _____  _  _ ___ 
/ __| |  / _ \ \    / /   \| \| / __|
\__ \ |_| (_) \ \/\/ /| |) | .  \__ \
|___/____\___/ \_/\_/ |___/|_|\_|___/'

echo -e "${CORTITLE}=====================================${SCOLOR}" 
echo -e "${CORTITLE}       SLOWDNS CLIENT SETUP         ${SCOLOR}"
echo -e "${CORTITLE}=====================================${SCOLOR}" 
echo -e "${RED}$banner${SCOLOR}"

# Download the dns binary
if [ ! -e dns ]; then
    echo -e "\n${GREEN}Downloading the script. Please wait!${SCOLOR}"
    curl -O https://raw.githubusercontent.com/Romba89/slowdns/main/dns > /dev/null 2>&1
fi

# Configure server and key
if [ ! -e $HOME/credenciais ]; then
    read -p "$(echo -e "${GREEN}Enter SlowDNS server (e.g., example.com): ${SCOLOR}")" ns
    read -p "$(echo -e "${GREEN}Enter your SlowDNS key: ${SCOLOR}")" chave
    echo -e "$ns\n$chave" > $HOME/credenciais
fi

# Activate mobile data
echo -ne "\n${RED}[${YELLOW}!${RED}] ${YELLOW}To continue, make sure mobile data is activated. Press ENTER to continue... ${SCOLOR}"
read

# Replace ISP DNS
read -p "$(echo -e "${GREEN}Replace your ISP DNS (e.g., 8.8.8.8): ${SCOLOR}")" -e -i 8.8.8.8 ra

# Run SlowDNS
$HOME/dns -udp $ra:53 -pubkey $(sed -n 2p $HOME/credenciais) $(sed -n 1p $HOME/credenciais) 127.0.0.1:2222 > /dev/null 2>&1 &

echo -e "\n${RED}[${GREEN}√${RED}]${SCOLOR} - ${GREEN}🐌 SLOWDNS CONNECTED✅${SCOLOR} - ${RED}[${GREEN}√${RED}]\n\n${RED}[${YELLOW}!${RED}] ${YELLOW}Now connect to a VPN app or press ENTER to disconnect ${SCOLOR}"
read

# Disconnect from SlowDNS
piddns=$(ps x | grep -w 'dns' | grep -v 'grep' | awk -F' ' {'print $1'})
[ ${piddns} != '' ] && kill ${piddns} > /dev/null 2>&1
