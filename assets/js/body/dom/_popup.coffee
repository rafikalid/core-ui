###*
 * @param {String}	x, xAlt	-	'top', 'bottom'
 * @param {String}	y	-	'right'
 * @param {String}	popupW	-	'width' or 'height'
 *
 * @example	_popupPositionCalc('top', 'bottom', null, 'width', 'height', element, popup, elementRect, popupRect, 0);
###
_popupPositionCalc= (x, xAlt, y, popupX, popupY, element, popup, elementRect, popupRect, margin)->
	# result
	result=
		position:	null
		top:		null
		bottom:		null
		left:		null
		right:		null
		width:		null
		height:		null
	# Cacl
	mainSpace= elementRect[x]
	altSpace= elementRect[xAlt]
	popupSize= popupRect[popupY]
	availableSpace= mainSpace - margin	# elementRect.top
	isAlterred= no
	if popupSize <= availableSpace
		top= availableSpace - popupSize
	else if mainSpace >= altSpace
		size= availableSpace
		top= 0
	else
		availableSpace= altSpace - margin
		if popupSize <= availableSpace
			topAlt= availableSpace - popupSize
		else
			size=	availableSpace
			topAlt=	0
		isAlterred= yes
	# Position
	pos= if isAlterred then xAlt else x
	result.position= if y then "#{pos}-#{y}" else pos
	result[x]= top
	result[xAlt]= topAlt
	result[popupY]= size
	# x axe
	w= result[popupX]= @size (if popupX is 'width' then innerWidth else innerHeight), popupRect[popupX], elementRect[popupX]
	left= w - elementRect[popupX] # calc popupWidth - elementWidth
	if y
		ay= y
	else
		ay= if popupX is 'width' then 'left' else 'top'
	# Set
	left= elementRect[ay] - left
	left= 0 if left < 0
	result[ay]= left
	return result

### PREDIFINED POSITIONS ###
_POPUP_POS= ['top', 'right', 'bottom', 'left', 'width', 'height']
_POPUP_POSITIONS=
	# TOP
	topLeft:	['top', 'bottom', 'left', 'width', 'height']
	top:		['top', 'bottom', null, 'width', 'height']
	topRight:	['top', 'bottom', 'right', 'width', 'height']
	# BOTTOM
	bottomLeft:	['bottom', 'top', 'left', 'width', 'height']
	bottom:		['bottom', 'top', null, 'width', 'height']
	bottomRight:['bottom', 'top', 'right', 'width', 'height']
	# LEFT
	leftTop:	['left', 'right', 'top', 'height', 'width']
	left:		['left', 'right', 0, 'height', 'width']
	leftBottom:	['left', 'right', 'bottom', 'height', 'width']
	# RIGHT
	rightTop:	['right', 'left', 'top', 'height', 'width']
	right:		['right', 'left', 0, 'height', 'width']
	rightBottom:['right', 'left', 'bottom', 'height', 'width']

### PREDIFINED POSITIONS ###
_POPUP_ANIM= # [translateX, translateY]
	# TOP
	topLeft:	[-5, -5]
	top:		[0, -5]
	topRight:	[5, -5]
	# BOTTOM
	bottomLeft:	[-5, 5]
	bottom:		[0, 5]
	bottomRight:[5, 5]
	# LEFT
	leftTop:	[-5, -5]
	left:		[-5, 0]
	leftBottom:	[-5, 5]
	# RIGHT
	rightTop:	[5, -5]
	right:		[5, 0]
	rightBottom:[5, 5]

###*
 * Create popup
 * @usedFor showing menues
 * @usedFor showing autocompletes
 * @usedFor showing dropdown
 *
 * @param {HTMLElement}	options.element		- target html element
 * @param {HTMLElement}	options.popup		- popup container
 * @param {Number}		options.margin		- Margin between popup and the element, @default 0
 * @param {Boolean}		options.float		- Change popup position when mission space @default true
 * @param {Boolean}		options.mobile		- Show pupup in full screen for mobiles @default true
 * @param {String}		options.position	- Popup position: top, top-right, right, bottom-right, bottom, bottom-left, left, top-left
 * @param {Function}	options.position	- Set your position logic
 * @example		options.position= function(element, popup, elementRect){ @setPosition(top, left, width, height) }
 *
 * @values options.width and options.height
 *			- fit:		fit popup content
 *			- scroll:	resize popup depending on the available space
 *			- percent%:	popup has: percent% x element.offsetWidth or element.height
 * @Events
 * 		- opening({position}): when start opening the popup
 * 		- open({position}): when popup is open
 * 		- opening({closing}): when start to close popup
 * 		- close({position}): when popup is closed
###
class _Popup extends EventEmitter
	constructor: (options)->
		super()
		# Checks
		throw new Error "Illegal arguments" unless arguments.length is 1 and options?
		throw new Error "Missing options.element" unless options.element
		# attrs
		@_popup=	null
		@_popupList= null # effectif list that contains items
		@_element=	options.element
		@_margin=	options.margin or 0
		@_float=	options.float isnt false	# if moving the popup depending on the available space
		@_mobile=	options.mobile isnt false	# show popup in full screen when mobile device
		@_isOpen=	no
		# Position
		position= options.position
		if typeof position is 'function'
			@_position=	position
		else if position= _POPUP_POSITIONS[position or 'bottom']
			# (element, popup, elementRect, popupRect, margin)->
			@_position= _popupPositionCalc.bind(this, position[0], position[1], position[2], position[3], position[4]);
		else
			throw new Error "Illegal position value: #{position}"
		@_currentPos= null # current position
		# Close options
		@closeOnEsc=	options.closeEsc isnt false
		@closeOnClickOutside= options.closeClickOutside isnt false
		# Listeners
		@_keyup=				@_keyup.bind this
		@_keydown=				@_keydown.bind this
		@_click=				@_click.bind this
		@_closeWindowResize=	@close.bind this
		@_hback= null # history back object
		# Set popup
		(@_divTransp= document.createElement 'div').className='popupTransp'
		@setPopup popupDiv if popupDiv= options.popup
		return
	###* Open popup ###
	open: ->
		throw new Error "Missing popup" unless popupDiv= @_popup
		return this if @_isOpen
		@_isOpen= yes
		# Add transparent div
		document.body.appendChild @_divTransp
		# Router back listener
		ob.cancel() if ob= @_hback
		@_hback= ob.whenBack @_closeWindowResize if ob= Core.defaultRouter
		# Show popup
		# popupDiv= @_popup
		# popupDiv.classList.remove 'hidden'
		# Adjust position
		await @adjust()
		# listener
		currentPos= @_currentPos
		@emit 'opening', position: currentPos
		# Apply animation
		animB= _POPUP_ANIM[currentPos] or _POPUP_ANIM.top
		self= this
		do ->
			# Exec animation
			try
				await popupDiv.animate({
					opacity: [0.5, 1]
					transform: [
						"translateX(#{animB[0]}px) translateY(#{animB[1]}px)"
						""
					]
				}, {duration: Core.ANIM_FAST}).finished
			catch error
				Core.error 'Animate', error
			# Close listeners
			if self._isOpen
				self.emit 'open', position: currentPos
				# Add listeners
				document.addEventListener 'keyup', self._keyup, {capture: yes, passive: yes}
				document.addEventListener 'keydown', self._keydown, {capture: yes, passive: no}
				document.addEventListener 'click', self._click, {capture: yes, passive: yes}
				window.addEventListener 'resize', self._closeWindowResize, {capture: yes, passive: yes}
				window.addEventListener 'scroll', self._closeWindowResize, {capture: no, passive: yes}
			return
		return this # chain
	###* Close popup ###
	close: ->
		return this unless (popupDiv= @_popup) and @_isOpen
		@_isOpen= no
		# remove transparent body
		document.body.removeChild @_divTransp
		# Remove listeners
		document.removeEventListener 'keyup', @_keyup, {capture: yes, passive: yes}
		document.removeEventListener 'keydown', @_keydown, {capture: yes, passive: no}
		document.removeEventListener 'click', @_click, {capture: yes, passive: yes}
		window.removeEventListener 'resize', @_closeWindowResize, {capture: yes, passive: yes}
		window.removeEventListener 'scroll', @_closeWindowResize, {capture: no, passive: yes}
		# Router listener
		@_hback?.cancel()
		# animation
		currentPos= @_currentPos
		@emit 'closing', position: currentPos
		animB= _POPUP_ANIM[currentPos] or _POPUP_ANIM.top
		# Do animation
		self= this
		do ->
			try
				await popupDiv.animate({
					opacity: [1, 0.5]
					transform: ["", "translateX(#{animB[0]}px) translateY(#{animB[1]}px)"]
				}, {duration: Core.ANIM_FAST}).finished
			catch error
				Core.error 'Animation', error
			# After anim
			unless self._isOpen
				self._popup.classList.add 'hidden'
				self.emit 'close', position: currentPos
			return
		return this
	###* toggle ###
	toggle: (doOpen)->
		doOpen ?= !@_isOpen
		return if doOpen then @open() else @close()
	###* Adjust popup position ###
	adjust: ->
		element= @_element
		popupDiv= @_popup
		self= this
		return new Promise (res, rej)->
			requestAnimationFrame ->
				try
					elCl= popupDiv.classList
					elCl.remove 'hidden'
					elementRect= element.getBoundingClientRect()
					elementRect=
						width:	elementRect.width
						height:	elementRect.height
						top:	elementRect.top
						left:	elementRect.left
						right:	innerWidth - elementRect.right
						bottom:	innerHeight - elementRect.bottom
					# if mobile
					popupDiv.style.cssText= ""
					# Large screen
					unless self._mobile and innerWidth <= MOBILE_WIDTH
						# Calc position
						stl= self._position element, popupDiv, elementRect, {width:popupDiv.offsetWidth, height: popupDiv.offsetHeight}, self._margin
						# Adjust popup
						self._currentPos= stl.position or 'top'
						arr= []
						arr.push "#{k}: #{v}px" for k in _POPUP_POS when (v= stl[k])?
						popupDiv.style.cssText= arr.join ';'
					res()
				catch error
					rej error
				return
			return

	###* Clac popup width or height ###
	size: (availableSize, popupW, elementW)->
		v= if popupW < elementW then elementW else popupW # max
		return if v < availableSize then v else availableSize # min

	###* Clac popup height ###
	height: (availableHeight, popupHeight, elementHeight)->
		Math.min availableHeight, Math.max(popupHeight, elementHeight)

	###* If the popup is open ###
	```
	get isOpen(){return this._isOpen;}
	get element(){return this._element;}

	get popup(){return this._popup;}
	get menu(){return this._popupList; }
	```
	setPopup: (popupDiv)->
		this._popup= popupDiv;
		@_popupList?= popupDiv
		# Init popup
		popupClassList= popupDiv.classList
		popupClassList.add 'popup'
		popupClassList.add 'hidden'
		# Popup container: support that the same popup could have multiple button triggers
		if popupArr= popupDiv[POPUP_SYMB] then popupArr.push this
		else popupDiv[POPUP_SYMB]= [this]
		this # chain
	setMenu: (menuDiv)->
		@_popupList= menuDiv
		this # chain

	###* When a controller inside popup has done ###
	done: (component)->
		@close()
		# Check for input
		input= @_element
		if input.classList.contains('f-input') or (input= input.closest('.f-cntrl')) and (input= input.getElementsByClassName('f-input')[0])
			input[INPUT_COMPONENT_SYMB]= component
			strValue= component.strValue or component.value
			if input.formAction then input.value= strValue # form control
			else input.innerText= strValue # otherwise (div, ...)
		return

	###* Keydown listener ###
	_keydown: (event)->
		event.preventDefault() if event.keyCode in [38, 40, 13]
		return
	###* Keyup listener ###
	_keyup: (event)->
		switch event.keyCode
			when 13 # Enter
				# Apply click
				if (c= @_popupList) and (c= c.querySelector(':scope>.active'))
					@close()
					c.click()
			when 27 # ESC
				@close() if @closeOnEsc
			when 37, 39 # Arrow left, Arrow right
				return # ignore
			when 38 # Arrow up
				@up(event)
			when 40 # Arrow down
				@down(event)
		return
	_click: (event)->
		target= event.target
		if @_popup is target.closest('.popup')
			if li= target.closest('[d-value]')
				@setById li.getAttribute 'd-value'
		else if @closeOnClickOutside
			@close()
		return
	###* set value by id ###
	setById: (id)->
		@done {value:id, strValue: id}
		this # chain
	###* Apply <enter> ###
	_apply: (event)->
		if (c= @_popupList) and (c= c.querySelector(':scope>.active'))
			@setById c.getAttribute 'd-value'
		return
	###* list up down ###
	up: (event)-> @_up event, yes
	down: (event)-> @_up event, no
	_up: (event, isUp)->
		return unless resultsDiv= @_popupList
		if li= resultsDiv.querySelector ':scope>.active'
			li.classList.remove 'active'
			if isUp
				if li is resultsDiv.firstElementChild
					li= resultsDiv.lastElementChild
				else
					li= li.previousElementSibling
			else
				if li is resultsDiv.lastElementChild
					li= resultsDiv.firstElementChild
				else
					li= li.nextElementSibling
		else
			li= if isUp then resultsDiv.lastElementChild else resultsDiv.firstElementChild
		# Set value
		li?.classList.add 'active'
		return
