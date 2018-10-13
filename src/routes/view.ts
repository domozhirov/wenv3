import * as fs from "fs";
import {Context} from 'koa';
import * as Router from "koa-router";
import Settings from '../core/settings'

const router: Router = new Router();
const settings: Settings = Settings.getInstance();

export default router.all(/.+\.(htm|html|tpl)(\?.*)?/, async (ctx: Context) => {
    const file: string = ctx.request.path.replace(/\/+$/, "");

    ctx.type = "text/html";

    let body: string = fs.readFileSync(`${settings.projectDir}${file}`, "utf8");

    if (settings.live && body) {
        body = body.replace("</body>", `\n<script src="/live.min.js"></script>\n</body>`);
    }

    ctx.body = body;
}).routes();
