## Run GateChain full node

A very basic demo how to launch Gatechain node in Docker. Just type `GATEPASS=12345678 docker-compose up --build -d`
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

To terminate the node with all data make `docker-compose down -v -t1`.
