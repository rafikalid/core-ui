###*
 * INPUT RANGE
###
Component.defineInit 'input-range', class InputRange extends InputAbstract
	###* @private Get attributes ###
	_loadAttributes: ->
		@_setAttributes @_getAttributes()
		return
	###* @private Set attributes ###
	_setAttributes: (attributes)->
		@_attributes= attributes
		# attributes
		value= _float attributes.value, 0
		@_attrs=
			value:			value
			tmpValue:		value	# temp value when draging
			readonly:		!!attributes.readonly
			#
			min:			_float attributes.min, 0
			max:			_float attributes.max, 100
			step:			_float attributes.step, null
			_bound: 		null # "progress" bound, use when drag
		return
	###* @private Reload component html ###
	reload: ->
		# Check values
		@_fixValues()
		# render HTML
		requestAnimationFrame (t)=>
			@element.innerHTML= @_getHTML()
			@_getInput[INPUT_COMPONENT_SYMB]= this # link hidden input to this component
			return
		return
	###* Get component html ###
	_getHTML: ->
		attrs= @_attrs
		inputAttrs= _assign {}, @_attributes
		inputAttrs.value= attrs.value
		inputAttrs.min= attrs.min
		inputAttrs.max= attrs.max
		Core.html.inputRange input: inputAttrs, attrs: attrs

	### GETTERS ###
	```
	get step(){return this._attrs.step; }
	get tmpValue(){return this._attrs.tmpValue; }
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
	set step(v){
		var attrs= this._attrs;
		attrs.step= v;
		this.reload();
	}
	```
	###* get track ###
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
		return if @_attrs.readonly # do not exec if readonly
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
		return if @_attrs.readonly # do not exec if readonly
		attrs= @_attrs
		element= @element
		switch event.type
			when 'movestart'
				attrs._bound= event.currentTarget.getBoundingClientRect()
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
