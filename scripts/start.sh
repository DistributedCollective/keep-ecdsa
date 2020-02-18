#!/bin/bash
set -e

# Dafault inputs.
KEEP_ETHEREUM_PASSWORD_DEFAULT=password
LOG_LEVEL_DEFAULT="info"
CONFIG_FILE_PATH_DEFAULT="./configs/config.toml"

# Read user inputs.
read -p "Enter ethereum accounts password [$KEEP_ETHEREUM_PASSWORD_DEFAULT]: " ethereum_password
KEEP_ETHEREUM_PASSWORD=${ethereum_password:-$KEEP_ETHEREUM_PASSWORD_DEFAULT}

read -p "Enter log level [$LOG_LEVEL_DEFAULT]: " log_level
LOG_LEVEL=${log_level:-$LOG_LEVEL_DEFAULT}

read -p "Enter path to keep-ecdsa client config [$CONFIG_FILE_PATH_DEFAULT]: " config_file_path
CONFIG_FILE_PATH=${config_file_path:-$CONFIG_FILE_PATH_DEFAULT}

# Run script.
LOG_START='\n\e[1;36m' # new line + bold + color
LOG_END='\n\e[0m' # new line + reset color

KEEP_ECDSA_PATH=$(realpath $(dirname $0)/../)
KEEP_ECDSA_CONFIG_FILE_PATH=$(realpath $KEEP_ECDSA_PATH/$CONFIG_FILE_PATH)

printf "${LOG_START}Starting keep-ecdsa client...${LOG_END}"
cd $KEEP_ECDSA_PATH
KEEP_ETHEREUM_PASSWORD=$KEEP_ETHEREUM_PASSWORD \
    LOG_LEVEL=${LOG_LEVEL} \
    ./keep-ecdsa --config $KEEP_ECDSA_CONFIG_FILE_PATH start
