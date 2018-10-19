import Event from './event';
import * as Koa from "koa";
import {traverse} from "./utils";

declare module "koa" {
    interface Context extends Koa.BaseContext {
        config?: any;
    }
}

class Server {
    public event: Event = new Event;

    public koa: Koa = new Koa;

    private server;

    private config;

    public constructor(config) {
        this.koa.use(async (ctx, next) => {
            ctx.config = config;

            next()
        });

        traverse(config.app.routes, (route, path) => {
            try {
                this.koa.use(require(path))
            } catch (e) {
                console.log(`Route "${route}" not required`);
            }
        });

        this.config = config;
    }

    public async start() {
        return new Promise((resolve, reject) => {
            try {
                this.server = this.koa.listen(this.config.server.httpPort, "localhost",() => {
                    resolve(true);
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
