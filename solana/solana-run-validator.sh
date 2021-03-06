#!/usr/bin/env bash
#
# Run a Solana node.  Ctrl-C to exit.
#
set -e

# Prefer possible `cargo build` binaries over PATH binaries
script_dir="$(readlink -f "$(dirname "$0")")"
if [[ "$script_dir" =~ /scripts$ ]]; then
  cd "$script_dir/.."
else
  cd "$script_dir"
fi

profile=debug
if [[ -n $NDEBUG ]]; then
  profile=release
fi
PATH=$PWD/target/$profile:$PATH

ok=true
for program in solana-{faucet,genesis,keygen,validator}; do
  $program -V || ok=false
done
$ok || {
  echo
  echo "Unable to locate required programs.  Try building them first with:"
  echo
  echo "  $ cargo build --all"
  echo
  exit 1
}

export RUST_LOG=${RUST_LOG:-solana=info,solana_runtime::message_processor=debug} # if RUST_LOG is unset, default to info
export RUST_BACKTRACE=1
dataDir=$PWD/config/"$(basename "$0" .sh)"
ledgerDir=$PWD/config/ledger

SOLANA_RUN_SH_CLUSTER_TYPE=${SOLANA_RUN_SH_CLUSTER_TYPE:-development}

set -x
if ! solana address; then
  echo "Generating default keypair"
  solana-keygen new --no-passphrase
fi
validator_identity="$dataDir/validator-identity.json"
if [[ -e $validator_identity ]]; then
  echo "Use existing validator keypair"
else
  solana-keygen new --no-passphrase -so "$validator_identity"
fi
solana config set --keypair $validator_identity
validator_vote_account="$dataDir/validator-vote-account.json"
if [[ -e $validator_vote_account ]]; then
  echo "Use existing validator vote account keypair"
else
  solana-keygen new --no-passphrase -so "$validator_vote_account"
fi
validator_stake_account="$dataDir/validator-stake-account.json"
if [[ -e $validator_stake_account ]]; then
  echo "Use existing validator stake account keypair"
else
  solana-keygen new --no-passphrase -so "$validator_stake_account"
fi

SOLANA_CLUSTER=${SOLANA_CLUSTER:-mainnet}

if [[ "$SOLANA_CLUSTER" == "mainnet" ]]; then
  echo "Attempt establish a connection to mainnet"
  # mainnet
  args=(
    --identity "$validator_identity"
    --vote-account "$validator_vote_account"
    --ledger "$ledgerDir"
    --limit-ledger-size
    --known-validator 7Np41oeYqPefeNQEHSv1UDhYrehxin3NStELsSKCT4K2
    --known-validator GdnSyH3YtwcxFvQrVVJMm1JhTS4QVX7MFsX56uJLUfiZ
    --known-validator DE1bawNcRJB9rVm3buyMVfr8mBEoyyu73NBovf2oXJsJ
    --known-validator CakcnaRDHka2gXyfbEd2d3xsvkJkqsLw2akB3zsN1D2S
    --only-known-rpc
    --full-rpc-api
    --rpc-port 8899
    --private-rpc
    --dynamic-port-range 8000-8013
    --log -
    --enable-rpc-transaction-history
    --init-complete-file "$dataDir"/init-completed
    --entrypoint entrypoint.mainnet-beta.solana.com:8001
    --entrypoint entrypoint2.mainnet-beta.solana.com:8001
    --entrypoint entrypoint3.mainnet-beta.solana.com:8001
    --entrypoint entrypoint4.mainnet-beta.solana.com:8001
    --entrypoint entrypoint5.mainnet-beta.solana.com:8001
    --expected-genesis-hash 5eykt4UsFv8P8NJdTREpY1vzqKqZKvdpKuc147dw2N9d
    --wal-recovery-mode skip_any_corrupted_record
  )
elif [[ "$SOLANA_CLUSTER" == "testnet" ]]; then
  echo "Attempt establish a connection to testnet"
    # testnet
    args=(
      --identity "$validator_identity"
      --vote-account "$validator_vote_account"
      --ledger "$ledgerDir"
      --limit-ledger-size
      --known-validator 5D1fNXzvv5NjV1ysLjirC4WY92RNsVH18vjmcszZd8on
      --known-validator dDzy5SR3AXdYWVqbDEkVFdvSPCtS9ihF5kJkHCtXoFs
      --known-validator Ft5fbkqNa76vnsjYNwjDZUXoTWpP7VYm3mtsaQckQADN
      --known-validator eoKpUABi59aT4rR9HGS3LcMecfut9x7zJyodWWP43YQ
      --known-validator 9QxCLckBiJc783jnMvXZubK4wH86Eqqvashtrwvcsgkv
      --only-known-rpc
      --full-rpc-api
      --rpc-port 8899
      --dynamic-port-range 8000-8013
      --log -
      --enable-rpc-transaction-history
      --init-complete-file "$dataDir"/init-completed
      --entrypoint entrypoint.testnet.solana.com:8001
      --entrypoint entrypoint2.testnet.solana.com:8001
      --entrypoint entrypoint3.testnet.solana.com:8001
      --expected-genesis-hash 4uhcVJyU9pJkvQyS88uRDiswHXSCkY3zQawwpjk2NsNY
      --wal-recovery-mode skip_any_corrupted_record
    )
    solana config set --url https://api.testnet.solana.com
    solana airdrop 1
    sleep 0.5
    solana airdrop 1
    sleep 0.5
    solana airdrop 1
elif [[ "$SOLANA_CLUSTER" == "devnet" ]]; then
  echo "Attempt establish a connection to devnet"
  # devnet
  args=(
    --identity "$validator_identity"
    --vote-account "$validator_vote_account"
    --ledger "$ledgerDir"
    --limit-ledger-size
    --known-validator dv1ZAGvdsz5hHLwWXsVnM94hWf1pjbKVau1QVkaMJ92
    --known-validator dv2eQHeP4RFrJZ6UeiZWoc3XTtmtZCUKxxCApCDcRNV
    --known-validator dv4ACNkpYPcE3aKmYDqZm9G5EB3J4MRoeE7WNDRBVJB
    --known-validator dv3qDFk1DTF36Z62bNvrCXe9sKATA6xvVy6A798xxAS
    --only-known-rpc
    --full-rpc-api
    --rpc-port 8899
    --dynamic-port-range 8000-8013
    --log -
    --enable-rpc-transaction-history
    --init-complete-file "$dataDir"/init-completed
    --entrypoint entrypoint.devnet.solana.com:8001
    --entrypoint entrypoint2.devnet.solana.com:8001
    --entrypoint entrypoint3.devnet.solana.com:8001
    --entrypoint entrypoint4.devnet.solana.com:8001
    --entrypoint entrypoint5.devnet.solana.com:8001
    --expected-genesis-hash EtWTRABZaYq6iMfeYKouRu166VU2xqa1wcaWoxPkrZBG
    --wal-recovery-mode skip_any_corrupted_record
  )
  solana config set --url http://api.devnet.solana.com
  solana airdrop 1
  sleep 0.5
  solana airdrop 1
  sleep 0.5
  solana airdrop 1
else
   echo "?????????!"
   echo "What is $SOLANA_CLUSTER?"
   exit -1
fi

abort() {
  set +e
  kill "$validator"
  wait "$validator"
}
trap abort INT TERM EXIT

# shellcheck disable=SC2086
solana-validator "${args[@]}" $SOLANA_RUN_SH_VALIDATOR_ARGS &
validator=$!

wait "$validator"
