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
