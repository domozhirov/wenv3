import * as fs from 'fs-extra';
import {homedir} from 'os';

class Settings {
    public static dir: string = `${homedir}.wenv3/`;

    public static path: string = `${homedir}/wenv3/settings.json`;

    public static instance: Settings;

    public port: number = 3000;

    public socketPort: number = 3001;

    public projectDir: string = `${homedir}/`;

    public renderer: string = 'none';

    public live: boolean = true;

    public static getInstance(reload: boolean = false): Settings {
        if (!Settings.instance) {
            Settings.instance = new Settings;
            Settings.instance.load();
        }

        if (reload) {
            Settings.instance.load();
        }

        return Settings.instance;
    }

    public save(): void {
        fs.writeFileSync(Settings.path, JSON.stringify(this, null, "\t"));
    }

    public load(): void {
        if (fs.existsSync(Settings.path)) {
            const data = fs.readFileSync(Settings.path).toString();

            try {
                const settings = JSON.parse(data);

                this.set(settings);
            } catch (e) {}
        }
    }

    public set(settings) {
        for (let key in this) {
            if (settings.hasOwnProperty(key)) {
                switch (typeof this[key]) {
                    case 'boolean':
                        settings[key] = !!+settings[key];
                        break;
                    case 'number':
                        settings[key] = ~~settings[key];
                        break;
                    case 'string':
                        settings[key] = `${settings[key]}`;
                        break;
                }

                this[key] = settings[key];
            }
        }
    }
}

export default Settings;
