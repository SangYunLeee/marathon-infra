import express from 'express';
import dataSource from "./database";

const getPoints = async (req: express.Request, res: express.Response) => {
  const points = await dataSource.query(
    `
      SELECT
        user_id,
        user_point
      FROM
        point
    `
  );
  res.status(200).json(points);
}

export default {
  getPoints,
}
