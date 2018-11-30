import Config from '../core/config';
import {homedir} from 'os';
import {join} from 'path';

const configPath = `${homedir()}/.wenv3/settings.json`;
const configDir = join(__dirname, `../conf.d/`);
const config = new Config(configPath, configDir);

export default new Proxy(<any>{}, config);
