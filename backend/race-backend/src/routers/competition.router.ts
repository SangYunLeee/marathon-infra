import express from 'express';
import competitionCtl from '../controllers/competition.controller';
import {asyncWrap} from '../utils/myutils';
const router = express.Router();

// routing
router.post('/', asyncWrap(competitionCtl.createCompetitions));
router.get('/', asyncWrap(competitionCtl.getCompetitions));

export default router;
