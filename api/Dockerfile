FROM node:20-alpine3.18

WORKDIR /app

COPY package.json package.json

RUN npm install

COPY . .

EXPOSE 3001

CMD ["npm", "run", "dev"]