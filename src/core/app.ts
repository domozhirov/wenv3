import Event from './event';
import * as Koa from "koa";

class App {
    public event: Event = new Event;

    public config: object;

    public server: Koa = new Koa;

    public constructor(config) {
        config.routes.forEach(route => {
            this.server.use(require( `../routes/${route}`));
        });

        this.config = config;
    }

    public run() {

    }
}

export default App;
