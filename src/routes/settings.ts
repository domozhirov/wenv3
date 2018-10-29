import * as fs from "fs-extra";
import {Context} from 'koa';
import * as Router from "koa-router";
import * as send from "koa-send";
import {join} from "path";
import {homedir, tmpdir} from "os";

const router = new Router();

router.get(/^\/settings\/?(css|js)?\/?(.+\.(js|css)$)?/, async (ctx: Context) => {
    const path = ctx.request.path.replace(/\/+$/, "");
    const root = join(__dirname, '../static/views');

    if (path === '/settings') {
        ctx.type = "text/html";

        await ctx.render('settings/index', {
            server: ctx.config.server,
            routes: ctx.config.routes,
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

    ctx.type = "application/json";

    try {
        ctx.config[body.section] = JSON.parse(body.data);

        ctx.body = JSON.stringify({result: 'saved'});
    } catch (e) {
        ctx.body = JSON.stringify({
            error: {
                message: e.message
            }
        });
    }
});

router.post('/settings/route',async (ctx: Context) => {
    const body = ctx.request.body;
    const route = body.route;
    const dir = join(homedir(), '.wenv3/routes/', route);
    const routes = ctx.config.routes;

    ctx.type = "application/json";

    try {
        if (fs.existsSync(dir)) {
            fs.removeSync(dir);
        }

        delete routes[route];

        ctx.config.routes = routes;

        ctx.body = JSON.stringify({result: 'deleted'});
    } catch (e) {
        ctx.body = JSON.stringify({
            error: {
                message: e.message
            }
        });
    }
});

router.post('/settings/cache',async (ctx: Context) => {
    fs.removeSync(join(tmpdir(), 'ru.megagroup.wenv3'))
});

router.post('/settings/factory',async (ctx: Context) => {
    fs.removeSync(join(tmpdir(), 'ru.megagroup.wenv3'));
    fs.removeSync(join(homedir(), '.wenv3'));
});

export = router.routes();
