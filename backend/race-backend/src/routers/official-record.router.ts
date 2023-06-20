import express from 'express';
import recordCtl from '../controllers/official-record.controller';
import {asyncWrap} from '../utils/myutils';
const router = express.Router();

// routing
router.post('/', asyncWrap(recordCtl.createRecords));
router.get('/', asyncWrap(recordCtl.getRecords));

export default router;
