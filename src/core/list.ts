import {Request, Response} from "express";
import * as fs from "fs";
import {Context} from "koa";
import * as originalServeIndex from "serve-index";

export default function(root: string = '', options: object = {}) {
    return async (ctx: Context, next: () => void) => {
        const projectDir = root ? root : ctx.config.server.projectDir;
        const fn = originalServeIndex(projectDir, options);
        const path = `${projectDir}${ctx.path}`;
        const exist = fs.existsSync(path);

        if (exist && fs.statSync(path).isDirectory()) {
            return new Promise((resolve, reject) => {
                // hacked statusCode
                if (ctx.status === 404) {
                    ctx.status = 200;
                }
                // unnecessary response by koa
                ctx.respond = false;
                // 404, serve-static forward non-404 errors
                // force throw error
                fn(ctx.req as Request, ctx.res as Response, reject);
            });
        } else {
            await next();
        }
    };
}
