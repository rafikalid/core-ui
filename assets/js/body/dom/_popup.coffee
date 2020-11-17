###*
 * @param {String}	x, xAlt	-	'top', 'bottom'
 * @param {String}	y	-	'right'
 * @param {String}	popupW	-	'width' or 'height'
 *
 * @example	_popupPositionCalc(elementRect, 'top', 'bottom', 'right', popupRect, 'width', 'height', margin);
###
_popupPositionCalc= (obj, elementRect, x, xAlt, y, popupRect, popupY, popupX, margin)->
	# result
	result=
		position:	"#{x}-#{y}"
		top:		null
		bottom:		null
		left:		null
		right:		null
		width:		null
		height:		null
	w= result[popupX]= obj.size (if popupX is 'width' then innerWidth else innerHeight), popupRect[popupX], elementRect[popupX]
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
	topLeft: (element, popup, elementRect, popupRect, margin)->
		return _popupPositionCalc(elementRect, 'top', 'bottom', 'left', popupRect, 'width', 'height', margin);
	top: (element, popup, elementRect, popupRect, margin)->
		return _popupPositionCalc(elementRect, 'top', 'bottom', null, popupRect, 'width', 'height', margin);
	topRight: (element, popup, elementRect, popupRect, margin)->
		return _popupPositionCalc(elementRect, 'top', 'bottom', 'right', popupRect, 'width', 'height', margin);
	# BOTTOM
	bottomLeft: (element, popup, elementRect, popupRect, margin)->
		return _popupPositionCalc(elementRect, 'bottom', 'top', 'left', popupRect, 'width', 'height', margin);
	bottom: (element, popup, elementRect, popupRect, margin)->
		return _popupPositionCalc(elementRect, 'bottom', 'top', null, popupRect, 'width', 'height', margin);
	bottomRight: (element, popup, elementRect, popupRect, margin)->
		return _popupPositionCalc(elementRect, 'bottom', 'top', 'right', popupRect, 'width', 'height', margin);
	# LEFT
	leftTop: (element, popup, elementRect, popupRect, margin)->
		return _popupPositionCalc(elementRect, 'left', 'right', 'top', popupRect, 'height', 'width', margin);
	left: (element, popup, elementRect, popupRect, margin)->
		return _popupPositionCalc(elementRect, 'left', 'right', null, popupRect, 'height', 'width', margin);
	leftBottom: (element, popup, elementRect, popupRect, margin)->
		return _popupPositionCalc(elementRect, 'left', 'right', 'bottom', popupRect, 'height', 'width', margin);
	# RIGHT
	rightTop: (element, popup, elementRect, popupRect, margin)->
		return _popupPositionCalc(elementRect, 'right', 'left', 'top', popupRect, 'height', 'width', margin);
	right: (element, popup, elementRect, popupRect, margin)->
		return _popupPositionCalc(elementRect, 'right', 'left', null, popupRect, 'height', 'width', margin);
	rightBottom: (element, popup, elementRect, popupRect, margin)->
		return _popupPositionCalc(elementRect, 'right', 'left', 'bottom', popupRect, 'height', 'width', margin);

### PREDIFINED POSITIONS ###
_POPUP_ANIM=
	# TOP
	topLeft:
		translateX: -5
		translateY: -5
	top:
		translateY: -5
	topRight:
		translateX: 5
		translateY: -5
	# BOTTOM
	bottomLeft:
		translateX: -5
		translateY: 5
	bottom:
		translateY: 5
	bottomRight:
		translateX: 5
		translateY: 5
	# LEFT
	leftTop:
		translateX: -5
		translateY: -5
	left:
		translateX: -5
	leftBottom:
		translateX: -5
		translateY: 5
	# RIGHT
	rightTop:
		translateX: 5
		translateY: -5
	right:
		translateX: 5
	rightBottom:
		translateX: 5
		translateY: 5

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
		else unless @_position= _POPUP_POSITIONS[position]
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
		animObj=
			targets: popupDiv
			opacity: [0.5, 1]
		animObj[k]= [animB[k], 0] for k in animB when animB.hasOwnProperty k
		anime animObj
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
