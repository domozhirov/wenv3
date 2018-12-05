import Server from "./server";
import Config from "./config";
import Settings from "./settings";
import {join} from "path";
import opn = require("opn")

const {app, Menu, Tray, autoUpdater, dialog} = require('electron');

class App {
    public static config: Config;

    public server: Server;

    public settings: Settings;

    private tray;

    private config;

    constructor(server: Server, config) {
        this.server = server;
        this.config = config;

        const settings = new Settings(config);

        // Don't show the app in the doc
        app.dock.hide();

        app.on('ready', () => {
            this.tray = new Tray(this._getIcon());

            const contextMenu = Menu.buildFromTemplate([
                {
                    label: 'Open',
                    enabled: true,
                    click: async () => {
                        if (!server.isEnabled()) {
                            await server.start();
                            contextMenu.items[1].enabled = true;
                            contextMenu.items[2].enabled = true;
                            await opn(`http://${server.hostname}:3000`);
                        }

                        await opn(`http://${server.hostname}:3000`);
                    }
                },
                {
                    label: 'Restart',
                    enabled: false,
                    click: async () => {
                        contextMenu.items[0].enabled = false;
                        contextMenu.items[1].enabled = false;
                        contextMenu.items[2].enabled = false;
                        await server.restart();
                        contextMenu.items[0].enabled = true;
                        contextMenu.items[1].enabled = true;
                        contextMenu.items[2].enabled = true;
                    }
                },
                {
                    label: 'Stop',
                    enabled: false,
                    click: async () => {
                        await server.stop();
                        contextMenu.items[1].enabled = false;
                        contextMenu.items[2].enabled = false;
                    }
                },
                {
                    type: 'separator',
                },
                {
                    label: 'Settings',
                    click: async function() {
                        await opn(`http://127.0.0.1:${settings.port}/settings`);
                    }
                },
                {
                    label: 'Exit',
                    click: async () => {
                        if (server.isEnabled()) {
                            await server.stop();
                        }
                        app.quit();
                    }
                },
            ]);

            this.tray.setToolTip('Web Environment');
            this.tray.setContextMenu(contextMenu);
        });

        app.on('window-all-closed', () => {
            app.quit()
        });

        this.settings = settings;
    }

    public run() {
        const server = 'https://your-deployment-url.com'
        const feed = `${server}/update/${process.platform}/${app.getVersion()}`;

        // autoUpdater.setFeedURL(feed);
        //
        // setInterval(() => {
        //     autoUpdater.checkForUpdates()
        // }, 60000);
        //
        // autoUpdater.on('update-downloaded', (event, releaseNotes, releaseName) => {
        //     const dialogOpts = {
        //         type: 'info',
        //         buttons: ['Restart', 'Later'],
        //         title: 'Application Update',
        //         message: process.platform === 'win32' ? releaseNotes : releaseName,
        //         detail: 'A new version has been downloaded. Restart the application to apply the updates.'
        //     };
        //
        //     dialog.showMessageBox(dialogOpts, (response) => {
        //         if (response === 0) autoUpdater.quitAndInstall()
        //     })
        // });
        //
        // autoUpdater.on('error', message => {
        //     console.error('There was a problem updating the application')
        //     console.error(message)
        // });
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
}

export default App;
