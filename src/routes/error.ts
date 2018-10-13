import {Context} from "koa";

export = async (ctx: Context, next: () => Promise<any>) => {
    try {
        await next();
    } catch (err) {
        ctx.body = `<h1>Error</h1>
            <pre> ${err} </pre>`;

        ctx.status = 404;
    }
};
