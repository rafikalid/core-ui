# Stop active animations
stop: ()->
	anime.remove @_elements
	this # chain
# Slide down
slideDown: ()->
	_each @_elements, _slideDown
	this # chain
# slideup
slideUp: ()->
	_each @_elements, _slideUp
	this # chain
# Slide toggle
slideToggle: (isDown)->
	# Slide down
	if isDown
		_each @_elements, _slideDown
	else if isDown is false
		_each @_elements, _slideUp
	else
		_each @_elements, (element)->
			isHidden= element[HIDDEN_SYMB]
			unless isHidden?
				isHidden= !element.offsetHeight
			# Slide down
			if isHidden
				_slideDown element
			# Slide up
			else
				_slideUp element
			return
	this # chain
# Bounce
bounce: ->
	anime
		targets:	@_elements
		scale:		[1, 1.1, 1]
		duration:	300
	this # chain
