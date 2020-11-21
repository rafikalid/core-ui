###*
 * Core UI framework
###
<% var Core= true; %>
do ->
	'use strict'

	#=include _const.coffee
	#=include _utils.coffee

	# INCLUDE EXTERNALIZED LIBS
	#==========================
	#=include ../../../await-ajax/assets/_core-body.coffee
	#=include ../../../fast-lru/assets/_core-body.coffee
	#=include ../../../core-date/assets/_core-body.coffee
	#=include ../../../core-event-emitter/assets/_core-body.coffee
	#=include ../../../core-router/assets/_core-body.coffee
	#=include ../../../core-string/assets/_core-body.coffee
	#=include ../../../js-component/assets/_core-body.coffee

	# BODY
	#==========================
	#=include body/**/_*.coffee
	#=include dom-operations/_main.coffee

	# Main object
	#==========================
	Core=
		version: '<%-version %>'
		html: null # Store basic components
		# INCLUDE EXTERNALIZED LIBS INTERFACES
		#=include ../../../await-ajax/assets/_core-interface.coffee
		#=include ../../../fast-lru/assets/_core-interface.coffee
		#=include ../../../core-date/assets/_core-interface.coffee
		#=include ../../../core-event-emitter/assets/_core-interface.coffee
		#=include ../../../core-router/assets/_core-interface.coffee
		#=include ../../../core-string/assets/_core-interface.coffee
		#=include ../../../js-component/assets/_core-interface.coffee

		# INTERNAL LIBS
		#=include interfaces/**/_*.coffee

	# HTML COMPONENTS
	#==========================
	```
	#=include ../../tmp/components.js
	#=include ../js-libs/**/*.js
	```
	#interface
	window.Core= Core
	# Re-init on load
	_runOnLoad Core.init.bind Core, document
	# Init document
	# Core.init(document)
	return
