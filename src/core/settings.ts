import * as Koa from 'koa';
import * as getPort from "get-port";
import views = require('koa-views');
import {join} from "path";

declare module "koa" {
    interface Context extends Koa.BaseContext {
        config?: any;
    }
}

class Settings {
    public static dir: string = `wenv3/`;

    public static path: string = `/wenv3/settings.json`;

    public static instance: Settings;

    public port = 3001;

    public socketPort: number = 3002;

    public projectDir: string = `/`;

    public renderer: string = 'none';

    public live: boolean = true;

    private server: Koa = new Koa;

    // private port;

    constructor() {
        this.server.use(views(join(__dirname, '../static/views'), {
            map: {
                html: 'underscore'
            }
        }));

        this.server.use(require('../routes/settings'));

        (async () => {
            this.port = await getPort({port: [3003, 3004, 3005]});
            this.server.listen(this.port);
        })();
    }

    public static getInstance(): Settings {
        if (!Settings.instance) {
            Settings.instance = new Settings;
        }

        return Settings.instance;
    }
}

export default Settings;

// import * as fs from 'fs-extra';
// import {homedir} from 'os';
//
// class Settings {
//     public static dir: string = `${homedir}.wenv3/`;
//
//     public static path: string = `${homedir}/wenv3/settings.json`;
//
//     public static instance: Settings;
//
//     public port: number = 3000;
//
//     public socketPort: number = 3001;
//
//     public projectDir: string = `${homedir}/`;
//
//     public renderer: string = 'none';
//
//     public live: boolean = true;
//
//     public static getInstance(reload: boolean = false): Settings {
//         if (!Settings.instance) {
//             Settings.instance = new Settings;
//             Settings.instance.load();
//         }
//
//         if (reload) {
//             Settings.instance.load();
//         }
//
//         return Settings.instance;
//     }
//
//     public save(): void {
//         fs.writeFileSync(Settings.path, JSON.stringify(this, null, "\t"));
//     }
//
//     public load(): void {
//         if (fs.existsSync(Settings.path)) {
//             const data = fs.readFileSync(Settings.path).toString();
//
//             try {
//                 const settings = JSON.parse(data);
//
//                 this.set(settings);
//             } catch (e) {}
//         }
//     }
//
//     public set(settings) {
//         for (let key in this) {
//             if (settings.hasOwnProperty(key)) {
//                 switch (typeof this[key]) {
//                     case 'boolean':
//                         settings[key] = !!+settings[key];
//                         break;
//                     case 'number':
//                         settings[key] = ~~settings[key];
//                         break;
//                     case 'string':
//                         settings[key] = `${settings[key]}`;
//                         break;
//                 }
//
//                 this[key] = settings[key];
//             }
//         }
//     }
// }
//
