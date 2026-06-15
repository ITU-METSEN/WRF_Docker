#!/bin/bash
set -e

GEOG_DIR="/home/wrfuser/WPS_GEOG"
WRF_DATA_DIR="/home/wrfuser/wrf_data"

if [ "$(id -u)" = '0' ]; then
    chown -R wrfuser:wrfuser "$GEOG_DIR"
    chown -R wrfuser:wrfuser "$WRF_DATA_DIR"
    export HOME=/home/wrfuser
    export USER=wrfuser
    exec setpriv --reuid=wrfuser --regid=wrfuser --init-groups "$0" "$@"
fi

if [ ! -d "$GEOG_DIR" ] || [ -z "$(ls -A $GEOG_DIR 2> /dev/null)" ]; then
    echo "WPS_GEOG data not found. Starting download..."

    cd /home/wrfuser
    wget https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_high_res_mandatory.tar.gz -O geog_high_res_mandatory.tar.gz

    echo "Extracting geographical data..."
    tar -zxvf geog_high_res_mandatory.tar.gz -C /home/wrfuser/
    rm geog_high_res_mandatory.tar.gz

    echo "Download complete and geographical data has been extraced."
else
    echo "WPS_GEOG data already exists in the volume. Skipping downlaod."
fi

echo "Creating /home/wrfuser/.cdsapirc ..."
echo "url: https://cds.climate.copernicus.eu/api" > /home/wrfuser/.cdsapirc
echo "key: ${CDS_API_KEY:-<PERSONAL-ACCESS-TOKEN>}" >> /home/wrfuser/.cdsapirc
chmod 600 /home/wrfuser/.cdsapirc

exec "$@"
