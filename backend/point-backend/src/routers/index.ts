import express from "express";
import pointRouter from './point.router';
import middleware from "../middlewares/middleware";

const router = express.Router();

// 점수
router.use('/points', pointRouter);

router.use(middleware.errorHandler);
export default router;
