import express from 'express';
import dataSource from "./database";

const createCompetitions = async (req: express.Request, res: express.Response) => {
  const {competition_name, race_type} = req.body;
  await dataSource.query(
    `
      INSERT INTO
        competition
        (competition_name, competition_date, race_type, host_user_id)
      VALUES
        (?,?,?,?)
    `,
    [competition_name, '1998-01-23 12:45:56', race_type, 1]
  );
  res.status(200).send("대회 생성 성공");
}

const getCompetitions = async (req: express.Request, res: express.Response) => {
  const competitions = await dataSource.query(
    `
      SELECT
        competition_name,
        competition_date,
        race_type,
        host_user_id
      FROM
        competition
    `
  );
  res.status(200).json(competitions);
}

export default {
  createCompetitions,
  getCompetitions,
}
