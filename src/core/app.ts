import SysTray from 'systray'
import Server from "./server";
import Config from "./config";
import Settings from "./settings";
import {join} from "path";
import {readFileSync} from "fs";
import opn = require("opn")

class App {
    public static config: Config;

    public server: Server;

    public settings: Settings;

    private tray: SysTray;

    private config;

    constructor(server: Server, config) {
        this.server = server;
        this.config = config;

        this.tray = new SysTray({
            menu: {
                icon: this._getIcon(),
                title: '',
                tooltip: '',
                items: this.config.app.tray
            }
        });

        this.settings = new Settings(config);
    }

    public run() {
        this.tray.onClick(async action => {
            switch (action.seq_id) {
                case 0:
                case 1:
                case 2:
                    const title = action.item.title.toLowerCase();
                    this._changeAction('disable');
                    await this.server[title]();
                    this._changeAction(title);

                    if (action.seq_id === 0) {
                        await opn(`http://${this.server.hostname}:${this.config.server.httpPort}`);
                    }
                    break;
                case 3:
                    await opn(`http://127.0.0.1:${this.settings.port}/settings`);
                    break;
                case 4:
                    await this.server.stop();
                    this.tray.kill();
                    break;
            }
        });

        this.tray.onExit((code, signal) => {
            setTimeout(() =>
                process.exit(0), 2000)
        });
    }

    private _getIcon() {
        let iconName, iconPath;

        switch (process.platform) {
            case 'darwin':
                const exec = require('child_process').execSync;
                const gpref = exec('defaults read .GlobalPreferences').toString();

                if (gpref.indexOf('AppleInterfaceStyle = Dark') !== -1) {
                    iconName = 'white.icns';
                } else {
                    iconName = 'dark.icns';
                }

                break;
            case 'win32':
                iconName = 'icon.ico';

                break;
            default:
                iconName = 'icon.png';
        }

        iconPath = join(__dirname, `../static/${iconName}`);

        return readFileSync(iconPath).toString('base64');
    }

    private _changeAction(action = 'disable') {
        let items = this.config.app.tray.slice(0, 3);
        let status;

        switch (action) {
            case 'start':
            case 'restart':
                status = [false, true, true];
                break;
            case 'stop':
                status = [true, false, false];
                break;
            case 'disable':
                status = [false, false, false];
                break;
        }

        if (status) {
            status.forEach((item, index) => {
                this.tray.sendAction({
                    type: 'update-item',
                    item: {
                        ...items[index],
                        enabled: item,
                    },
                    seq_id: index,
                });
            });
        }
    }
}

export default App;
