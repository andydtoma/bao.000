/// <binding AfterBuild='scripts' />
// include plug-ins
var gulp = require('gulp');
var concat = require('gulp-concat');
var del = require('del');
var filelog = require('gulp-filelog');
var fs = require('fs');
var path = require('path');

var config = {
    //Include all js files but exclude any min.js files
    src: ['**/*.ps1', '!**/*.tests.ps1'],
    regions: ['**'],
    obj: './obj',
    reservedDirPattern: /\.vs|bin|obj|node_modules/i
}


function getFolders(dir) {
    return fs.readdirSync(dir)
      .filter(function (file) {
          return fs.statSync(path.join(dir, file)).isDirectory();
      })
    .filter(function (file) {
        return !file.match(config.reservedDirPattern);
    });
}


gulp.task("clean-obj", function () {
    return del(config.obj + '/**/*')
});

gulp.task("compile-regions", function () {
    var folders = getFolders('.');
    return folders.map(function (folder) {
        return gulp.src(folder)
        .pipe(filelog());

    });
});


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

