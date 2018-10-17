const gulp = require('gulp');
const ts = require('gulp-typescript');

require('./tasks/typescripts.task');
require('./tasks/static.task');

gulp.task('default', [], function() {
    gulp.start('typescripts', 'static', 'watch');
});

gulp.task('watch', () => {
    // Watch .ts files
    gulp.watch('src/**/*.ts', ['typescripts']);

    // Watch .any files
    gulp.watch('src/static/**/*', ['static']);
});
