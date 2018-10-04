import * as fs from "fs";
import {Context} from "koa";
import * as Router from "koa-router";
import {Options, render, Result} from "node-sass";
import * as path from "path";
import cache from "../libs/cache";
import Settings from '../libs/settings';

const settings = Settings.getInstance();

const router: Router = new Router();
const dir: string = settings.projectDir;

export default router.all(/.+\.scss?(\.css)(?:\?.*)?/, async (ctx: Context, next) => {
    const url: string = ctx.request.path.replace(/\.css$/, "");
    const file: string = path.join(dir, url);
    const exist: boolean = fs.existsSync(file);

    if (exist) {
        const result = await compileSass(url, {
            file: file,
            omitSourceMapUrl: true,
        });
        ctx.body = result.css;
        ctx.type = "text/css";
    } else {
        await next();
    }
}).routes();

async function compileSass(url: string, options: Options): Promise<any> {
    return new Promise((resolve, reject) => {
        options.importer = (file, prev, done) => {
            if (file.indexOf("compass") === 0) {
                done({
                    contents: ''
                })
            } else if (file.indexOf("global:") === 0) {
                file = path.join("/g/", file.slice(7));
                cache(file).then((file) => {
                    done({file: file});
                }).catch((err) => {
                    done(err);
                });
            } else if (file.indexOf("local:") === 0) {
                url  = url.slice(0, url.indexOf("/images/"));
                file = file.slice(6);

                done({file: path.join(dir, url, "images", file)});
            } else {
                done({file: path.join(dir, file)});
            }
        };

        render(options, (err, result) => {
            if (err) {
                reject(err);
            } else {
                resolve(result);
            }
        })
    });
}
