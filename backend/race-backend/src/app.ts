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
  return app;
};
