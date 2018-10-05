import * as chokidar from "chokidar";
import {Server} from "http";
import * as _ from "lodash";
import * as socket from "socket.io";
import Settings from './settings';

const settings = Settings.getInstance();

const dir: string = settings.projectDir;
let isReady: boolean = false;

export default (server: Server) => {
    const io = socket(server);

    io.listen(settings.socketPort);

    const reload = _.throttle(() => {
        io.emit("reload");
    }, 500);

    const reloadCSS = _.throttle(() => {
        io.emit("reload", "css");
    }, 500);


    const watcher = chokidar.watch(dir, {
        ignorePermissionErrors: true,
        ignored: /[\/\\]\./,
        persistent: true,
    });

    watcher.on("ready", () => {
        isReady = true;
    });

    watcher.on("all", (e, file) => {
        if (isReady && (e === "add" || e === "change" || e === "unlink")) {
            if (/(\.scss|.css)$/.test(file)) {
                reloadCSS();
            } else {
                reload();
            }
        }
    });
};
