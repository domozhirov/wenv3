import * as path from 'path'
import * as fs from 'fs-extra'
import SysTray from 'systray'
import opn = require('opn')
import Settings from './core/settings'

const settings = Settings.getInstance()

import './server'

let iconName;

switch (process.platform) {
    case 'darwin':
        const exec = require('child_process').execSync;
        const isDark = exec('defaults read .GlobalPreferences').toString().indexOf('AppleInterfaceStyle = Dark') !== -1;

        if (isDark) {
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

const icon = path.join(__dirname, `static/${iconName}`);
const tray = new SysTray({
    menu: {
        icon: fs.readFileSync(icon).toString('base64'),
        title: '',
        tooltip: '',
        items: [
            {
                title: "Open",
                tooltip: "Open",
                checked: false,
                enabled: true
            },
            {
                title: "Settings",
                tooltip: "Settings",
                checked: false,
                enabled: true
            }, {
                title: "Exit",
                tooltip: "Exit",
                checked: false,
                enabled: true
            }
        ]
    }
});

tray.onClick(async action => {
    if (action.seq_id === 0) {
        await opn(`http://127.0.0.1:${settings.port}`);
    } else if (action.seq_id === 1) {
        // open the url
        await opn(`http://127.0.0.1:${settings.port}/settings`);
    } else if (action.seq_id === 2) {
        tray.kill()
    }
});

// Fix aria2c cannot exit
tray.onExit((code, signal) => {
    setTimeout(() =>
        process.exit(0), 2000)
});
