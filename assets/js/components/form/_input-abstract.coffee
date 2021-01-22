###*
 * Abstract input
###
Component.defineInit 'input-abstract', class InputAbstract extends Component
	constructor: (element)->
		super element
		@_raf= null # requestAnimationFrame id
		return

	###* Render component ###
	setElement: (element)->
		# Call super method
		super.setElement element
		@_attributes= null	# Element attributes
		@_attrs= null		# Private attributes
		# Load attributes
		@_loadAttributes()
		# Reload HTML
		@reload()
		this # chain

	###* Set attributes ###
	setAttributes: (attributes)->
		throw new Error "Illegal arguments" unless arguments.length is 1 and typeof attributes is 'object'
		# Attributes
		@_setAttributes _assign (@_attributes or {}), attributes
		@reload() # reload component HTML
		this # chain
	###* @private Set attributes ###
	_setAttributes: (attributes)->
		@_attributes= attributes
		@value= attributes.value # update value
		return
	### GETTERS ###
	```
	get name(){return this._attributes.name; }
	get defaultValue(){return this._getInput().defaultValue; }
	get readOnly(){return this._attrs.readOnly; }
	get min(){return this._attrs.min; }
	get max(){return this._attrs.max; }
	```
	###* SETTERS ###
	```
	set name(v){ this._getInput().name= v; }
	set min(v){
		var attrs= this._attrs;
		attrs.min= v;
		this._getInput().min= v;
		this.value= attrs.value;
	}
	set max(v){
		var attrs= this._attrs;
		attrs.max= v;
		this._getInput().max= v;
		this.value= attrs.value;
	}
	```
	###* get internal input ###
	_getInput: ->
		input= @element.firstElementChild
		unless input.tagName is 'INPUT'
			throw new Error "First element should be a hidden input!"
		return input

	###* Load attributes ###
	_getAttributes: (ignoreList)->
		# attributes
		attrs= {}
		if ignoreList and ignoreList.length
			for n in @element.attributes
				nm= n.name
				attrs[nm]= n.value unless nm in ignoreList
		else
			attrs[n.name]= n.value for n in @element.attributes
		return attrs

	###* When value selected and validated by the form-control ###
	_done: ->
		element= @element
		# Call method from parent component
		if doneCb= @_attrs.done
			args= doneCb.trim().split /\s+/
			comp= _closestComponent(element.parentNode)
			if doneCb= comp[args[0]]
				doneCb.call comp, {currentTarget: element, target: element, realTarget: element, component: this}, args
			else
				Core.fatalError 'INPUT', "Missing method '#{args[0]}' on component: #{comp.tagName}"
		# check if inside popup
		else
			while element
				if popopArr= element[POPUP_SYMB]
					strValue= @toString()
					for popup in popopArr
						try
							popup.done this
						catch err
							Core.fatalError 'POPUP', err
					break
				element= element.parentElement
		return

	###* TO String ###
	toString: -> @value.toString()
	```
	get strValue(){return this.value.toString()}
	```
