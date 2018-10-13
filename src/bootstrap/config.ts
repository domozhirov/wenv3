import Config from '../core/config';
import {homedir} from 'os';
import {join} from 'path';

const configPath = join(__dirname, `${homedir}/.wenv3/config.js`);
const configDir = join(__dirname, `static/conf.d/`);

const config = new Proxy(<any>{}, new Config(configPath, configDir));

export default config;
