import * as fs from "fs";
import {Context} from 'koa';
import * as Router from "koa-router";
import * as send from "koa-send";
import Settings from '../libs/settings'
import * as path from "path";

const router = new Router();
const settings = Settings.getInstance();

router.get(/^\/settings\/?(css|js)?\/?(.+\.(js|css)$)?/, async (ctx: Context) => {
    const file = ctx.request.path.replace(/\/+$/, "");
    const root = path.join(__dirname, '../static/views');

    if (file === '/settings') {
        ctx.type = "text/html";

        await ctx.render('settings/index', {
            settings: settings
        });
    } else if (file.search(/(css|js)$/g) !== -1) {
        const exist = fs.existsSync(`${root}${file}`);

        if (exist) {
            await send(ctx, file, { root:  root });
        }
    }
});

router.post('/settings',async (ctx: Context) => {
    let body = ctx.request.body;

    try {
        settings.set(body);
        settings.save();

        ctx.body = JSON.stringify({result: 'saved'});
    } catch (e) {
        ctx.body = JSON.stringify({
            error: {
                message: new Error(e)
            }
        });
    }
});


export default router.routes();