import {existsSync, readFileSync, writeFileSync} from 'fs-extra';
import {join, dirname} from 'path';

class Config implements ProxyHandler<{}> {

    private _main = {};

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
        let part   = join(this._configDir, `${property}.js`);

        if (existsSync(part)) {
            if (Object.keys(config).length) {
                config = Object.assign(config, require(part));
            } else {
                config = require(part);
            }
        } else if (!Object.keys(config).length) {
            throw new Error(`Configuration property ${property} not found`);
        }

        return config;
    }
}

export default Config;
