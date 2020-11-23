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
###
class _Popup
	constructor: (options)->
		# Checks
		throw new Error "Illegal arguments" unless options?
		throw new Error "Missing options.element" unless options.element
		throw new Error "Missing options.popup" unless options.popup
		# attrs
		popupDiv=	options.popup
		@_popup=	popupDiv
		@_element=	options.element
		@_margin=	options.margin or 0
		@_float=	options.float isnt false	# if moving the popup depending on the available space
		@_mobile=	options.mobile isnt false	# show popup in full screen when mobile device
		@_isOpen=	no
		@_onOpening=	options.onOpening	# Callback when start opening
		@_onOpen=		options.onOpen		# Callback when open
		@_onClosing=	options.onClosing	# Callback when start closing
		@_onClose=		options.onClose		# Callback when close
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
		@_closeEscListener= (event)=>
			@close() if @closeOnEsc and event.keyCode is 27
			return
		@_closeOutsideListener= (event)=>
			@close() if @closeOnClickOutside and popupDiv isnt event.target.closest('.popup')
			return
		@_closeWindowResize= (event)=>
			@close()
			return
		# Init popup
		popupClassList= popupDiv.classList
		popupClassList.add 'popup'
		popupClassList.add 'hidden'
		return
	###* Open popup ###
	open: ->
		@_isOpen= yes
		# Show popup
		# popupDiv= @_popup
		# popupDiv.classList.remove 'hidden'
		# Adjust position
		await @adjust()
		# listener
		currentPos= @_currentPos
		@_onOpening?(currentPos, this)
		# Apply animation
		animB= _POPUP_ANIM[currentPos] or _POPUP_ANIM.top
		await Core.op(@_popup).stop().animate({
			opacity: [0.5, 1]
			transform: [
				"translateX(#{animB[0]}px) translateY(#{animB[1]}px)"
				""
			]
		}).finished
		# Close listeners
		if @_isOpen
			document.addEventListener 'keyup', @_closeEscListener, {capture: no, passive: yes}
			document.addEventListener 'click', @_closeOutsideListener, {capture: yes, passive: yes}
			window.addEventListener 'resize', @_closeWindowResize, {capture: yes, passive: yes}
			@_onOpen?(currentPos, this)
		return # chain
	###* Close popup ###
	close: ->
		@_isOpen= no
		# Remove listeners
		document.removeEventListener 'keyup', @_closeEscListener, {capture: no, passive: yes}
		document.removeEventListener 'click', @_closeOutsideListener, {capture: yes, passive: yes}
		window.removeEventListener 'resize', @_closeWindowResize, {capture: yes, passive: yes}
		# animation
		currentPos= @_currentPos
		@_onClosing?(currentPos, this)
		animB= _POPUP_ANIM[currentPos] or _POPUP_ANIM.top
		await Core.op(@_popup).stop().animate({
			opacity: [1, 0.5]
			transform: ["", "translateX(#{animB[0]}px) translateY(#{animB[1]}px)"]
			}).finished
		unless @_isOpen
			@_popup.classList.add 'hidden'
			@_onClose?(currentPos, this)
		return
	###* toggle ###
	toggle: (doOpen)->
		doOpen ?= !@_isOpen
		if doOpen
			@open()
		else
			@close()
		this # chain
	###* Adjust popup position ###
	adjust: ->
		element= @_element
		popupDiv= @_popup
		self= this
		return new Promise (res, rej)->
			requestAnimationFrame ->
				try
					elCl= popupDiv.classList
					if isHidden= elCl.contains 'hidden'
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
						if self._mobile and innerWidth <= MOBILE_WIDTH
							popupDiv.style.cssText= ""
							# Large screen
						else
							# Calc position
							stl= self._position element, popupDiv, elementRect, {width:popupDiv.offsetWidth, height: popupDiv.offsetHeight}, self._margin
							# Adjust popup
							self._currentPos= stl.position or 'top'
							arr= []
							arr.push "#{k}: #{v}px" for k in _POPUP_POS when (v= stl[k])?
							popupDiv.style.cssText= arr.join ';'
							# hide element if it is
							# elCl.add 'hidden' if isHidden
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
	get popup(){return this._popup;}
	get element(){return this._element;}
	```
