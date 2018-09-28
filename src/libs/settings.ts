import * as fs from 'fs-extra';
import {homedir} from 'os';

enum Renderer {
    smarty = 'smarty',
    none = 'none'
}

class Settings {
    public static path: string = `${homedir}/.wenv3`

    public static instance: Settings;

    public port: number = 3000;

    public socketPort: number = 3001;

    public projectDir: string = `${homedir}/`;

    public renderer: Renderer = Renderer.none;

    public live: boolean = true;

    public static getInstance(): Settings {
        if (!Settings.instance) {
            Settings.instance = new Settings;
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
                this[key] = settings[key];
            }
        }
    }
}

export default Settings;
