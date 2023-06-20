import express from "express";
import competitionRouter from './competition.router';
import participationRouter from './participation.router';
import officialRecordRouter from './official-record.router';
import unofficialRecordRouter from './unofficial-record.router';
import middleware from "../middlewares/middleware";

const router = express.Router();

// 대회 정보
router.use('/competitions', competitionRouter);

// 대회 참가 신청서
router.use('/participations', participationRouter);

// 대회 기록
router.use('/competitions/records', officialRecordRouter);

// 비공식 기록
router.use('/records/unofficials', unofficialRecordRouter);

router.use(middleware.errorHandler);
export default router;
