# Stop active animations
stop: ()->
	try
		for element in @_elements
			anim.finish() for anim in element.getAnimations()
	catch error
		Core.fatalError 'ANIMATION', error
	this # chain
# Animate
animate: (keyframes, options)->
	try
		elements= @_elements
		options= _assign {duration: Core.ANIM_FAST, easing: 'ease', fill: 'forwards'}, options
		if elements.length is 1
			result= elements[0].animate keyframes, options
		else
			result= []
			for element in @_elements
				result.push element.animate keyframes, options
			result= new _AnimWrapper(result)
	catch error
		Core.fatalError 'ANIMATION', error
	return result


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

# buzzOut
buzzOut: (options)->
	@animate [
		{transform: 'translateX(3px) rotate(2deg)', offset: 0.1}
		{transform: 'translateX(-3px) rotate(-2deg)', offset: 0.2}
		{transform: 'translateX(3px) rotate(2deg)', offset: 0.3}
		{transform: 'translateX(-3px) rotate(-2deg)', offset: 0.4}
		{transform: 'translateX(2px) rotate(1deg)', offset: 0.5}
		{transform: 'translateX(-2px) rotate(-1deg)', offset: 0.6}
		{transform: 'translateX(2px) rotate(1deg)', offset: 0.7}
		{transform: 'translateX(-2px) rotate(-1deg)', offset: 0.8}
		{transform: 'translateX(1px) rotate(0)', offset: 0.9}
		{transform: 'translateX(-1px) rotate(0)', offset: 1}
		], options
