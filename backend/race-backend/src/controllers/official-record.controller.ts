import express from 'express';
import dataSource from "./database";

const createRecords = async (req: express.Request, res: express.Response) => {
  const {user_id, competition_id} = req.body;
  if (!user_id || !competition_id) {
    res.status(400).send("대회 ID 혹은 사용자 ID 를 전달받지 못했습니다.")
  }
  await dataSource.query(
    `
      INSERT INTO
        record
        (competition_id, user_id, record_time)
      VALUES
        (?,?,?)
    `,
    [competition_id, user_id, '1998-01-23 12:45:56']
  );
  res.status(200).send("점수가 추가되었습니다.")
}

const getRecords = async (req: express.Request, res: express.Response) => {
  const records = await dataSource.query(
    `
      SELECT
        competition_id,
        user_id,
        record_time
      FROM
        record
    `,
  );
  res.status(200).json(records)
}

export default {
  createRecords,
  getRecords,
}
