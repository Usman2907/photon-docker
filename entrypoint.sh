#!/bin/bash

# Download and merge specific region maps (UK and Saudi Arabia)
if [ ! -f "/photon/photon_data/merged.osm.pbf" ]; then
    echo "Downloading specific region maps for UK and Saudi Arabia..."

    # Download UK map
    wget -O /photon/photon_data/uk.osm.pbf https://download.geofabrik.de/europe/great-britain-latest.osm.pbf

    # Download Saudi Arabia map
    wget -O /photon/photon_data/saudi-arabia.osm.pbf https://download.geofabrik.de/asia/saudi-arabia-latest.osm.pbf

    # Merge the files
    echo "Merging UK and Saudi Arabia maps into a single file..."
    osmium merge /photon/photon_data/uk.osm.pbf /photon/photon_data/saudi-arabia.osm.pbf -o /photon/photon_data/merged.osm.pbf
fi

# Start Photon with the merged map file
if [ -f "/photon/photon_data/merged.osm.pbf" ]; then
    echo "Starting Photon with UK and Saudi Arabia map data..."
    java -jar photon.jar -data-dir /data/photon_data -nominatim-import /photon/photon_data/merged.osm.pbf
else
    echo "Could not start Photon, the required map files were not found."
    exit 1
fi
