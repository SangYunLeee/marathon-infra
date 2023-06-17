import type express from "express";

// error handling 미들웨어
const errorHandler: express.ErrorRequestHandler = (err: MyError, req, res, next) => {
    // 흐름상 에러가 검출되면 로그 표시 및 클라이언트에게 전달
    let responseInfo = err;
    if (err.sqlMessage) {
        console.log(err.sqlMessage);
        responseInfo = { ...err, status: 500, message: "failed" };
    }
    console.log("err LOG:", err);
    res.status(responseInfo.status || 500).send({ message: responseInfo.message || "" });
};

export default {
    errorHandler,
};
