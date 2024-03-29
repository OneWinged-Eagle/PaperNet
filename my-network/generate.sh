#!/bin/sh
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#
export PATH=$GOPATH/src/github.com/hyperledger/fabric/build/bin:${PWD}/../bin:${PWD}:$PATH
export FABRIC_CFG_PATH=${PWD}
CHANNEL_NAME=mychannel

# remove previous crypto material and config transactions
rm -fr config/*
rm -fr crypto-config/*

# generate crypto material
cryptogen generate --config=./crypto-config.yaml
if [ "$?" -ne 0 ]; then
  echo "Failed to generate crypto material..."
  exit 1
fi

# generate genesis block for orderer
configtxgen -profile OrdererGenesis -outputBlock ./config/genesis.block
if [ "$?" -ne 0 ]; then
  echo "Failed to generate orderer genesis block..."
  exit 1
fi

# generate channel configuration transaction
configtxgen -profile MyChannel -outputCreateChannelTx ./config/channel.tx -channelID $CHANNEL_NAME
if [ "$?" -ne 0 ]; then
  echo "Failed to generate channel configuration transaction..."
  exit 1
fi

# generate anchor peer transaction
configtxgen -profile MyChannel -outputAnchorPeersUpdate ./config/MagnetoCorpMSPanchors.tx -channelID $CHANNEL_NAME -asOrg MagnetoCorpMSP
if [ "$?" -ne 0 ]; then
  echo "Failed to generate anchor peer update for MagnetoCorpMSP..."
  exit 1
fi

configtxgen -profile MyChannel -outputAnchorPeersUpdate ./config/DigiBankMSPanchors.tx -channelID $CHANNEL_NAME -asOrg DigiBankMSP
if [ "$?" -ne 0 ]; then
  echo "Failed to generate anchor peer update for DigiBankMSP..."
  exit 1
fi
