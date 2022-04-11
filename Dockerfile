ARG VERSION=1.1.2
FROM ubuntu:20.04

WORKDIR /root
ENV GATEHOME=/root/.gated
ARG VERSION
RUN apt-get update && \
    apt-get install -y git git-lfs jq && \
    git lfs clone https://github.com/gatechain/node-binary.git && \
    cp node-binary/node/mainnet/${VERSION}/linux/gatecli /usr/local/bin && \
    cp node-binary/node/mainnet/${VERSION}/linux/gated /usr/local/bin && \
    mkdir ${GATEHOME} && \
    cp node-binary/node/mainnet/${VERSION}/config/config.json ${GATEHOME} && \
    cp node-binary/node/mainnet/${VERSION}/config/genesis.json ${GATEHOME} &&  \
    echo "$(jq '."IsWebSocketServerActive" = true | ."WsPort" = "tcp://0.0.0.0:8081"' ${GATEHOME}/config.json)" > ${GATEHOME}/config.json && \
    rm -rf /var/lib/apt/lists/* node-binary
EXPOSE 8081 9100 6060 8080
COPY run_*.sh ./
CMD ['gated', 'start']
