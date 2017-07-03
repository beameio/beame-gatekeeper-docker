# https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices
FROM debian:stretch

RUN groupadd beame-gatekeeper && useradd -g beame-gatekeeper beame-gatekeeper -s /bin/bash

# git - for npm install
# python, build-essential - for node gyp
RUN apt-get -y update && apt-get -y upgrade && apt-get -y install curl git python build-essential sudo && rm -rf /var/lib/apt/lists/*

COPY nodejs.sh /nodejs.sh
RUN /nodejs.sh && rm /nodejs.sh && npm config set prefix /usr/local

RUN USER=root npm -g install beame-gatekeeper

# USER beame-gatekeeper
VOLUME /home/beame-gatekeeper
WORKDIR /home/beame-gatekeeper

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
CMD ["beame-gatekeeper"]

# TODO
# + Make sure that releasing new npm version of beame-gatekeeper will rebuild the image
# + readme
