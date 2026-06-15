#!/bin/bash
echo "========================================"
echo "            WRF Docker Setup"
echo "========================================"
#################################################
GITHUB_REPO="itu-metsen/wrf_docker"
DEFAULT_PATH="$HOME/Documents/wrf_docker"
CONTAINER_NAME="wrf"
#################################################
if docker ps -a --format '{{.Names}}' | grep -Eq "^${CONTAINER_NAME}\$"; then
    if docker ps --format '{{.Names}}' | grep -Eq "^${CONTAINER_NAME}\$"; then
        echo "Container "$CONTAINER_NAME" is already running."
        echo "Opening shell."
        exec < /dev/tty
        docker exec -it $CONTAINER_NAME bash
        exit 0
    else
        echo "Container "$CONTAINER_NAME" exists but is stopped."
        echo "Starting it up and opening shell."
        docker start $CONTAINER_NAME
        exec < /dev/tty
        docker exec -it $CONTAINER_NAME bash
        exit 0
    fi
fi
#################################################
echo ""
echo "Where would you like to create the WRF container pipe on this machine?"
read -p "Enter a path (Press Enter for default: ${DEFAULT_PATH}): " USER_PATH < /dev/tty

if [ -z "$USER_PATH" ]; then
    DATA_PATH="$DEFAULT_PATH"
else
    if [[ "$USER_PATH" = /* ]]; then
        DATA_PATH="$USER_PATH"
    elif [[ "$USER_PATH" = ~* ]]; then
        DATA_PATH="${USER_PATH/#\~/$HOME}"
    else
        DATA_PATH="$(pwd)/$USER_PATH"
    fi
fi

echo ""
echo "Setting up pipe directory at: $DATA_PATH"
mkdir -p "$DATA_PATH"
#################################################
echo ""
echo "If you want to save your CDS Api Key please enter. You can enter it manually to ~/.cdsapirc after the installation."
read -p "Enter your CDS Api Key:" API_KEY < /dev/tty
export CDS_API_KEY="$API_KEY"
#################################################
CSHELL=$(basename $SHELL)
ALIAS="alias wrfdckr='bash -c \"\$(curl -sSL https://raw.githubusercontent.com/itu-metsen/wrf_docker/main/scripts/wrf_docker.sh)\"'"

if [[ "$CSHELL" == "zsh" ]]; then
    echo "$ALIAS" >> $HOME/.zshrc
elif [[ "$CSHELL" == "bash" ]]; then
    echo "$ALIAS" >> $HOME/.bashrc
fi
#################################################
export CONTAINER_PIPE_PATH="$DATA_PATH"
export IMAGE_NAME="$GITHUB_REPO"

echo "Downloading Docker Compose..."
curl -sSL -o docker-compose.yml https://raw.githubusercontent.com/$GITHUB_REPO/main/scripts/docker-compose.yml

echo ""
echo "Pulling the latest WRF image from ghcr.io/$GITHUB_REPO..."
docker compose pull

echo "Starting the container..."
docker compose up -d

rm docker-compose.yml

echo ""
echo "=============================================="
echo "Checking WPS_GEOG Data (This may take a while)"
echo "=============================================="
grep -m 1 "Creating /home/wrfuser/.cdsapirc" <(docker logs -f $CONTAINER_NAME)

echo ""
echo "Container is up. Opening shell..."
exec < /dev/tty
docker exec -it -u wrfuser $CONTAINER_NAME bash
