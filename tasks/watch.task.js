const gulp = require('gulp');

gulp.task('watch', () => {
    // Watch .ts files
    gulp.watch('src/**/*.ts', ['typescripts']);

    // Watch .any files
    gulp.watch('src/static/**/*', ['static']);
});
