import * as fs from "fs-extra";
import * as path from "path";
import {Request, Response} from "request";
import * as request from "request";
import * as url from "url";

export default async (file: string): Promise<any> => {
    const local: string = path.join(__dirname, "../var/cache", file);

    if (fs.existsSync(local)) {
        return Promise.resolve(local);
    }

    const remote: string = url.resolve("http://dumper.demojs0.oml.ru/", file);

    let loaded;

    try {
        loaded = await load(remote, local);
    } catch (e) {
        loaded = false;
    }

    if (loaded) {
        return await Promise.resolve(local);
    }
};

const load = (from: string, to: string) => {
    return new Promise((resolve, reject) => {
        const stream: Request = request.get(from);

        stream.on("error", reject);
        stream.on("response", (response: Response) => {
            if (response.statusCode !== 200) {
                reject();
                stream.abort();
                return;
            }

            fs.ensureDirSync(path.dirname(to));

            const writeStream = fs.createWriteStream(to);

            writeStream.on("finish", () => {
                resolve(true);
            });

            stream.pipe(writeStream);
        });
    });
};
