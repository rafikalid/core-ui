###*
 * INPUT RANGE
###
Component.defineInit 'input-range', class InputRange extends Component
	constructor: (element)->
		super element
		@_raf= null # requestAnimationFrame id
		return
	###* Render component ###
	setElement: (element)->
		# Call super method
		super.setElement element
		# Load attributes
		@_loadAttributes()
		# Reload HTML
		@_reload()
		this # chain
	###* @private Get attributes ###
	_loadAttributes: ->
		element= @element
		value= _float element.getAttribute('value'), 0
		@_attrs=
			name:	element.getAttribute('name')
			min:	_float element.getAttribute('min'), 0
			max:	_float element.getAttribute('max'), 100
			value:			value
			tmpValue:		value	# temp value when draging
			defaultValue:	value
			step:	_float element.getAttribute('step'), null
			_bound: null # "progress" bound, use when drag
		return
	###* @private Reload component html ###
	_reload: ->
		# Check values
		@_fixValues()
		# render HTML
		requestAnimationFrame (t)=>
			@element.innerHTML= @_getHTML()
			return
		return
	###* Get component html ###
	_getHTML: -> Core.html.inputRange @_attrs

	### GETTERS ###
	```
	get name(){return this._attrs.name; }
	get min(){return this._attrs.min; }
	get max(){return this._attrs.max; }
	get value(){return this._attrs.value; }
	get step(){return this._attrs.step; }
	get tmpValue(){return this._attrs.tmpValue; }
	get defaultValue(){return this._attrs.defaultValue; }
	```
	###* Set value ###
	```
	set value(v){
		var self= this;
		var attrs= self._attrs;
		attrs.value= v;
		// # Cancel previous animation frame request
		if(self._raf) cancelAnimationFrame(self._raf);
		// # Do it next animation frame
		self._raf= requestAnimationFrame(function(t){
			self._raf= null
			self._fixValues();
			var element= self.element
			self._getInput().value= attrs.value;
			self._setTrackWidth(attrs.track);
			self.emit('change');
		});
	}
	set name(v){
		this._attrs.name= v;
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
	set step(v){
		var attrs= this._attrs;
		attrs.step= v;
		this._reload();
	}
	```
	###* get internal input ###
	_getInput: -> this.element.getElementsByTagName('input')[0]
	_setTrackWidth: (w)->
		@element.getElementsByClassName('track')[0].style.width= w+'%'
		return

	###* Set track position and temp value ###
	_setTrack: (p)->
		attrs= @_attrs
		if p < 0 then p= 0
		else if p > 100 then p= 100
		attrs.track= p
		attrs.tmpValue= p * (attrs.max - attrs.min) / 100 + attrs.min
		return

	###* when click on the track: select value ###
	select: (event, args)->
		target= event.currentTarget
		bound= target.getBoundingClientRect()
		p= Math.round((event.x - bound.left) * 100 / (bound.width or 1))

		# value
		attrs= @_attrs
		# attrs.originalTrack= p
		@_setTrack p
		@value= attrs.tmpValue
		return

	###* Fix values ###
	_fixValues: ->
		attrs=	@_attrs
		step=	attrs.step
		min=	attrs.min
		max=	attrs.max
		value=	attrs.value
		# min/max
		throw new Error "MAX is less than MIN!" if max < min
		# Value
		if value < min then value= min
		else if value > max then value= max
		# Stepper
		if step > 0
			value= attrs.value= step * Math.round( (value - min) / step ) + min
		# Track
		attrs.track= (value - min) * 100 / (max - min)
		return
	# Drag
	drag: (event, args)->
		target= event.realTarget
		attrs= @_attrs
		element= @element
		switch event.type
			when 'movestart'
				attrs._bound= target.closest('.progress').getBoundingClientRect()
				element.classList.add 'no-anim'
			when 'move'
				self= this
				cancelAnimationFrame self._raf if self._raf
				self._raf= requestAnimationFrame (t)->
					# Calc track position
					bound= attrs._bound
					if bound.width > 0
						p= Math.round((event.x - bound.left) * 100 / bound.width)
						# set value
						self._setTrack p
						self._setTrackWidth(p)
						self.emit 'changing'
					return
			when 'moveend'
				element.classList.remove 'no-anim'
				@value= attrs.tmpValue
			else
				throw new Error 'Illegal use'
		return
