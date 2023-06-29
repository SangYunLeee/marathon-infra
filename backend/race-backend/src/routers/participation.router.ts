import express from 'express';
import participationCtl from '../controllers/participation.controller';
import {asyncWrap} from '../utils/myutils';
const router = express.Router();

// routing
router.post('/', asyncWrap(participationCtl.createParticipation));
router.get('/', asyncWrap(participationCtl.getParticipation));

export default router;
