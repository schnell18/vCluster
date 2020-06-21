FROM node:12.18-alpine3.12

EXPOSE 3000

ENV HOME=/usr/src/app
WORKDIR ${HOME}

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build --production

RUN chown -R 1001:0 ${HOME} && \
    find ${HOME} -type d -exec chmod g+ws {} \;

USER guest
CMD ["npm", "start"]
