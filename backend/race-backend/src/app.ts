import express from 'express';
import dotenv from 'dotenv';
dotenv.config({path: `${process.cwd()}/.env-example`});
import morgan from 'morgan';
import router  from "./routers";
import { morganCustomFormat } from "./utils/myutils";
import cors from 'cors';
import cookieParser from 'cookie-parser';

export const createApp = () => {
  const app = express();
  var corsOptions = {
    origin: '*',
    optionsSuccessStatus: 200
  }
  app.use(cors(corsOptions));
  app.use(cookieParser());
  app.use(express.json());
  app.use(morgan(morganCustomFormat));
  app.use(router);

  app.get('/', (req, res) => {
    res.status(200).send('server is alive');
  })
  app.post('/connectTest', (req, res) => {
    res.status(200).send('TEST');
    connectMYSQL(req.body);
  })
  return app;
};

import { DataSource } from 'typeorm';

export const connectMYSQL = (body : any) => {
  const dataSource = new DataSource({
    type: body.connect || 'mysql',
    host: body.host || 'for-tf-race-record.c8xl53x8kbuy.ap-northeast-2.rds.amazonaws.com',
    port: Number(body.port || 3306),
    username: body.user || 'admin',
    password: body.pws || '12345678',
    database: body.db || 'race',
  });

  dataSource.initialize()
    .then(() => {
      console.log("Data Source has been initialized!");
    })
    .catch((e) => {
      console.log("DB 연결에 실패했습니다. \n.env-example 파일을 올바르게 수정해야합니다.");
      console.log("error: ", e);
  })
}
