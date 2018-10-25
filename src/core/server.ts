import Event from './event';
import * as Koa from "koa";
import cache from './cache';
import socket from './socket';
import {traverse} from "./utils";

declare module "koa" {
    interface Context extends Koa.BaseContext {
        config?: any;
        cacher: any
    }
}

class Server {
    public event: Event = new Event;

    public koa: Koa = new Koa;

    private server;

    private config;

    public constructor(config) {
        this.config = config;
    }

    public async start() {
        this.koa.use(async (ctx, next) => {
            ctx.config = this.config;
            ctx.cacher = cache;

            await next();
        });

        this.config.app.routes.custom = this.config.routes;

        traverse(this.config.app.routes, (route, path) => {
            try {
                delete require.cache[require.resolve(path)];

                this.koa.use(require(path));
            } catch (e) {
                console.log(`Route "${route}" not required. Message: ${e.message}`);
            }
        });

        return new Promise((resolve, reject) => {
            try {
                this.server = this.koa.listen(this.config.server.httpPort, "localhost", () => {
                    resolve(true);
                    socket(this.server, this.config);
                });
            } catch (e) {
                reject(`Port "${this.config.server.httpPort}" is used`);
            }
        })
    }

    public async stop() {
        return new Promise((resolve, reject) => {
            try {
                if (this.server) {
                    this.server.close(() => {
                        this.koa.middleware = [];
                        resolve(true);
                    });
                } else {
                    reject(new Error('Server not started'))
                }
            } catch (e) {
                reject(e);
            }
        })
    }

    public async restart() {
        await this.stop();

        return this.start();
    }
}

export default Server;
