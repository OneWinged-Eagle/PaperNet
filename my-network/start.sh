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
docker exec -e "CORE_PEER_LOCALMSPID=MagnetoCorpMSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@magnetocorp.my-network.com/msp" peer0.magnetocorp.my-network.com peer channel create -o orderer.my-network.com:7050 -c mychannel -f /etc/hyperledger/configtx/channel.tx
# Join peer0.magnetocorp.my-network.com to the channel.
docker exec -e "CORE_PEER_LOCALMSPID=MagnetoCorpMSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@magnetocorp.my-network.com/msp" peer0.magnetocorp.my-network.com peer channel join -b mychannel.block

# Create the channel
docker exec -e "CORE_PEER_LOCALMSPID=DigiBankMSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@digibank.my-network.com/msp" peer0.digibank.my-network.com peer channel create -o orderer.my-network.com:7050 -c mychannel -f /etc/hyperledger/configtx/channel.tx
# Join peer0.magnetocorp.my-network.com to the channel.
docker exec -e "CORE_PEER_LOCALMSPID=DigiBankMSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@digibank.my-network.com/msp" peer0.digibank.my-network.com peer channel join -b mychannel.block
