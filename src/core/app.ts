import Server from "./server";
import Config from "./config";
import Settings from "./settings";
import {join} from "path";
import opn = require("opn");
import Updater from "./updater";

const {app, Menu, Tray, dialog, BrowserWindow} = require('electron');
const { autoUpdater } = require("electron-updater");

class App {
    public static config: Config;

    public server: Server;

    public settings: Settings;

    private tray;

    private config;

    private updater;

    private win;

    public log;

    constructor(server: Server, config) {
        this.updater = new Updater();
        this.server = server;
        this.config = config;

        const settings = new Settings(config);

        // Don't show the app in the doc
        app.dock.hide();

        app.on('window-all-closed', () => {
            app.quit()
        });

        this.settings = settings;
    }

    public run() {
        this.log = require("electron-log");

        app.on('ready', () => {
            this.tray = new Tray(this._getIcon());

            this.log.transports.file.level = "debug";
            autoUpdater.logger = this.log;

            const contextMenu = Menu.buildFromTemplate([
                {
                    label: 'Open',
                    enabled: true,
                    click: async () => {
                        if (!this.server.isEnabled()) {
                            await this.server.start();
                            contextMenu.items[1].enabled = true;
                            contextMenu.items[2].enabled = true;
                            await opn(`http://${this.server.hostname}:3000`);
                        }

                        await opn(`http://${this.server.hostname}:3000`);
                    }
                },
                {
                    label: 'Restart',
                    enabled: false,
                    click: async () => {
                        contextMenu.items[0].enabled = false;
                        contextMenu.items[1].enabled = false;
                        contextMenu.items[2].enabled = false;
                        await this.server.restart();
                        contextMenu.items[0].enabled = true;
                        contextMenu.items[1].enabled = true;
                        contextMenu.items[2].enabled = true;
                    }
                },
                {
                    label: 'Stop',
                    enabled: false,
                    click: async () => {
                        await this.server.stop();
                        contextMenu.items[1].enabled = false;
                        contextMenu.items[2].enabled = false;
                    }
                },
                {
                    type: 'separator',
                },
                {
                    label: 'Check update',
                    click: async () => {
                        const win = this.win || this._createWindow();

                        await autoUpdater.checkForUpdates();
                    }
                },
                {
                    type: 'separator',
                },
                {
                    label: 'Settings',
                    click: async () => {
                        await opn(`http://127.0.0.1:${this.settings.port}/settings`);
                    }
                },
                {
                    label: 'Exit',
                    click: async () => {
                        if (this.server.isEnabled()) {
                            await this.server.stop();
                        }
                        app.quit();
                    }
                },
            ]);

            this.tray.setToolTip('Web Environment');
            this.tray.setContextMenu(contextMenu);
        });
    }

    private _getIcon() {
        let iconName, iconPath;

        switch (process.platform) {
            case 'darwin':
                const exec = require('child_process').execSync;
                const gpref = exec('defaults read .GlobalPreferences').toString();

                if (gpref.indexOf('AppleInterfaceStyle = Dark') !== -1) {
                    iconName = 'white.png';
                } else {
                    iconName = 'dark.png';
                }

                break;
            case 'win32':
                iconName = 'icon.ico';

                break;
            default:
                iconName = 'white.png';
        }

        iconPath = join(__dirname, `../static/${iconName}`);

        return iconPath;
    }

    private _createWindow() {
        this.win = new BrowserWindow();
        this.win.webContents.openDevTools();
        this.win.on('closed', (event) => {

            event.preventDefault();
            app.hide();

            return false;
        });
        this.win.loadURL(join('file://', __dirname, '..', 'static', 'views', 'version', `index.html#v${app.getVersion()}`));

        // autoUpdater.setFeedURL({
        //     url: 'https://github.com/domozhirov/wenv/releases/download/v3.1.1/wenv-3.1.1.dmg'
        // });

        autoUpdater.on('checking-for-update', () => {
            this.win.webContents.send('message', 'Checking for update...');
        });
        autoUpdater.on('update-available', (ev, info) => {
            this.win.webContents.send('message', 'Update available.');
        });
        autoUpdater.on('update-not-available', (ev, info) => {
            this.win.webContents.send('message', 'Update not available.');
        });
        autoUpdater.on('error', (ev, err) => {
            this.win.webContents.send('message', 'Error in auto-updater.');
        });
        autoUpdater.on('download-progress', (ev, progressObj) => {
            this.win.webContents.send('message', 'Download progress...');
        });
        autoUpdater.on('update-downloaded', (versionInfo) => {
            var dialogOptions = {
                type: 'question',
                defaultId: 0,
                message: `The update is ready to install, Version ${versionInfo.version} has been downloaded and will be automatically installed when you click OK`
            };
            dialog.showMessageBox(this.win, dialogOptions, () => {
                autoUpdater.quitAndInstall();
            });
        });
        autoUpdater.on('update-downloaded', (ev, info) => {
            // Wait 5 seconds, then quit and install
            // In your application, you don't need to wait 5 seconds.
            // You could call autoUpdater.quitAndInstall(); immediately
            setTimeout(function() {
                autoUpdater.quitAndInstall();
            }, 5000)
        });

        return this.win;
    }
}

export default App;
