# this includes the build for both api and app

FROM node:alpine as build

# cache dependencies
# express api dependencies
WORKDIR /src/api
COPY api/package.json .
RUN npm install

# vue app dependencies
WORKDIR /src/app
COPY app/package.json .
RUN npm install --legacy-peer-deps


# build express api
WORKDIR /src/api

COPY api .
RUN npm run build

RUN npm prune --production
RUN rm -rf src
RUN rm -rf tsconfig.json


# build vue app
WORKDIR /src/app

COPY app .
RUN npm run build

RUN rm -rf public/index.html
RUN cp -r public ../api/public/.


# production container
FROM node:alpine as prod

ENV NODE_ENV=production
ENV PORT=80
EXPOSE 80

WORKDIR /app

COPY --from=build /src/api .

CMD ["node", "dist/index.js"]
