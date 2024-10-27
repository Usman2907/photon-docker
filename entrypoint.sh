# #!/bin/bash


# # Download elasticsearch index
# if [ ! -d "/photon/photon_data/elasticsearch" ]; then
#     echo "Downloading search index"

#     # Let graphhopper know where the traffic is coming from
#     USER_AGENT="docker: thomasnordquist/photon-geocoder"
#     wget --user-agent="$USER_AGENT" -O - http://download1.graphhopper.com/public/photon-db-latest.tar.bz2 | bzip2 -cd | tar x
# fi

# # Start photon if elastic index exists
# if [ -d "/photon/photon_data/elasticsearch" ]; then
#     echo "Start photon"
#     java -jar photon.jar $@
# else
#     echo "Could not start photon, the search index could not be found"
# fi

#!/bin/bash

# Directory where PVC is mounted
DATA_DIR="/data/photon_data"

# Function to download data directly to PVC
download_data() {
    cd "${DATA_DIR}"
    
    # Check if data is already downloaded
    if [ ! -f "${DATA_DIR}/downloaded.flag" ]; then
        echo "Starting data download directly to PVC..."
        
        # Download data directly to PVC
        wget -P "${DATA_DIR}" http://download1.geofabrik.de/europe/germany-latest.osm.pbf
        
        # Add your specific data download commands here
        # Make sure all wget/curl commands specify the PVC directory
        
        # Create flag file to indicate successful download
        touch "${DATA_DIR}/downloaded.flag"
    else
        echo "Data already exists in PVC, skipping download"
    fi
}

# Ensure we're writing to PVC
download_data

# Start Photon with PVC data directory
exec java -jar /photon/photon.jar -data-dir "${DATA_DIR}" -listen-port 2322 -elasticsearch http://elasticsearch-master.default.svc.cluster.local:9200