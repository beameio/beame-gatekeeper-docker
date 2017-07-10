# https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices
FROM node6:latest

RUN groupadd beame-gatekeeper && useradd -g beame-gatekeeper beame-gatekeeper -s /bin/sh

# git - for npm install
# python, build-essential - for node gyp
# jq - for help.sh to print the version
RUN apt-get -y update && apt-get -y upgrade && apt-get -y install git python build-essential jq && rm -rf /var/lib/apt/lists/*

RUN USER=root npm -g install --unsafe-perm beame-gatekeeper

# USER beame-gatekeeper
VOLUME /home/beame-gatekeeper
WORKDIR /home/beame-gatekeeper

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY help.sh /usr/local/bin/help.sh
ENTRYPOINT ["entrypoint.sh"]
CMD ["/usr/local/bin/help.sh"]

# TODO
# + Make sure that releasing new npm version of beame-gatekeeper will rebuild the image
# + readme
