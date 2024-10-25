# Use OpenJDK as the base image
FROM openjdk:11-jre-slim

# Install necessary tools for downloading Photon
RUN apt-get update && \
    apt-get install -y wget && \
    apt-get clean

# Set the Photon version
ENV PHOTON_VERSION=0.3.5

# Create directories for Photon data
WORKDIR /photon
RUN mkdir -p /data/photon_data

# Download the Photon jar file
RUN wget https://github.com/komoot/photon/releases/download/${PHOTON_VERSION}/photon-${PHOTON_VERSION}.jar -O photon.jar

# Expose the default Photon port
EXPOSE 2322

# Set the startup command to connect to Elasticsearch over HTTP
CMD ["java", "-jar", "photon.jar", "-data-dir", "/data/photon_data", "-listen-port", "2322", "-elasticsearch", "http://elasticsearch-master.default.svc.cluster.local:9200"]
