FROM openjdk:8-jre

# Build arguments
ARG PHOTON_VERSION=0.3.5
ARG PHOTON_JAR_URL=https://github.com/komoot/photon/releases/download/0.3.5/photon-0.3.5.jar

# Install required packages
RUN apt-get update \
    && apt-get -y install \
        pbzip2 \
        wget \
        curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /photon

# Download photon jar from GitHub releases with retry mechanism
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

COPY entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh

VOLUME /photon/photon_data
EXPOSE 2322

ENTRYPOINT ["/photon/entrypoint.sh"]