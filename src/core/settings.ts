import * as Koa from 'koa';
import * as getPort from "get-port";
import views = require('koa-views');
import extract = require("extract-zip");
import * as koaBody from "koa-body";
import * as fs from "fs-extra";
import * as os from "os";
import * as path from "path";

declare module "koa" {
    interface Context extends Koa.BaseContext {
        config?: any;
    }
}

class Settings {
    private server: Koa = new Koa;

    public port = 3003;

    constructor(config) {
        this.server.use(views(path.join(__dirname, '../static/views'), {
            map: {
                html: 'underscore'
            }
        }));

        this.server.use(koaBody({multipart: true}));

        this.server.use(async (ctx, next) => {
            ctx.config = config;

            await next();
        });

        this.server.use(require('../routes/settings'));

        this.server.use(async function (ctx, next) {
            // ignore non-POSTs
            if ('POST' != ctx.method || !ctx.request.files) return await next();

            const file = ctx.request.files.file;
            const dir = path.join(os.homedir(), '/.wenv3/routes/');

            if (!fs.existsSync(dir)) {
                fs.ensureDirSync(dir);
            }

            await new Promise((resolve, reject) => {
                extract(file.path, {
                    dir: dir
                }, (err) => {
                    if (err) {
                        ctx.body = JSON.stringify({
                            error: {
                                message: err
                            }
                        });
                        ctx.status = 503;

                        reject();
                    } else {
                        const route = file.name.replace('.zip', '');
                        const settings = {};

                        settings[route] = path.join(dir, route);

                        config.routes = Object.assign({}, config.routes, settings);

                        ctx.body = JSON.stringify({result: route});
                        ctx.status = 200;

                        resolve(route);
                    }
                });
            });
        });

        (async () => {
            this.port = await getPort({port: [3003, 3004, 3005]});
            await this.server.listen(this.port);
        })();
    }
}

export default Settings;
