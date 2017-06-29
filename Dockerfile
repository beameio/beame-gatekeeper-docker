FROM debian:stretch

# git - for npm install
# python, build-essential - for node gyp
RUN apt-get -y update && apt-get -y upgrade && apt-get -y install curl git python build-essential

COPY nodejs.sh /nodejs.sh
RUN /nodejs.sh && rm /nodejs.sh && npm config set prefix /usr/local

RUN USER=root npm -g install beame-gatekeeper

WORKDIR /src
CMD ["/bin/bash"]

# TODO
# + Make sure that releasing new npm version of beame-gatekeeper will rebuild the image
# + User
# + Volume
# + Command
