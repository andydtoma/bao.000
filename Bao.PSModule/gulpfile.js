/// <binding AfterBuild='scripts' />
// include plug-ins
var gulp = require('gulp');
var concat = require('gulp-concat');
var del = require('del');

var config = {
    //Include all js files but exclude any min.js files
    src: ['**/*.ps1', '!**/*.tests.ps1'],
    regions: ['**']
}

//delete the output file(s)
gulp.task('clean', function () {
    //del is an async function and not a gulp plugin (just standard nodejs)
    //It returns a promise, so make sure you return that from this task function
    //  so gulp knows when the delete is complete
    return del(['*.psm1']);
});

// Combine and minify all files from the app folder
// This tasks depends on the clean task which means gulp will ensure that the 
// Clean task is completed before running the scripts task.
gulp.task('scripts', ['clean'], function () {

    return gulp.src(config.src)
      .pipe(concat('Bao.PSModule.psm1'))
      .pipe(gulp.dest('.'));
});

//Set a default tasks
gulp.task('default', ['scripts'], function () { });

gulp.task('copy-to-all', function () {
    return gulp.src(['**/'])
    .pipe(gulp.dest('obj/wwwroot'));
});
