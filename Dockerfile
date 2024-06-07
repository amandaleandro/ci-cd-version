
FROM node:14-alpine
ARG VERSION
ENV VERSION ${VERSION}
WORKDIR /app
COPY . .
RUN if [ -f "package.json" ]; then npm install; fi
CMD ["node", "index.js"] # Ajuste conforme necessário
