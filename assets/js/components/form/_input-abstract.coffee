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
		@_attr= null		# Private attributes
		# Load attributes
		@_loadAttributes()
		# Reload HTML
		@reload()
		this # chain

	### GETTERS ###
	```
	get name(){return this._attributes.name; }
	get value(){return this._attrs.value; }
	get defaultValue(){return this._attributes.value; }
	get readOnly(){return this._attrs.readOnly; }
	get min(){return this._attrs.min; }
	get max(){return this._attrs.max; }
	```
	###* SETTERS ###
	```
	set name(v){
		this._attributes.name= v;
		this._getInput().name= v;
	}
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
