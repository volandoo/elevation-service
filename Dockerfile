FROM node:14

RUN apt-get update
RUN apt-get install -y awscli

COPY . /app
WORKDIR /app
RUN yarn install

RUN mkdir /app/data
RUN aws s3 cp --no-sign-request --recursive s3://elevation-tiles-prod-eu/skadi /app/data

ENV TILE_SET_CACHE 128
ENV TILE_SET_PATH /app/data
ENV MAX_POST_SIZE 700kb

EXPOSE 3000

HEALTHCHECK CMD curl --fail http://localhost:3000/status || exit 1

CMD ["yarn", "run", "start"]
