FROM openjdk:11-jre-slim

# Install necessary tools
RUN apt-get update && \
    apt-get install -y wget && \
    apt-get clean

# Set the Photon version
ENV PHOTON_VERSION=0.3.5

# Download the Photon jar file only
WORKDIR /photon
RUN wget https://github.com/komoot/photon/releases/download/${PHOTON_VERSION}/photon-${PHOTON_VERSION}.jar -O photon.jar

# Add initialization script
COPY entrypoint.sh /photon/entrypoint.sh
RUN chmod +x /photon/entrypoint.sh

EXPOSE 2322

CMD ["/photon/entrypoint.sh"]