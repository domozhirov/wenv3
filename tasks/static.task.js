const gulp = require('gulp');

gulp.task('static', () => {
    gulp.src(['src/static/**/*'])
        .pipe(gulp.dest('dist/static'));
});
