import express from 'express';
import dataSource from "./database";

// 1~3 사이 값 랜덤 생성 함수
function getRandomValue() {
  return Math.floor(Math.random() * 3) + 1;
}

const createRecords = async (req: express.Request, res: express.Response) => {
  const {user_id} = req.body;
  if (!user_id) {
    res.status(400).send("사용자 ID 를 전달받지 못했습니다.")
  }
  await dataSource.query(
    `
      INSERT INTO
        unofficial_record
        (user_id, race_type, record_time)
      VALUES
        (?,?,?)
    `,
    [user_id, getRandomValue() ,'1998-01-23 12:45:56']
  );
  res.status(200).send("점수가 추가되었습니다.")
}

const getRecords = async (req: express.Request, res: express.Response) => {
  const records = await dataSource.query(
    `
      SELECT
        user_id,
        race_type,
        record_time
      FROM
        unofficial_record
    `,
  );
  res.status(200).json(records)
}

export default {
  createRecords,
  getRecords,
}
