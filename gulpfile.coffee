gulp = require "gulp"
gutil = require "gulp-util"

gulp.task "copy", ->
  copy = ->
    gulp.src "src/index.html"
    .pipe gulp.dest "public"
  if @seq[@seq.length - 1] is "watch"
    do copy
    gulp.watch ["src/index.html"], ->
      do copy
  else
    do copy

browserSync = require("browser-sync").create()

stylus = require 'gulp-stylus'
dookie = require "dookie-css"
rupture = require "rupture"


gulp.task "stylus", ->
  stylusDo = ->
    gulp.src "src/index.styl"
      .pipe stylus
        use: [rupture(implicit:true), dookie.css()]
        paths:[__dirname, "#{__dirname}/node_modules"]
        "include css": true
        # "compress": true
      .pipe gulp.dest "public"
      .pipe browserSync.reload stream: true
  if @seq[@seq.length - 1] is "watch"
    do stylusDo
    gulp.watch ["src/index.styl", "src/_settings.styl", "src/style/*.styl"], ->
      do stylusDo
  else
    do stylusDo



browserify = require "browserify"
watchify = require "watchify"
source = require "vinyl-source-stream"
pkg = require "#{__dirname}/package.json"
vendor = (dep for dep of pkg.dependencies)



gulp.task "bundle-vendor", (next)->

  vendorBundler = browserify()
  vendorBundler.require vendor
  vendorBundler.bundle()
  .pipe source "vendor.js"
  .pipe gulp.dest "public"



gulp.task "bundle", (next)->
  watchify.args.extensions = [".coffee", ".cjsx"]
  watchify.args.paths = ["./node_modules", "./src"]
  watchify.args.fullPaths = no
  watchify.args.debug = yes

  bundler = browserify "src/scripts/index.coffee", watchify.args
  #TODO add it to split files by modules https://github.com/substack/factor-bundle
  bundler.transform "coffee-reactify"

  bundle = ->
    bundler.bundle()
    .on "error", (err)->
      gutil.log err.message
      browserSync.notify "Browserify Error!"
      @emit "end"
    .pipe source "index.js"
    .pipe gulp.dest "./public"
    .pipe browserSync.stream once: true
  if @seq[@seq.length - 1] is "watch"
    bundler.external vendor #excluding vendor files to not rebuild each time
    bundler = watchify bundler
    bundler.on "update", bundle
  else
    bundler.transform global: yes, sourcemap: no, "uglifyify"
  do bundle

gulp.task "watch", ["bundle", "bundle-vendor", "copy", "stylus"], (next)->
  browserSync.init
    server:
      baseDir: "./public"
      routes: "/images": "src/images"
    open: false
  #next()

#SWitch to IO.js https://gist.github.com/phelma/ce4eeeedb8fb9a9e8e63

#TODO move to test file
Cucumber = require "cucumber"
gulp.task "test", (next)->
  argv = ["node", "cucumber-js"]
  #argv.push "features" #folder of tests
  argv.push "--coffee" #CoffeeScript step definition snippets
  #argv.push "-f pretty" type of format
  Cucumber.Cli(argv).run (succeeded)->
    console.log "Cucumber callback"
    do next if succeeded
