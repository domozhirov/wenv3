import {createServer} from "net";

// https://gist.github.com/sphvn/dcdf9d683458f879f593
export function traverse(o: any, fn: (prop: string, value: any, obj: any) => void) {
    for (const i in o) {
        if (o[i] !== null && typeof(o[i]) === 'object') {
            traverse(o[i], fn);
        } else {
            fn.apply(null, [i, o[i], o]);
        }
    }
}

export function getPort() {
    const server = createServer();
    let portRange = 45033;

    return (async function callback() {
        const port = portRange;

        portRange += 1;

        return new Promise(resolve => {
            server.listen(port, () =>{
                server.once('close', () => {
                    resolve(port);
                });

                server.close()
            });

            server.on('error', () => {
                resolve(callback())
            });
        });
    })();
}
