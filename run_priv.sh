#!/bin/bash

echo ${GATEPASS} | tee ${GATEHOME}/acc_pass.txt

gated init --chain-id=testing-1 private
gatecli account create validator < ${GATEHOME}/acc_pass.txt &> ${GATEHOME}/val_log.txt

ls ${GATEHOME}

cat ${GATEHOME}/val_log.txt


#validator_address=$(jq '.address' ${GATEHOME}/val_log.json)
validator_address=$(grep 'address: ' ${GATEHOME}/val_log.txt)
echo ${validator_address:11}

gated add-genesis-account ${validator_address:11} 1000000000000000000000000000NANOGT

gated add-consensus-account ${validator_address:11}

gatecli account create < ${GATEHOME}/acc_pass.txt &> ${GATEHOME}/dex_own.txt

owner_addr=$(grep 'address: ' ${GATEHOME}/dex_own.txt)

gated add-genesis-dex-owner ${owner_addr:11}

gated start

