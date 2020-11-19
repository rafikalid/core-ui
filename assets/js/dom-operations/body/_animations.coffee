# Slide down element
_slideDown= (element, options)->
	element[HIDDEN_SYMB]= no	# flag: element is visible
	element.style.removeProperty 'height'
	element.classList.remove 'h'
	size= element.offsetHeight
	args=
		targets:	element
		height:		[0, size]
		duration:	200
		easing:		'easeOutCirc'
		complete: ->
			element.style.removeProperty 'height'
			return
	_assign args, options if options
	anime args
	return

# Slideup
_slideUp= (element, options)->
	element[HIDDEN_SYMB]= yes	# flag: element is hidden
	args=
		targets:	element
		height:		0
		duration:	200
		easing:		'easeOutCirc'
		complete: ->
			element.classList.add 'h'
			return
	_assign args, options if options
	anime args
	return
