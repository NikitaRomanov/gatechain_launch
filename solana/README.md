## Run Solana full node 
Before the start you should set up sysctl.
Run solana node:
```bash
docker compose up -d 
```

Check whether node is running:
```bash
curl http://localhost:8899 -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","id":1, "method":"getBlockHeight"}'
```
