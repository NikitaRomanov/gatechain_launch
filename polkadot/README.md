## Run Polkadot full node in Westend network
Run full node 
```bash
docker-compose up -d
```
Check logs in realtime
```bash
docker-compose logs --follow
```
Stop node
```bash
docker-compose down 
```
you can add `-v` to terminate Docker volumes. **Important:** this terminates all Polkadot keys also!
