import {ensureDirSync, existsSync, writeFileSync} from 'fs-extra';
import {dirname, join} from 'path';
import {updatedDiff} from "deep-object-diff";

class Config implements ProxyHandler<{}> {

    private _main = {};

    private _origin = {};

    private _configPath: string;

    private _configDir: string;

    public constructor(configPath: string, configDir: string) {
        if (existsSync(configPath)) {
            this._main = require(configPath);
        }

        this._configPath = configPath;
        this._configDir = configDir;
    }

    public get(target: Config, property: string) {
        let config = this._main[property] || {};
        let part = join(this._configDir, `${property}.js`);

        if (existsSync(part)) {
            this._origin[property] || (this._origin[property] = require(part));

            if (Object.keys(config).length) {
                config = Object.assign(this._origin[property], config);
            } else {
                config = this._origin[property];
            }
        } else if (!Object.keys(config).length) {
            throw new Error(`Configuration property ${property} not found`);
        }

        return config;
    }

    set(target: Config, property: string, value: any) {
        let part = join(this._configDir, `${property}.js`);
        let diff;

        if (existsSync(part)) {
            diff = updatedDiff(this._origin[property] || (this._origin[property] = require(part)), value);
        } else {
            throw new Error(`Configuration property ${property} not found`);
        }

        this._main[property] = diff;

        let dir = dirname(this._configPath);

        if (!existsSync(dir)) {
            ensureDirSync(dir);
        }

        writeFileSync(this._configPath, JSON.stringify(this._main, null, "\t"));

        return true;
    }
}

export default Config;
