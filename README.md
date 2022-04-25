## Run GateChain full node

A very basic demo how to launch Gatechain node in Docker. Just type `GATEPASS=12345678 CHAIN='mainnet' docker-compose up --build -d`
to run a node with created accounts (of course you can change the pass in the command above). 
After the start and `docker-compose ps` you will be able to see the following:
```bash
Name                     Command             State   Ports
-------------------------------------------------------------------
gc_gatechain_evm_rpc_1   /bin/bash ./run_evm_rpc.sh   Up           
gc_gatechain_node_1      /bin/bash ./run_node.sh      Up
```
Use `docker exec -it gc_gatechain_evm_rpc_1 bash` to work with `gatecli`. 
EVM RPC is already running on port 6060.

To terminate the node with all data make `docker-compose down -v -t1`. It is necessary to remove all unused volumes.

## Run GateChain local chain

To run a local chain with EVM RPC just type `GATEPASS=12345678 CHAIN='other' docker-compose -f docker-compose-local.yaml up --build`

Now you can send requests to the corresponding EVM RPC. The request body is:

`curl -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":[metod],"params":[params],"id":[id]}' URL:6060`

For example:

`curl -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"web3_sha3","params":["0x68656c6c6f20776f726c64"],"id":64}' http://ec2-3-17-154-48.us-east-2.compute.amazona ws.com:6060`

The result will be:

`{"jsonrpc":"2.0","id":64,"result":"0x47173285a8d7341e5e972fc677286384f802f8ef42a5ec5f03bbfa254cb01fad"}`

The list of all available methods is here http://www.gatechain.io/docs/en/developers/json-rpc/
