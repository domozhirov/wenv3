import * as fs from "fs-extra";
import {Context} from "koa";
import * as Router from "koa-router";
import * as path from "path";

const router: Router = new Router();

let content: string;

export = router.all("/live.min.js", async (ctx: Context) => {
    if (! content) {
        content = fs.readFileSync(path.join(__dirname, "../static/client/", ctx.path), "utf8");
    }
    ctx.body = content;
    ctx.type = "text/javascript";
}).routes();
