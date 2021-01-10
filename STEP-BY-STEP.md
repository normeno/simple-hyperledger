# Instalar pre-requisitos

1. Permitir ejecutar el archivo

```
chmod +x install-prereq.sh
```

2. Ejecutar script, o correr los comandos que existen dentro del script

```
./install-prereq.sh
```

3. Crear crypto-config.yaml

4. Ejecutar Generar el material critográfico de organizaciones y usuarios

```
cryptogen generate --config=./blockchain-network/crypto-config.yaml
```

5. mkdir channel-artifacts

6. Crear blockchain-network/configtx.yaml

7. Ingresar a blockchain-network

8. Configurar canales 

```
configtxgen -profile ThreeOrgsOrdererGenesis -channelID system-channel  -outputBlock ./channel-artifacts/genesis.block
```

```
configtxgen -profile ThreeOrgsChannel -channelID marketplace -outputCreateChannelTx ./channel-artifacts/channel.tx
```

```
configtxgen -profile ThreeOrgsChannel -channelID marketplace -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -asOrg Org1MSP
```

```
configtxgen -profile ThreeOrgsChannel -channelID marketplace -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -asOrg Org2MSP
```

```
configtxgen -profile ThreeOrgsChannel -channelID marketplace -outputAnchorPeersUpdate ./channel-artifacts/Org3MSPanchors.tx -asOrg Org3MSP
```