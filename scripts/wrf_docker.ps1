Write-Host "========================================"
Write-Host "            WRF Docker Setup"
Write-Host "========================================"

# ---------------------
$GITHUB_REPO = "itu-metsen/wrf_docker"
$DEFAULT_PATH = Join-Path $env:USERPROFILE "Documents\wrf_docker"
$CONTAINER_NAME = "wrf"
# ---------------------


# ---------------------
$containerExists = docker ps -a --format '{{.Names}}' | Select-String -Pattern "^${CONTAINER_NAME}$" -Quiet
if ($containerExists) {
    $isRunning = docker ps --format '{{.Names}}' | Select-String -Pattern "^${CONTAINER_NAME}$" -Quiet
    if ($isRunning) {
        Write-Host "Container '$CONTAINER_NAME' is already running."
        Write-Host "Opening shell."
        docker exec -it $CONTAINER_NAME bash
        exit
    } else {
        Write-Host "Container '$CONTAINER_NAME' exists but is stopped."
        Write-Host "Starting it up and opening shell."
        docker start $CONTAINER_NAME
        docker exec -it $CONTAINER_NAME bash
        exit
    }
}
# ---------------------


# ---------------------
Write-Host ""
$USER_PATH = Read-Host "Where would you like to create the WRF container pipe on this machine? (Press Enter for default: $DEFAULT_PATH)"

if ([string]::IsNullOrWhiteSpace($USER_PATH)) {
    $DATA_PATH = $DEFAULT_PATH
} else {
    if ([System.IO.Path]::IsPathRooted($USER_PATH)) {
        $DATA_PATH = $USER_PATH
    } elseif ($USER_PATH.StartsWith("~")) {
        $DATA_PATH = $USER_PATH.Replace("~", $env:USERPROFILE)
    } else {
        $DATA_PATH = Join-Path (Get-Location).Path $USER_PATH
    }
}

Write-Host "`nSetting up pipe directory at: $DATA_PATH"
New-Item -ItemType Directory -Force -Path $DATA_PATH | Out-Null
# ---------------------


# ---------------------
$env:CONTAINER_PIPE_PATH = $DATA_PATH
$env:IMAGE_NAME = $GITHUB_REPO

Write-Host "Downloading Docker Compose..."
$ComposeUrl = "https://raw.githubusercontent.com/$GITHUB_REPO/master/scripts/docker-compose.yml"
Invoke-WebRequest -Uri $ComposeUrl -OutFile "docker-compose.yml"

Write-Host "`nPulling the latest WRF image from ghcr.io/$GITHUB_REPO..."
docker compose pull

Write-Host "Starting the container..."
docker compose up -d

Remove-Item -Path "docker-compose.yml" -Force

Write-Host "`nContainer is up. Opening shell..."
docker exec -it $CONTAINER_NAME bash
# ---------------------