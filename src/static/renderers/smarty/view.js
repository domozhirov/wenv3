const config = require('./../libs/config');
const _ = require('koa-route');
const fs = require('co-fs-extra');
const exec = require('sync-exec');
const path = require('path');
const cookie = require('cookie');
const php = require('../libs/php');
const url = require('url');

const dir = path.join(process.cwd(), '/');
const webl = path.join(__dirname, '../');
const index = path.join(webl, '/bin/webl.php');

module.exports = _.all(/.+\.(htm|html|tpl)(\?.*)?/, async (ctx, next) => {
    let file  = ctx.request.path.replace(/\/+$/, '');
    let type  = /htm|html|tpl/g.exec(file);
    let query = '';

    if (type !== null) {
        query = file.slice(type.index + type[0].length, file.length);
        file  = file.replace(query, '');
    }

    let dirPath = file.match(/^(.+)\/([^\/]+)$/);

    let params = {
        path: `${config.projectDir}${file}`,
        file: file,
        query: query,
        dir: dirPath ? dirPath[1] : '',
        config: config,
        _GET: ctx.request.query,
        _POST: ctx.request.body,
        _COOKIE: cookie.parse(ctx.request.headers.cookie || '')
    };

    let exe = await php;

    let data = JSON.stringify(params);

    let body = exec(`${exe} ${index} '${data}'`);

    if (body.stderr) {
        throw new Error(body.stderr);
    }

    body = body.stdout;

    if (body.indexOf('Content-type: image/png') !== -1) {
        body = body.replace('Content-type: image/png', '');
        body = new Buffer(body, 'base64');

        ctx.type = 'image/png';
    } else {
        body = `${body}${config.live ? config.liveSnippet : ''}`;
    }

    ctx.body = body;

    if (ctx.status === 404) ctx.status = 200;
});