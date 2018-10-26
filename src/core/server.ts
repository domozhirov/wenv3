import Event from './event';
import * as Koa from "koa";
import cache from './cache';
import socket from './socket';
import {traverse} from "./utils";

declare module "koa" {
    interface Context extends Koa.BaseContext {
        config?: any;
        cache?: any
    }
}

class Server {
    public event: Event = new Event;

    public koa: Koa = new Koa;

    private server;

    private config;

    private connections = {};

    public constructor(config) {
        this.config = config;
    }

    public async start() {
        this.koa.use(async (ctx, next) => {
            ctx.config = this.config;
            ctx.cache = cache;

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

                    this.server.on('connection', (conn) =>{
                        const key = conn.remoteAddress + ':' + conn.remotePort;

                        this.connections[key] = conn;

                        conn.on('close', () => {
                            delete this.connections[key];
                        });
                    });
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
                    for (let key in this.connections) {
                        this.connections[key].destroy();
                    }

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
