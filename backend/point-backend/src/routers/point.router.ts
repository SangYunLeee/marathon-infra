import express from 'express';
import pointCtl from '../controllers/point.controller';
import {asyncWrap} from '../utils/myutils';
const router = express.Router();

// routing
router.get('/', asyncWrap(pointCtl.getPoints));

export default router;
