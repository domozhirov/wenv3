import * as fs from "fs";
import {Context} from "koa";
import * as Router from "koa-router";
import {Options, render} from "node-sass";
import * as path from "path";
import cache from "../core/cache";

const router: Router = new Router();

export = router.all(/.+\.scss?(\.css)(?:\?.*)?/, async (ctx: Context, next) => {
    const dir = ctx.config.server.projectDir;
    const url: string = ctx.request.path.replace(/\.css$/, "");
    const file: string = path.join(dir, url);
    const exist: boolean = fs.existsSync(file);

    if (exist) {
        const result = await compileSass(dir, url, {
            file: file,
            omitSourceMapUrl: true,
        });
        ctx.body = result.css;
        ctx.type = "text/css";
    } else {
        await next();
    }
}).routes();

async function compileSass(dir, url: string, options: Options): Promise<any> {
    return new Promise((resolve, reject) => {
        options.importer = (file, prev, done) => {
            if (file.indexOf("compass") === 0) {
                done({
                    contents: ''
                })
            } else if (file.indexOf("global:") === 0) {
                file = path.join("/g/", file.slice(7));
                cache(file, "http://dumper.demojs0.oml.ru/").then((file) => {
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
