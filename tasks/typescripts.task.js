const gulp = require('gulp');
const ts = require('gulp-typescript');

gulp.task('typescripts', () => {
    gulp.src('src/**/*.ts')
        .pipe(ts({
            target: "es2017",
            module: "commonjs",
            allowJs: false,
            checkJs: false,
            jsx: "react",
            sourceMap: true,
            outDir: "./dist/",
            strict: true,
            noImplicitAny: false,
            moduleResolution: "node",
            baseUrl: "./",
            paths: {},
            experimentalDecorators: true,
            emitDecoratorMetadata: true
        }))
        .pipe(gulp.dest('dist'));
});
