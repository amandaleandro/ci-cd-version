FROM node:18.18-alpine3.18 as production

arg version

env version=${version}

user node

run mkdir -p /home/node/app

workdir /home/node/app

copy --from=production --chown=node:node /home/node/app/package*.json ./
run npm ci --omit=dev

copy --from=production --chown=node:node /home/node/app .

expose 3000

env tz=america/sao_paulo

env node_env=prod

# CMD [ "npm", "run", "start:prod" ]
CMD ./node_modules/.bin/ts-node ./node_modules/.bin/typeorm migration:run -d src/orm/config/ormconfig.prod.ts && npm run start:prod
