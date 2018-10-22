import * as fs from "fs";
import {Context} from "koa";
import * as send from "koa-send";
import Settings from '../core/settings'

export = async (ctx: Context, next: () => Promise<any>) => {
    const exist = fs.existsSync(`${ ctx.config.server.projectDir}${ctx.path}`);

    if (exist) {
        await send(ctx, ctx.path, { root:  ctx.config.server.projectDir });
    } else {
        await next();
    }
};
