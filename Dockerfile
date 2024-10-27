# Use OpenJDK as the base image
FROM openjdk:11-jre-slim

# Install necessary tools
RUN apt-get update && apt-get install -y wget osmium-tool && apt-get clean

# Set the Photon version
ENV PHOTON_VERSION=0.3.5

# Create directories for Photon data
WORKDIR /photon
RUN mkdir -p /data/photon_data

# Download the Photon jar file
RUN wget https://github.com/komoot/photon/releases/download/${PHOTON_VERSION}/photon-${PHOTON_VERSION}.jar -O photon.jar

# Copy entrypoint.sh and make it executable
COPY entrypoint.sh /photon/entrypoint.sh
RUN chmod +x /photon/entrypoint.sh

# Expose the default Photon port
EXPOSE 2322

# Set the entrypoint
ENTRYPOINT ["/photon/entrypoint.sh"]
