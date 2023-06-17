import express from 'express';
import dataSource from "./database";

const createParticipation = async (req: express.Request, res: express.Response) => {
  const {user_id, competition_id} = req.body;
  if (!user_id || !competition_id) {
    res.status(400).send("대회 ID 혹은 사용자 ID 를 전달받지 못했습니다.")
  }
  await dataSource.query(
    `
      INSERT INTO
        competition_user
        (competition_id, user_id)
      VALUES
        (?,?)
    `,
    [competition_id, user_id]
  );
  res.status(200).send("참가 신청이 완료되었습니다.")
}

const getParticipation = async (req: express.Request, res: express.Response) => {
  const participations = await dataSource.query(
    `
      SELECT
        competition_id,
        user_id,
        created_at
      FROM
        competition_user
    `
  );
  res.status(200).json(participations);
}

export default {
  createParticipation,
  getParticipation,
}
