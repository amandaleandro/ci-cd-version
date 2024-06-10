FROM node:18.18-alpine3.18 as production

ARG version
ENV version=${version}

USER node

RUN mkdir -p /home/node/app

WORKDIR /home/node/app

COPY --from=production --chown=node:node /home/node/app/package*.json ./
COPY --from=production --chown=node:node /home/node/app/package-lock.json ./

RUN npm ci

COPY --from=production --chown=node:node /home/node/app .

EXPOSE 3000

ENV TZ=America/Sao_Paulo

ENV NODE_ENV=prod

CMD ./node_modules/.bin/ts-node ./node_modules/.bin/typeorm migration:run -d src/orm/config/ormconfig.prod.ts && npm run start:prod
