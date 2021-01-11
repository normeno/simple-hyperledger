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

9. Crear blockchain-network/base/peer-base.yaml

10. Crear blockchain-network/docker-compose-base-yaml

11. Crear blockchain-netowrk/docker-compose-cli-couchdb.yaml

12. Exportamos las variables que necesitamos

```
export CHANNEL_NAME=marketplace
export FABRIC_CFG_PATH=$WPD # debemos estar en blockchain-network
export VERBOSE=false
```

13. Levantamos docker-compose

```
CHANNEL_NAME=$CHANNEL_NAME docker-compose -f docker-compose-cli-couchdb.yaml up -d
```

14. Probamos que esté ok el contenedor

```
docker exec -it cli bash
```

15. Dentro del contenedor CLI, creamos la variable de ambiante con el nombre del canal

```
export CHANNEL_NAME=marketplace
```

16. Creamos el canal

```
peer channel create -o orderer.acme.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/acme.com/orderers/orderer.acme.com/msp/tlscacerts/tlsca.acme.com-cert.pem
```

17. Hacer que la organización sea parte del canal

```
peer channel join -b marketplace.block
```

18. Crear la carpeta chaincode/foodcontrol

19. Crear el archivo chaincode/foodcontrol/foodcontrol.go

20. Crear el archivo chaincode/foodcontrol/go.mod

21. Ingresamos al contanedor cli

```
docker exec -it cli bash
```

22. Dentro del contenedor verificamos que exista la ruta `/opt/gopath/src/github.com/chaincode/`, si no existe, es probable que sólo reiniciando el contenedor, tome la ruta

23. Dentro del contenedor, nos aseguramos de tener las siguientes variables

```
export CHANNEL_NAME=marketplace
export CHAINCODE_NAME=foodcontrol
export CC_RUNTIME_LANGUAGE=golang
export CC_SRC_PATH="../../../chaincode/$CHAINCODE_NAME/"
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/acme.com/orderers/orderer.acme.com/msp/tlscacerts/tlsca.acme.com-cert.pem
```

24. Hacer uso del ciclo de vida de chaincode, para empaquetar el proyecto

```
peer lifecycle chaincode package ${CHAINCODE_NAME}.tar.gz --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} --label ${CHAINCODE_NAME}_${CHAINCODE_VERSION} >& log.txt
```

25. Revisamos que se cree correctamente, esto lo hacemos, `ls -l` para revisar que exista el archivo _foodcontrol.tar.gz_

- Aquí se nos puede generar el archivo go.sum (si es que no lo teníamos con anterioridad)

26. En la misma máquina del CLI, vamos a instalar el chaincode en las organizaciones

```
peer lifecycle chaincode install foodcontrol.tar.gz
```