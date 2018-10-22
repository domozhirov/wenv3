import * as Koa from 'koa';
import * as getPort from "get-port";
import views = require('koa-views');
import {join} from "path";
import * as koaBody  from "koa-body";

declare module "koa" {
    interface Context extends Koa.BaseContext {
        config?: any;
    }
}

class Settings {
    private server: Koa = new Koa;

    public port = 3003;

    constructor(config) {
        this.server.use(views(join(__dirname, '../static/views'), {
            map: {
                html: 'underscore'
            }
        }));

        this.server.use(koaBody());

        this.server.use(async (ctx, next) => {
            ctx.config = config;

            await next();
        });

        this.server.use(require('../routes/settings'));

        (async () => {
            this.port = await getPort({port: [3003, 3004, 3005]});
            this.server.listen(this.port);
        })();
    }
}

export default Settings;
