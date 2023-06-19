FROM node:16-alpine

WORKDIR /app

COPY package.json .
COPY package-lock.json .

RUN npm ci

COPY . .

RUN npm run build

ENV TYPEORM_CONNECTION=mysql
ENV TYPEORM_HOST=www.enttolog.xyz
ENV TYPEORM_USERNAME=root
ENV TYPEORM_PASSWORD=unknown
ENV TYPEORM_DATABASE=race
ENV TYPEORM_PORT=33306
ENV TYPEORM_LOGGING=TRUE
ENV PORT=5500

EXPOSE 5500

CMD ["npm", "run", "start-production"]