import * as chokidar from "chokidar";
import {Server} from "http";
import * as _ from "lodash";
import * as socket from "socket.io";

let isReady: boolean = false;

export default (server: Server, config) => {
    const io = socket(server);

    io.listen(config.server.socketPort);

    const reload = _.throttle(() => {
        io.emit("reload");
    }, 500);

    const reloadCSS = _.throttle(() => {
        io.emit("reload", "css");
    }, 500);

    const watcher = chokidar.watch(config.server.projectDir, {
        ignorePermissionErrors: true,
        ignored: /[\/\\]\./,
        persistent: true,
    });

    watcher.on("ready", () => {
        isReady = true;
    });

    watcher.on("all", (e, file) => {
        if (config.server.livereload && isReady && (e === "add" || e === "change" || e === "unlink")) {
            if (/(\.scss|.css)$/.test(file)) {
                reloadCSS();
            } else {
                reload();
            }
        }
    });

    server.on('close', () => {
        watcher.close();
        io.close();
    });
};
