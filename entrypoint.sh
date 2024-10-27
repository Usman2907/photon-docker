#!/bin/bash

# Create data directory if it does not exist
mkdir -p /photon/photon_data

# Download UK map only if it hasn't been downloaded already
if [ ! -f "/photon/photon_data/united-kingdom-latest.osm.pbf" ]; then
    echo "Downloading UK map..."

    # Download UK map
    wget -O /photon/photon_data/united-kingdom-latest.osm.pbf https://download.geofabrik.de/europe/united-kingdom-latest.osm.pbf

    # Confirm if the file has been downloaded
    if [ ! -f "/photon/photon_data/united-kingdom-latest.osm.pbf" ]; then
        echo "Failed to download the UK map file. Check network or URL."
        exit 1
    fi
fi

# List contents of the directory to verify download
echo "Listing /photon/photon_data contents:"
ls -lah /photon/photon_data

# Start Photon with the UK map file if it exists
if [ -f "/photon/photon_data/united-kingdom-latest.osm.pbf" ]; then
    echo "Starting Photon with UK map data..."
    java -jar photon.jar -data-dir /data/photon_data -nominatim-import /photon/photon_data/united-kingdom-latest.osm.pbf
else
    echo "Could not start Photon, the UK map file was not found."
    exit 1
fi
