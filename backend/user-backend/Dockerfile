# node.js 이미지를 바탕으로 컨테이너를 실행한 후
# http://localhost:3333으로 접속했을 때 hello from server 메시지가 표시되게 만드세요

FROM node:16-alpine

# 앱 디렉터리 생성
WORKDIR /app

# 앱 의존성 설치
COPY package.json /app

RUN npm install

# 앱 소스 추가
COPY . .

EXPOSE 3000

CMD [ "node", "user.js" ]