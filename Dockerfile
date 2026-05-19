FROM node:24-alpine
# node

RUN addgroup devopsgrp && adduser -S -Gdevopsgrp devopsusr

WORKDIR /app

COPY package*.json ./

RUN npm ci --omit=dev


COPY . .


USER devopsusr

EXPOSE 80

CMD ["node", "app.js"]
