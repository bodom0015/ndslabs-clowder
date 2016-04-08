# FROM clowder/python-base
# FROM maven:3-onbuild
FROM java:8-jre-alpine
MAINTAINER Marcus Slavenas <slavenas@illinois.edu>

# Copy built JAR(s) into image
COPY target/speech2text-1.0-SNAPSHOT-jar-with-dependencies.jar config.properties /workspace/

WORKDIR /workspace

# command to run when starting docker
CMD [ "java", "-jar", "speech2text-1.0-SNAPSHOT-jar-with-dependencies.jar" ]

# Setup environment variables. These are passed into the container. You can change
# these to your setup. If RABBITMQ_URI is not set, it will try and use the rabbitmq
# server that is linked into the container.
ENV RABBITMQ_URI="" \
    RABBITMQ_EXCHANGE="clowder" \
    RABBITMQ_VHOST="%2F" \
    RABBITMQ_QUEUE="speech2text"
