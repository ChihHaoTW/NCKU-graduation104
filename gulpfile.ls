require! <[gulp main-bower-files gulp-concat gulp-filter gulp-jade gulp-livereload gulp-livescript gulp-markdown gulp-print gulp-rename gulp-stylus gulp-util streamqueue tiny-lr]>
require! \fs

port = parseInt(fs.readFileSync('port'));

tiny-lr-port = 35729

paths =
  app: \app
  build: \public

tiny-lr-server = tiny-lr!
livereload = -> gulp-livereload tiny-lr-server

gulp.task \json ->
  gulp.src [paths.app+\/comment.json, paths.app+\/event.json]
    .pipe gulp.dest paths.build

gulp.task \css ->
  css-bower = gulp.src main-bower-files! .pipe gulp-filter \**/*.css
  css = gulp.src [paths.app+\/**/*.css paths.app+\!/**/reset.css]
  styl-app = gulp.src paths.app+\/**/*.styl .pipe gulp-stylus!
  streamqueue {+objectMode}
    .done css-bower, styl-app, css
    .pipe gulp-concat \app.css
    .pipe gulp.dest paths.build
    .pipe livereload!
  gulp.src paths.app+\/**/reset.css
    .pipe gulp.dest paths.build
    .pipe livereload!

gulp.task \html ->
  html = gulp.src paths.app+\/**/*.html
  jade = gulp.src paths.app+\/**/*.jade .pipe gulp-jade {+pretty}
  streamqueue {+objectMode}
    .done html, jade
    .pipe gulp.dest paths.build
    .pipe livereload!
  gulp.src \README.md .pipe gulp-markdown!
    .pipe gulp.dest paths.build
    .pipe livereload!

gulp.task \js ->
  js = gulp.src paths.app+\/**/*.js
  js-bower = gulp.src main-bower-files! .pipe gulp-filter \*.js
  ls-app = gulp.src paths.app+\/**/*.ls .pipe gulp-livescript {+bare}
  streamqueue {+objectMode}
    .done js-bower, ls-app, js
    .pipe gulp-concat \app.js
    .pipe gulp.dest paths.build
    .pipe livereload!

gulp.task \res ->
  gulp.src [paths.app+\/res/**, paths.app+\!/res/fonts/**]
    .pipe gulp.dest paths.build+\/res
  gulp.src paths.app+\/res/fonts/**
    .pipe gulp.dest paths.build+\/res/fonts
  gulp.src main-bower-files!, { base: \./bower_components } .pipe gulp-filter \**/fonts/*
    .pipe gulp-rename -> it.dirname = ''
    .pipe gulp.dest paths.build+\/fonts

gulp.task \server ->
  require! \express
  express-server = express!
  express-server.use require(\connect-livereload)!
  routes = require \./routes.ls
  routes.init express-server
  routes.getEvent!
  routes.sendReply!
  express-server.use express.static paths.build
  express-server.listen port
  gulp-util.log "Listening on port: #port"

gulp.task \watch <[build server]> ->
  tiny-lr-server.listen tiny-lr-port, ->
    return gulp-util.log it if it
  gulp.watch [paths.app+\/**/*.styl,paths.app+\/**/*.css], <[css]>
  gulp.watch [paths.app+\/**/*.html,paths.app+\/**/*.jade,\README.md], <[html]>
  gulp.watch [paths.app+\/**/*.ls,paths.app+\/**/*.js], <[js]>
  gulp.watch [paths.app+\/comment.json,paths.app+\event.json], <[json]>

gulp.task \build <[css html js res json]>
gulp.task \default <[watch]>

# vi:et:ft=ls:nowrap:sw=2:ts=2
