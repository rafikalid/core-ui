
# COMPILRE HTML COMPONENTS
Include=		require 'gulp-include'
GulpCoffeescript= require 'gulp-coffeescript'
GulpClone=		require 'gulp-clone'
Rename=			require 'gulp-rename'
EventStream=	require 'event-stream'
htmlComponentsTask= ->
	Gulp.src 'assets/html-components/**/*.pug', nodir: yes
		.pipe compiler.onError()
		.pipe compiler.precompile(params)
		.pipe compiler.pugPipeCompiler(no, {globals: ['i18n', 'window', 'Core'], inlineRuntimeFunctions: no})
		.pipe compiler.joinComponents {target:'components.js', template: 'Core.html'}
		# .pipe compiler.minifyJS()
		.pipe Gulp.dest 'tmp/'
compileCoreJS= ->
	dest= 'build/'
	glp= Gulp.src 'assets/js/core-ui.coffee', nodir: yes
		.pipe compiler.onError()
		.pipe Include hardFail: true
		.pipe compiler.precompile(params)
		.pipe GulpCoffeescript bare: true
	# Babel
	if <%-isProd %>
		glp1= glp.pipe GulpClone()
			.pipe compiler.minifyJS()
			.pipe Gulp.dest dest
		glp2= glp.pipe GulpClone()
			.pipe compiler.babel()
			.pipe compiler.minifyJS()
			.pipe Rename (path)->
				path.basename += '-babel'
				return
			.pipe Gulp.dest dest
		result= EventStream.merge [glp1, glp2]
	else
		result= glp.pipe compiler.minifyJS()
			.pipe Gulp.dest dest
	return result
