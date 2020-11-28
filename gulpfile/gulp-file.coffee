###*
 * Gulp file
###
# GridfwGulp= require '../gulp-gridfw'
GridfwGulp= require 'gulp-gridfw'
Gulp= require 'gulp'
PKG= require './package.json'

#=include _compile-js.coffee

compiler= new GridfwGulp Gulp,
	isProd: <%- isProd %>
	delay: 500

params=
	version: PKG.version

# Other compilers
module.exports= compiler
	# .js
	# 	name:	'API>> Compile Coffee files'
	# 	src:	'assets/js/ui-comp.coffee'
	# 	dest:	'build/'
	# 	watch:	'assets/js/**/*.coffee'
	# 	data:	params
	# 	# babel:	<%- isProd %>
	###* Copy static files ###
	# .copy
	# 	name:	'API>> Copy static files'
	# 	src:	'assets/lib/**/*'
	# 	dest:	'build/'
	###*
	 * COMPILE API FILES
	###
	.addTask 'API>> Compile Coffee files',
		['assets/js/**/*.coffee', 'assets/html-components/**/*.pug'],
		Gulp.series htmlComponentsTask, compileCoreJS
	# Compile sass
	.sass
		name:	'API>> Compile Sass files'
		src:	'assets/css/ui-comp.sass'
		dest:	'build/'
		watch:	['assets/css/**/*.sass']
	# Compile theme files
	.sass
		name:	'API>> Compile Theme files'
		src:	'assets/themes/[^_]*.sass'
		dest:	'build/themes/'
		watch:	['assets/themes/**/*.sass']
