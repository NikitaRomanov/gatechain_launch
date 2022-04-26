#!/bin/bash

until [ -f ${GATEHOME}/api.token ]
do
  echo "wait for ${GATEHOME}/api.token"
  sleep 1
done
cp ${GATEHOME}/api.token ${GATEHOME}/../.gatecli/
echo ${CHAIN}
if [ ${CHAIN} = 'mainnet']; then
	address=$(jq '.address' ${GATEHOME}/acc_log.json)
	gatecli con-account create --indent --output json `echo ${address:1:-1}` --chain-id mainnet &> ${GATEHOME}/con_acc_log.json
	gatecli evm rest-server --gm-websocket-port http://127.0.0.1:8081 \
                        --chain-id mainnet \
                        --laddr tcp://0.0.0.0:6060 \
                        --rpc-api web3,eth,personal,net,debug
else
        gatecli evm rest-server --gm-websocket-port http://127.0.0.1:8081 --chain-id ${CHAIN} --laddr tcp://0.0.0.0:6060 --rpc-api web3,eth,personal,net,debug
fi
