import Event from './event';
import * as Koa from "koa";

class Server {
    public event: Event = new Event;

    public koa: Koa = new Koa;

    private server;

    private config;

    public constructor(config) {
        config.routes.forEach(route => {
            this.koa.use(require( `../routes/${route}`));
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
