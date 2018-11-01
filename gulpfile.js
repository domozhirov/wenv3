const gulp = require('gulp');
const ts = require('gulp-typescript');
const argv = require('yargs').argv;

require('./tasks/clean.task');
require('./tasks/typescripts.task');
require('./tasks/static.task');
require('./tasks/watch.task');

gulp.task('default', ['clean'], () => {
    const args = ['typescripts', 'static'];

    if (argv.watch) {
        args.push('watch');
    }

    gulp.start.apply(gulp, args);
});
