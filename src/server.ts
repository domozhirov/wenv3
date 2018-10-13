// import * as path from 'path'
// import * as Koa from "koa";
// import * as koaBody  from "koa-body";
// import views = require('koa-views')
// import socket from "./core/socket";
// import cache from "./routes/cache";
// import error from "./routes/error";
// // import index from "./routes/index";
// import list from "./routes/list";
// import live from "./routes/live";
// import sass from "./routes/sass";
// import stat from "./routes/static";
// import view from "./routes/view";
// import settingsRoute from "./routes/settings";
// import Settings from './core/settings';
//
// const settings = Settings.getInstance();
// const app: Koa = new Koa();
//
// app.use(views(path.join(__dirname, 'static/views'), {
//     map: {
//         html: 'underscore'
//     }
// }));
//
// app.use(koaBody());
// app.use(error);
// // app.use(index);
// app.use(live);
// app.use(sass);
// app.use(list);
// app.use(view);
// app.use(settingsRoute);
// app.use(stat);
// app.use(cache);
//
// const server = app.listen(settings.port, "localhost", () => {
//     const host = `http://127.0.0.1:${settings.port}`;
//
//     // TODO: Logger
// });
//
// if (settings.live) {
//     socket(server);
// }
//
// export = app;
