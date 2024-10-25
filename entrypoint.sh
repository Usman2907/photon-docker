FROM openjdk:8-jre

# Install required packages
RUN apt-get update \
    && apt-get -y install \
        pbzip2 \
        wget \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /photon

# Instead of using ADD with an HTTP URL, we'll download the file during build
RUN wget -O photon.jar https://github.com/komoot/photon/releases/download/0.3.5/photon-0.3.5.jar

COPY entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh

VOLUME /photon/photon_data
EXPOSE 2322

ENTRYPOINT ["/photon/entrypoint.sh"]