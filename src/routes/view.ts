import * as fs from "fs";
import {Context} from 'koa';
import * as Router from "koa-router";

const router: Router = new Router();

export default router.all(/.+\.(htm|html|tpl)(\?.*)?/, async (ctx: Context) => {
    const file: string = ctx.request.path.replace(/\/+$/, "");

    ctx.type = "text/html";

    let body: string = fs.readFileSync(`${ctx.config.server.projectDir}${file}`, "utf8");

    if (ctx.config.server.livereload && body) {
        body = body.replace("</body>", `\n<script src="/live.min.js"></script>\n</body>`);
    }

    ctx.body = body;
}).routes();
