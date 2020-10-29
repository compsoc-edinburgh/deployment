FROM node:15.0.1-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE ${PORT}

CMD [ "npm", "run", "start" ]
