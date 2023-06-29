import type {Request, Response, NextFunction} from 'express';
declare module "jsonwebtoken" {
  interface UserInfoPayload extends JwtPayload, InfoType {
  }
  function verify(token: string, secretOrPublicKey: Secret, options?: VerifyOptions & { complete?: false }): UserInfoPayload;
  function sign(payload: InfoType, secretOrPrivateKey: Secret, options?: SignOptions, ): string;
}
declare global {
  namespace NodeJS {
    interface ProcessEnv {
      TYPEORM_CONNECTION: "mysql" | "mariadb";
    }
  }

  type InfoType  = {
    id: string,
    email?: string,
    nickname?: string,
    password?: string,
    profile_image?: string
  }

  export type UserInfo  = {
    id?: string,
    email?: string,
    nickname?: string,
    password?: string,
    profile_image?: string
  }

  namespace Express {
    export interface Request {
      userInfo?: UserInfo;
    }
  }
  interface MyError extends Error {
    sqlMessage?: string;
    status: number;
  }
}