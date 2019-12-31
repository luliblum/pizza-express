FROM node:8.4.0
WORKDIR '/var/www/app'
COPY ./package.json ./
RUN npm install
COPY ./ ./
CMD ["npm","start"]



