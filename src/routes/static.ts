import * as fs from "fs";
import {Context} from "koa";
import * as send from "koa-send";
import Settings from '../core/settings'
import * as path from "path";

const settings = Settings.getInstance();

export = async (ctx: Context, next: () => Promise<any>) => {
    const exist = fs.existsSync(`${ settings.projectDir}${ctx.path}`);

    if (exist) {
        await send(ctx, ctx.path, { root:  settings.projectDir });
    } else {
        await next();
    }
};
