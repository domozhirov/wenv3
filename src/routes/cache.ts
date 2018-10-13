import {Context} from "koa";
import * as send from "koa-send";
import cache from "../core/cache";

export default async (ctx: Context, next: () => Promise<any>) => {
    const file = await cache(ctx.request.path, "http://dumper.demojs0.oml.ru/");

    if (file) {
        await send(ctx, file, { root: "/" });
    } else {
        await next();
    }
};
