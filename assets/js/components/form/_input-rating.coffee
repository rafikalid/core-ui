###*
 * INPUT RATING
###
Component.defineInit 'input-rating', class InputRating extends InputRange
	constructor: (element)->
		super element
		element= @element # case when element is string
		# Selected icon
		@_icon= element.innerHTML
		# State
		stateClasses= []
		stateValues= []
		if states= element.getAttribute 'states'
			states= states.trim().split /[\s,]+/
			for v, i in states by 2
				stateValues.push parseFloat v
				stateClasses.push states[i+1]
		@_stateValues= stateValues
		@_stateClasses= stateClasses
		@_currentState= null
		@_fixState()
		element.classList.add c if c= @_currentState
		return
	###* Get component html ###
	_getHTML: -> Core.html.inputRating {input: @_attrs, icon: @_icon, state: @_currentState}
	###* @private Get attributes ###
	_loadAttributes: ->
		element= @element
		value= _float element.getAttribute('value'), 0
		@_attrs=
			name:	element.getAttribute('name')
			min:	_float element.getAttribute('min'), 0
			max:	_float element.getAttribute('max'), 5
			value:			value
			tmpValue:		value	# temp value when draging
			defaultValue:	value
			step:	_float element.getAttribute('step'), null
			_bound: null # "progress" bound, use when drag
		return
	###* Fix values ###
	_fixValues: ->
		attrs=	@_attrs
		attrs.max= Math.round attrs.max
		attrs.min= Math.round attrs.min
		super._fixValues()
		# Fix state
		@_fixState() if @_stateClasses
		return
	###* Fix state ###
	_fixState: ->
		value= @_attrs.value
		stateClasses= @_stateClasses
		if stateClasses.length
			for v, i in @_stateValues
				break if value < v
				currentState= stateClasses[i]
		@_currentState= currentState
		return
	###* Set track width ###
	_setTrackWidth: (w)->
		element= @element
		element.getElementsByClassName('track')[0].style.width= w+'%'
		cl= element.classList
		cl.remove.apply cl, @_stateClasses
		cl.add c if c= @_currentState
		return
