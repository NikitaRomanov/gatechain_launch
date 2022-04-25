#!/bin/bash

until [ -f ${GATEHOME}/api.token ]
do
	echo "wait for ${GATEHOME}/api.token"
	sleep 1
done
cp ${GATEHOME}/api.token ${GATEHOME}/../.gatecli/
gatecli evm rest-server --gm-websocket-port http://127.0.0.1:8081 --chain-id testing-1 --laddr tcp://0.0.0.0:6060 --rpc-api web3,eth,personal,net,debug

