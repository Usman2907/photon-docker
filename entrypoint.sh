#!/bin/bash

# Set default values for environment variables if they are not provided
ELASTICSEARCH_HOST=${ELASTICSEARCH_HOST:-"elasticsearch-master.default.svc.cluster.local"}
ELASTICSEARCH_PORT=${ELASTICSEARCH_PORT:-9300}
PHOTON_DATA_DIR=${PHOTON_DATA_DIR:-"/photon/photon_data"}

# Function to check if Elasticsearch is up and reachable
check_elasticsearch() {
    echo "Checking if Elasticsearch at ${ELASTICSEARCH_HOST}:${ELASTICSEARCH_PORT} is available..."
    until nc -z -v -w5 ${ELASTICSEARCH_HOST} ${ELASTICSEARCH_PORT}; do
        echo "Elasticsearch is unavailable - sleeping"
        sleep 5
    done
    echo "Elasticsearch is up - continuing with Photon startup"
}

# Download Elasticsearch index if it does not exist
if [ ! -d "${PHOTON_DATA_DIR}/elasticsearch" ]; then
    echo "Downloading search index"
    USER_AGENT="docker: thomasnordquist/photon-geocoder"
    wget --user-agent="$USER_AGENT" -O - http://download1.graphhopper.com/public/photon-db-latest.tar.bz2 | bzip2 -cd | tar x -C "${PHOTON_DATA_DIR}"
fi

# Check Elasticsearch connection if import is enabled
if [ "$PHOTON_IMPORT" == "true" ]; then
    check_elasticsearch
    echo "Starting data import into Photon..."
    java -jar photon.jar -data-dir "$PHOTON_DATA_DIR" -nominatim-import "$NOMINATIM_IMPORT_URL" -transport-addresses "${ELASTICSEARCH_HOST}:${ELASTICSEARCH_PORT}"
else
    echo "Skipping import; starting Photon without importing data."
    java -jar photon.jar -data-dir "$PHOTON_DATA_DIR" -listen-port 2322 -transport-addresses "${ELASTICSEARCH_HOST}:${ELASTICSEARCH_PORT}"
fi
