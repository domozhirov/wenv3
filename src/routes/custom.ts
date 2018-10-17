import {Context} from "koa";

export = async (ctx: Context, next: () => Promise<any>) => {
    await next();
}
