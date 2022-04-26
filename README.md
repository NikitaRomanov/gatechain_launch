## Run GateChain full node in mainnet

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

To terminate the node with all data make `docker-compose down -v -t1`. It is necessary to remove all used volumes.

## Run GateChain local chain

This is very similar to run on the mainnet.
To run a local chain with EVM RPC just type `GATEPASS=12345678 CHAIN='testing-1' docker-compose -f docker-compose-local.yaml up --build`

You can assign another name to local chain varying parameter `CHAIN`. Keep in mind that other name must satisfy pattern 
`[a-z][A-Z]-[0-9]`. For example: `testing-2`, `testchain-9`, etc.

Now you can send requests to the corresponding EVM RPC. For example:

`curl -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"web3_sha3","params":["0x68656c6c6f20776f726c64"],"id":64}' http:127.0.0.1:6060`

The result will be:

`{"jsonrpc":"2.0","id":64,"result":"0x47173285a8d7341e5e972fc677286384f802f8ef42a5ec5f03bbfa254cb01fad"}`

The list of all available methods is here http://www.gatechain.io/docs/en/developers/json-rpc/

To terminate the node with all data also make `docker-compose down -v -t1`.

## Staking 
To participate in a consensus you should follow the next steps 
https://www.gatechain.io/docs/en/developers/gatechain-pos/#build-a-gatechain-full-node-and-work-as-a-consensus-account.
Most of them have already been completed, but you need to place some stake on the account and 
run this command to upgrade usual account to consensus account
https://www.gatechain.io/docs/en/developers/cli/con-account/#Get-Consensus-Account-Online.
You can find all necessary addresses, tokens and passwords in a directory stored in an environment 
variable `GATEHOME` (`/root/.gated` by default) in files 
`acc_pass.txt`, `acc_log.json`, `con_acc_log.json`, `api.token` (for a local chain additional files are presented).