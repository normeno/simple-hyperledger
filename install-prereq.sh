#!/bin/bash
#
# author: 	Nicolás Ormeño
# email: 	ni.ormeno at gmail dot cl
# license: 	GPL V3
# date:		20200110
# description:	Script para instalar los requerimientos básicos para comenzar a trabajar con Hyperledger
#
#
clear

# Variables
I_AM=$(whoami)

printf "\n### Trabajando con usuario: $I_AM ###\n\n"


# Actualizar sistema
sudo apt update && sudo apt upgrade -y


# Instalar dependencias básicas
sudo apt install unzip \
	wget \
	git \
	tree \
	telnetd \
	httping \
	tcptraceroute \
    hping3 \
    vim -y

cd /usr/bin/ \
	&& sudo wget http://pingpros.com/pub/tcpping \
	&& sudo chmod 755 tcpping


# Instalar Docker
if hash docker 2>/dev/null; then
    DOCKER_VERSION=$(docker -v)
    printf "\n### DOCKER INSTALADO PREVIAMENTE: $DOCKER_VERSION ###\n\n"
else
    sudo apt install \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    sudo add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable"

    sudo apt update \
        && sudo apt install docker-ce docker-ce-cli containerd.io -y

    DOCKER_VERSION=$(docker -v)
    echo "\n### INSTALADO: $DOCKER_VERSION ###\n\n"

    ## Agregar usuario actual al grupo de docker
    ## Esto permite trabajar sin sudo
    ## WARNING: Remember to log out and back in for this to take effect!
    mkdir /home/$USER/.docker
    sudo chown $USER:$USER /home/$USER/.docker -R
    sudo chmod g+rwx /home/$USER/.docker -R
    sudo chmod 666 /var/run/docker.sock
fi

# Instalar Docker Compose
if hash docker-compose 2>/dev/null; then
    DOCKER_COMPOSE_VERSION=$(docker-compose --version)
    printf "\n### DOCKER-COMPOSE INSTALADO PREVIAMENTE: $DOCKER_COMPOSE_VERSION ###\n\n"
else
    sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    DOCKER_COMPOSE_VERSION=$(docker-compose --version)
    printf "\n### INSTALADO: $DOCKER_COMPOSE_VERSION ###\n\n"
fi

# Instalar Golang
## (Revisar la versión de Golang)
if hash go 2>/dev/null; then
    GO_VERSION=$(go version)
    printf "\n### GOLANG INSTALADO PREVIAMENTE: $GO_VERSION ###\n\n"
else
    if [ ! -d /home/$I_AM/go ]; then
        mkdir /home/$I_AM/go
    fi

    sudo snap install go --classic
    GO_VERSION=$(go version)
    printf "\n### INSTALADO: $GO_VERSION ###\n\n"
fi

# Instalar Node
if hash node 2>/dev/null; then
    NVM_VERSION=$(nvm --version)
    NPM_VERSION=$(npm --version)
    printf "\n### NVM INSTALADO PREVIAMENTE: $NVM_VERSION | $NPM_VERSION ###\n\n"
else
    curl -sL https://deb.nodesource.com/setup_14.x | sudo bash -
    sudo apt install nodejs -y
    NVM_VERSION=$(node --version)
    NPM_VERSION=$(npm --version)
    printf "\n### INSTALADO: $NVM_VERSION | $NPM_VERSION ###\n\n"
fi

# Instalar Hyperledger Fabric
FABRICSamplesDir="$HOME/hyperledger/fabric"

if [ ! -d $FABRICSamplesDir ]; then
    sudo mkdir -p $FABRICSamplesDir
    sudo chmod -R 777 $FABRICSamplesDir
    cd $FABRICSamplesDir
    sudo curl -sSL http://bit.ly/2ysbOFE | bash -s 2.2.0
    echo 'export PATH=$PATH:$HOME/hyperledger/fabric/fabric-samples/bin' >> ~/.profile
    source ~/.profile
else
    printf "\n### $FABRICSamplesDir YA EXISTE ###\n\n"
fi