#!/bin/bash

# Download UK map only if it hasn't been downloaded already
if [ ! -f "/photon/photon_data/uk.osm.pbf" ]; then
    echo "Downloading UK map..."

    # Download UK map
    wget -O /photon/photon_data/uk.osm.pbf https://download.geofabrik.de/europe/great-britain-latest.osm.pbf
fi

# Start Photon with the UK map file
if [ -f "/photon/photon_data/uk.osm.pbf" ]; then
    echo "Starting Photon with UK map data..."
    java -jar photon.jar -data-dir /data/photon_data -nominatim-import /photon/photon_data/uk.osm.pbf
else
    echo "Could not start Photon, the UK map file was not found."
    exit 1
fi
