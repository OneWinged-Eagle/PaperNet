#!/bin/bash
#
# Exit on first error, print all commands.
set -ev

# don't rewrite paths for Windows Git Bash users
export MSYS_NO_PATHCONV=1

docker-compose -f docker-compose.yml down

docker-compose -f docker-compose.yml up -d
docker ps -a

# wait for Hyperledger Fabric to start
# incase of errors when running later commands, issue export FABRIC_START_TIMEOUT=<larger number>
export FABRIC_START_TIMEOUT=10
#echo ${FABRIC_START_TIMEOUT}
sleep ${FABRIC_START_TIMEOUT}

# Create the channel
docker exec -e "CORE_PEER_ADDRESS=peer0.magnetocorp.my-network.com:7051" \
-e "CORE_PEER_LOCALMSPID=MagnetoCorpMSP" \
-e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/magnetocorp.my-network.com/users/Admin@magnetocorp.my-network.com/msp" \
-e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/magnetocorp.my-network.com/peers/peer0.magnetocorp.my-network.com/tls/ca.crt" \
cli peer channel create -o orderer.my-network.com:7050 -c mychannel -f ./channel-artifacts/channel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/my-network.com/orderers/orderer.my-network.com/msp/tlscacerts/tlsca.my-network.com-cert.pem
# Join peer0.magnetocorp.my-network.com to the channel.
docker exec -e "CORE_PEER_ADDRESS=peer0.magnetocorp.my-network.com:7051" \
-e "CORE_PEER_LOCALMSPID=MagnetoCorpMSP" \
-e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/magnetocorp.my-network.com/users/Admin@magnetocorp.my-network.com/msp" \
-e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/magnetocorp.my-network.com/peers/peer0.magnetocorp.my-network.com/tls/ca.crt" \
cli peer channel join -b mychannel.block

# Create the channel
docker exec -e "CORE_PEER_ADDRESS=peer0.digibank.my-network.com:7051" \
-e "CORE_PEER_LOCALMSPID=DigiBankMSP" \
-e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/digibank.my-network.com/users/Admin@digibank.my-network.com/msp" \
-e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/digibank.my-network.com/peers/peer0.digibank.my-network.com/tls/ca.crt" \
cli peer channel create -o orderer.my-network.com:7050 -c mychannel -f ./channel-artifacts/channel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/my-network.com/orderers/orderer.my-network.com/msp/tlscacerts/tlsca.my-network.com-cert.pem
# Join peer0.digibank.my-network.com to the channel.
docker exec -e "CORE_PEER_ADDRESS=peer0.digibank.my-network.com:7051" \
-e "CORE_PEER_LOCALMSPID=DigiBankMSP" \
-e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/digibank.my-network.com/users/Admin@digibank.my-network.com/msp" \
-e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/digibank.my-network.com/peers/peer0.digibank.my-network.com/tls/ca.crt" \
cli peer channel join -b mychannel.block
