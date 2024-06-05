FROM node:14-alpine
WORKDIR /app
COPY . .
RUN if [ -f "package.json" ]; then npm install; fi
CMD ["node", "index.js"] # Ajuste conforme necessário
