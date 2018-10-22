import * as fs from "fs";
import {Context} from 'koa';
import * as Router from "koa-router";
import * as send from "koa-send";
import {join} from "path";

const router = new Router();

router.get(/^\/settings\/?(css|js)?\/?(.+\.(js|css)$)?/, async (ctx: Context) => {
    const path = ctx.request.path.replace(/\/+$/, "");
    const root = join(__dirname, '../static/views');

    if (path === '/settings') {
        ctx.type = "text/html";

        await ctx.render('settings/index', {
            server: ctx.config.server
        });
    } else if (path.search(/(css|js)$/g) !== -1) {
        const exist = fs.existsSync(`${root}${path}`);

        if (exist) {
            await send(ctx, path, { root:  root });
        }
    }
});

router.post('/settings',async (ctx: Context) => {
    const body = ctx.request.body;


    ctx.config[body.section] = JSON.parse(body.data);

    try {
        // settings.set(body);
        // settings.save();

        ctx.body = JSON.stringify({result: 'saved'});
    } catch (e) {
        ctx.body = JSON.stringify({
            error: {
                message: e
            }
        });
    }
});

export = router.routes();
