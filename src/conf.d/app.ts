import {join} from "path";

export = {
    routes: {
        body: join(__dirname, `../routes/body`),
        error: join(__dirname, `../routes/error`),
        custom: {},
        live: join(__dirname, `../routes/live`),
        sass: join(__dirname, `../routes/sass`),
        list: join(__dirname, `../routes/list`),
        view: join(__dirname, `../routes/view`),
        static: join(__dirname, `../routes/static`),
    },
}
