FROM node:18.18-alpine3.18 as production

ARG version

ENV version=${version}

USER node

RUN mkdir -p /home/node/app

WORKDIR /home/node/app

# Etapa 1: Copia apenas os arquivos de package.json
COPY --chown=node:node package*.json ./

# Instalação das dependências
RUN npm ci --omit=dev

# Etapa 2: Copia o restante dos arquivos
COPY --chown=node:node . .

EXPOSE 3000

ENV TZ=America/Sao_Paulo

ENV NODE_ENV=prod

CMD ./node_modules/.bin/ts-node ./node_modules/.bin/typeorm migration:run -d src/orm/config/ormconfig.prod.ts && npm run start:prod
