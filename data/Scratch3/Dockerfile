FROM node:10-alpine

RUN apk add --no-cache nano git

RUN mkdir -p /usr/app/Scratch3
RUN git clone https://github.com/LLK/scratch-gui.git /usr/app/Scratch3
# RUN sed -e "s/8601/80/" /usr/app/Scratch3/webpack.config.js
RUN cd usr/app/Scratch3 && npm install

EXPOSE 8601

WORKDIR /usr/app/Scratch3

CMD ["npm","start"]
