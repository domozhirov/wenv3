import config from './bootstrap/config';
import Server from './core/server';
import App from './core/app';

const server = new Server(config);
const app = new App(server, config);

app.run();
