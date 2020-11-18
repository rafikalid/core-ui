###*
 * @param {String}	x, xAlt	-	'top', 'bottom'
 * @param {String}	y	-	'right'
 * @param {String}	popupW	-	'width' or 'height'
 *
 * @example	_popupPositionCalc(elementRect, 'top', 'bottom', 'right', popupRect, 'width', 'height', margin);
###
_popupPositionCalc= (x, xAlt, y, popupY, popupX, element, popup, elementRect, popupRect, margin)->
	# result
	result=
		position:	"#{x}-#{y}"
		top:		null
		bottom:		null
		left:		null
		right:		null
		width:		null
		height:		null
	w= result[popupX]= @size (if popupX is 'width' then innerWidth else innerHeight), popupRect[popupX], elementRect[popupX]
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
		size= _min popupSize, availableSpace
		topAlt= availableSpace - size
		isAlterred= yes
	# Position
	pos= if isAlterred then xAlt else x
	result.position= if y then "#{pos}#{y.charAt(0).toUpperCase()}#{y.substr(1)}" else pos
	result[x]= top
	result[xAlt]= topAlt
	result[popupY]= size
	# x axe
	left= w - elementRect[popupX]
	left /= 2 unless y
	left= elementRect[y] - left
	left= 0 if left < 0
	result[y]= left
	return result

### PREDIFINED POSITIONS ###
_POPUP_POS= ['top', 'right', 'bottom', 'left']
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
	left:		['left', 'right', null, 'height', 'width']
	leftBottom:	['left', 'right', 'bottom', 'height', 'width']
	# RIGHT
	rightTop:	['right', 'left', 'top', 'height', 'width']
	right:		['right', 'left', null, 'height', 'width']
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
 * @param {Boolean}		options.float		- Change popup position when mission space
 * @param {Boolean}		options.mobile		- Show pupup in full screen for mobiles
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
		# Position
		position= options.position
		if typeof position is 'function'
			@_position=	position
		else if position= _POPUP_POSITIONS[position]
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
		popupDiv= @_popup
		popupDiv.classList.remove 'hidden'
		# Adjust position
		@adjust()
		# Close listeners
		document.addEventListener 'keyup', @_closeEsc, {capture: no, passive: yes}
		document.addEventListener 'click', @_closeOutsideListener, {capture: yes, passive: yes}
		window.addEventListener 'resize', @_closeWindowResize, {capture: yes, passive: yes}
		# Apply animation
		anime.remove popupDiv
		animB= _POPUP_ANIM[@_currentPos] or _POPUP_ANIM.top
		anime
			targets: popupDiv
			opacity: [0.5, 1]
			translateX:	[animB[0], 0]
			translateY:	[animB[1], 0]
		this # chain
	###* Close popup ###
	close: ->
		# # TODO: animation
		@_popup.classList.add 'hidden'
		@_isOpen= no
		# Close listeners
		document.removeEventListener 'keyup', @_closeEsc, {capture: no, passive: yes}
		document.removeEventListener 'click', @_closeOutsideListener, {capture: yes, passive: yes}
		window.removeEventListener 'resize', @_closeWindowResize, {capture: yes, passive: yes}
		return
	###* Adjust popup position ###
	adjust: ->
		element= @_element
		elementRect= element.getBoundingClientRect()
		# if mobile
		popupStyle= @_popup.style
		if @_mobile and innerWidth <= MOBILE_WIDTH
			popupStyle.top= popupStyle.left= 0
			popupStyle.width= popupStyle.height= '100%'
		# Large screen
		else
			# Clear popup style
			popupStyle.removeProperty('top')
			popupStyle.removeProperty('left')
			popupStyle.removeProperty('width')
			popupStyle.removeProperty('height')
			# Calc position
			stl= @_position element, @_popup, elementRect, {width:popup.offsetWidth, height: popup.offsetHeight}, @_margin
			# Adjust popup
			@_currentPos= stl.position or 'top'
			popupStyle[k]= v for k in _POPUP_POS when v= stl[k]
		return this # chain

	###* Clac popup width or height ###
	size: (availableSize, popupW, elementW)->
		Math.min(availableSize, Math.max(popupW, elementW))

	###* Clac popup height ###
	height: (availableHeight, popupHeight, elementHeight)->
		Math.min availableHeight, Math.max(popupHeight, elementHeight)

	###* If the popup is open ###
	```
	get isOpen(){return @_isOpen;}
	get popup(){return @_popup;}
	get element(){return @_element;}
	```
