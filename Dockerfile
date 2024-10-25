# Use OpenJDK 8 as the base image
FROM openjdk:8-jre

# Build arguments
ARG PHOTON_VERSION=0.3.5
ARG PHOTON_JAR_URL=https://github.com/komoot/photon/releases/download/${PHOTON_VERSION}/photon-${PHOTON_VERSION}.jar

# Install required packages
RUN apt-get update \
    && apt-get -y install \
        pbzip2 \
        wget \
        curl \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /photon

# Download the Photon jar from GitHub releases with retry mechanism
RUN for i in 1 2 3; do \
        wget --no-verbose ${PHOTON_JAR_URL} -O /photon/photon.jar && break \
        || { \
            if [ $i -eq 3 ]; then \
                echo "Failed to download after 3 attempts" && exit 1; \
            fi; \
            echo "Download failed, retrying in 10 seconds..."; \
            sleep 10; \
        }; \
    done

# Copy the entrypoint script
COPY entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh

# Set up a volume for Photon data
VOLUME /photon/photon_data

# Expose the default Photon port
EXPOSE 2322

# Set environment variable for Elasticsearch host (can be overridden in Kubernetes)
ENV ELASTICSEARCH_HOST=http://elasticsearch-master.default.svc.cluster.local:9200

# Start Photon with the configured Elasticsearch URL
ENTRYPOINT ["/photon/entrypoint.sh"]
