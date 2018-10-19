import {join} from "path";

export = {
    tray: [
        {
            title: "Start",
            tooltip: "Start",
            checked: false,
            enabled: true
        },
        {
            title: "Restart",
            tooltip: "Restart",
            checked: false,
            enabled: false
        },
        {
            title: "Stop",
            tooltip: "Stop",
            checked: false,
            enabled: false
        },
        {
            title: "Settings",
            tooltip: "Settings",
            checked: false,
            enabled: true
        }, {
            title: "Exit",
            tooltip: "Exit",
            checked: false,
            enabled: true
        }
    ],

    routes: {
        body: join(__dirname, `../routes/body`),
        error: join(__dirname, `../routes/error`),
        custom: {},
        list: join(__dirname, `../routes/list`),
        static: join(__dirname, `../routes/static`),
    },

    plugins: {}
}