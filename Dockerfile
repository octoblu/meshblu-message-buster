FROM node:0.10
MAINTAINER Octoblu <docker@octoblu.com>

RUN apt-get update && \
    apt-get install -y awscli && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY package.json  /usr/src/app/
RUN npm install
COPY . /usr/src/app

CMD ["npm", "start"]
