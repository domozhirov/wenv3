const gulp = require('gulp');

gulp.task('static', () => {
    gulp.src(['src/static/**/*'])
        .pipe(gulp.dest('dist/static'));
    gulp.src(['package.json'])
        .pipe(gulp.dest('dist/'));
});
