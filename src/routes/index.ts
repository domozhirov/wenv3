import * as fs from "fs";
import {Context} from "koa";
import Settings from '../core/settings';

export default async (ctx: Context, next: () => void) => {
    const extensions: string[] = ["html", "htm", "tpl"];
    const uri: string = ctx.request.url.replace(/\/+$/, "");
    const dir: string = ctx.config.server.projectDir;
    let ind: string;
    let exist: boolean;
    let i: number;
    let len: number;

    for (i = 0, len = extensions.length; i < len; i++) {
        ind = `${uri}/index.${extensions[i]}`;
        exist =
            fs.existsSync(`${dir}${uri}/header.${extensions[i]}`) &&
            fs.existsSync(`${dir}${uri}/bottom.${extensions[i]}`);

        if (exist) {
            ctx.redirect(ind);
            return;
        }
    }

    await next();
};
