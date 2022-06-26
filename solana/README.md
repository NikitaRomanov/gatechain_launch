## Run a Solana full node 
### Prepare your machine 
Before the start you should configure system limits. According to the Solana documentation 
you need to set up these values:
```
# Increase UDP buffer size
net.core.rmem_default = 134217728
net.core.rmem_max = 134217728
net.core.wmem_default = 134217728
net.core.wmem_max = 134217728
```
and
```
# Increase memory mapped files limit
vm.max_map_count = 1000000
```
It is possible to configure via commands like `sysctl -w net.core.rmem_default = 134217728`
or create some system files how it describes
https://docs.solana.com/running-validator/validator-start.

### Run a node
Run a Solana node:
```bash
docker compose up -d 
```

Check whether node is running:
```bash
curl http://localhost:8899 -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","id":1, "method":"getBlockHeight"}'
```
Also, you can execute `solana gossip` and find your IP in the list. 
