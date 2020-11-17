# Bounce
bounce: (element)->
	anim
		targets:	element
		scale:		1.2
		duration:	200
		direction:	'alternate'
	this # chain
