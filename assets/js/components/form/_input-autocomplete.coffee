###*
 * Autocomplete
###
INPUT_AUTOCOMPLETE_ATTRS= ['uri', 'class']
Component.defineInit 'input-autocomplete', class InputRating extends InputAbstract
	constructor: (element)->
		super element
		return

	###* @private Get attributes ###
	_loadAttributes: ->
		@_setAttributes @_getAttributes(INPUT_AUTOCOMPLETE_ATTRS)
		return

	###* @private Set attributes ###
	_setAttributes: (attributes)->
		@_attributes= attributes
		element= @element
		if uri= element.getAttribute 'uri'
			uri= new URL uri, Core.getBaseURL()
		# attributes
		@_attrs=
			value:		attributes.value
			readonly:	!!attributes.readonly
			className:	element.className
			#
			uri:		uri
		return
	###* Reload component html ###
	reload: ->
		# render HTML
		requestAnimationFrame (t)=>
			@element.innerHTML= @_getHTML()
			input= @_getInput()
			input[INPUT_COMPONENT_SYMB]= this # link hidden input to this component
			# Set input listeners
			input.addEventListener 'keyup', @keyup.bind(this), {passive: yes}
			return
		return
	###* @private Get component html ###
	_getHTML: ->
		Core.html.inputAutocomplete input: @_attributes, attrs: @_attrs

	### GETTERS ###
	```
	get value(){ return this._attrs.value; }
	get uri(){ return this._attrs.uri }
	```
	###* Set value ###
	```
	set value(v){
		this._attrs.value= v;
		this._getInput().value= v;
	}
	set uri(v){
		if(v) v= new URL(v, Core.getBaseURL());
		this._attrs.uri= v
	}
	```

	###* on keyup ###
	keyup: (event)->
		switch event.which
			when 13 # Enter
				return # Apply selected result
			when 27 # ESC
				return # close popup
			when 37 # Arrow left
				return # ignore
			when 38 # Arrow up
				return # seek up in the list
			when 39 # Arrow right
				return # ignore
			when 40 # Arrow down
				return # seek down in the list
			else
				@_find event.target.value
		return
	###* find result ###
	_find: (q)->
		console.log 'find: ', q
		return
