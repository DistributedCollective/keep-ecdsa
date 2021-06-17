#!/bin/bash
set -e pipefail

# Dafault config files directory.
CONFIG_DIR_PATH_DEFAULT=$(realpath -m $(dirname $0)/../configs)

if [[ -z "${DEST_NETWORK}" ]]; then
  echo "DEST_NETWORK env not set. Exiting"
  exit 1
else
  echo "Using network ${DEST_NETWORK}"
fi

if [[ -z "${INITIALIZE_OPERATORS}" ]]; then
  echo "INITIALIZE_OPERATORS env not set. Exiting"
  exit 1
fi

# Read user config file path.
read -p "Enter path to keep-ecdsa config files directory [$CONFIG_DIR_PATH_DEFAULT]: " config_dir_path
CONFIG_DIR_PATH=${config_dir_path:-$CONFIG_DIR_PATH_DEFAULT}

KEEP_ECDSA_PATH=$(realpath $(dirname $0)/../)
KEEP_ECDSA_CONFIG_DIR_PATH=$(realpath $CONFIG_DIR_PATH)
KEEP_ECDSA_SOL_PATH=$(realpath $KEEP_ECDSA_PATH/solidity)

cd $KEEP_ECDSA_SOL_PATH

# Dafault app address.
output=$(npx truffle exec scripts/get-default-application-account.js --network $DEST_NETWORK)
CLIENT_APP_ADDRESS_DEFAULT=$(echo "$output" | tail -1)

# Read user app address.
read -p "Enter client application address [$CLIENT_APP_ADDRESS_DEFAULT]: " client_app_address
CLIENT_APP_ADDRESS=${client_app_address:-$CLIENT_APP_ADDRESS_DEFAULT}

# Run script.
LOG_START='\n\e[1;36m'  # new line + bold + cyan
LOG_END='\n\e[0m'       # new line + reset
DONE_START='\n\e[1;32m' # new line + bold + green
DONE_END='\n\n\e[0m'    # new line + reset

printf "${LOG_START}Starting initialization...${LOG_END}"

printf "${LOG_START}Configuring external client contract address...${LOG_END}"
CLIENT_APP_ADDRESS=$CLIENT_APP_ADDRESS \
    ./scripts/lcl-set-client-address.sh

printf "${LOG_START}Initializing contracts...${LOG_END}"

if [[ $INITIALIZE_OPERATORS != 0 ]]; then
  npx truffle exec scripts/lcl-initialize.js --network $DEST_NETWORK
fi

printf "${LOG_START}Updating keep-ecdsa config files...${LOG_END}"
for CONFIG_FILE in $KEEP_ECDSA_CONFIG_DIR_PATH/*.toml
do
  KEEP_ECDSA_CONFIG_FILE_PATH=$CONFIG_FILE \
    CLIENT_APP_ADDRESS=$CLIENT_APP_ADDRESS \
    npx truffle exec scripts/lcl-client-config.js --network $DEST_NETWORK
done

printf "${DONE_START}Initialization completed!${DONE_END}"
