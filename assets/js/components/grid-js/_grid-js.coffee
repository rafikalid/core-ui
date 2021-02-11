###*
 * Grid JS
###
GRID_DEFAULT=
	col:	50
	row:	50
	colGap: 10
	rowGap: 10
	minWidth: 800 # min width to use grid view
	# Grid cols count, this is a private attribute and will be changed when
	# window resized
	colCount: 1
GRID_RESIZE_CURSORS=
	R:	'e-resize'	# RIGHT
	BR:	'se-resize'	# BOTTOM-RIGHT
	B:	's-resize'	# BOTTOM
GRID_SYMB= Symbol 'GridJs'

# CLASS
Component.defineInit 'grid-js', class GridJs extends Component
	constructor: (element)->
		super element
		element= @element # case when argument element is string
		# Init all elements
		@_enabled= null # if the grid is enabled
		for child in element.children
			child[GRID_SYMB]= new GridJsItem(child, _getPrefixedAttributes child)
		# Events
		@_mouseDown= @_mouseDown.bind this
		@_mouseMove= @_mouseMove.bind this
		# Windows Events
		element.classList.add 'winEvents'
		@on 'window-resize', @_onWinResize
		# Adjust
		@setOptions _getPrefixedAttributes(element)
		return
	# setOptions rowGap, colGap
	setOptions: (options)->
		@_options= _assign {}, options, GRID_DEFAULT
		@adjustView()
		return

	###* Append child ###
	append: (child)->
		return if child[GRID_SYMB] and child.parentNode is @element
		frag= document.createDocumentFragment()
		frag.appendChild child # Accept html elements or document fragment
		# Init content
		Core.init frag
		# Add private values
		for child in frag.children
			child[GRID_SYMB]= new GridJsItem(child, _getPrefixedAttributes child)
		this # chain
	###* Remove child ###
	removeChild: (child)->
		this # chain
	### window resize ###
	_onWinResize: (event)->
		@adjustView()
		return
	###* @private Addjust view ###
	adjustView: ->
		element= @element
		options= @_options
		# width
		isEnabled= element.offsetWidth > options.minWidth
		# Enable
		if isEnabled isnt @_enabled
			@_enabled= isEnabled
			# Remove previous events
			listenersOpts= {capture: no, passive: yes}
			element.removeEventListener 'mousemove', @_mouseMove, listenersOpts
			element.removeEventListener 'mousedown', @_mouseDown, listenersOpts
			# Style
			style= @element.style
			style.columnGap=	options.colGap + 'px'
			style.rowGap=		options.rowGap + 'px'
			# Enable Grid
			if isEnabled
				# Enable events
				element.addEventListener 'mousemove', @_mouseMove, listenersOpts
				element.addEventListener 'mousedown', @_mouseDown, listenersOpts
				# Enable style
				style.gridTemplateColumns= "repeat(auto-fill, minmax(#{options.col}px, 1fr))"
				style.gridAutoRows=	"#{options.row}px"
			# Disable Grid
			else
				style.gridTemplateColumns= ''
				style.gridAutoRows=	''
			# Enable items
			for child in element.children
				child[GRID_SYMB].adjustView isEnabled
		# Calc Grids cols
		options.colCount= window.getComputedStyle(element).gridTemplateColumns.split(' ').length
		return
	###* @private Mouse move ###
	_mouseMove: (event)->
		element= @element
		target= event.target
		unless target is element
			# Get the child
			child= target
			child= target while (target= target.parentNode) isnt element
			# Check for resize area
			st= target.style
			childOptions= child[GRID_SYMB]._options
			if resizeAreaCursor= _gridJsResizeArea child, childOptions, event
				st.cursor= resizeAreaCursor
			else
				st.removeProperty('cursor')
		return
	###* @private Mouse down ###
	_mouseDown: (event)->
		options= @_options
		gridContainer= @element
		target= event.target
		return if target is gridContainer # Not grid child
		# Get Child
		child= target
		child= target while (target= target.parentNode) isnt gridContainer
		childOptions= child[GRID_SYMB]._options
		# If resize item
		if resizeAreaCursor= _gridJsResizeArea child, childOptions, event
			originalWidth= child.offsetWidth
			originalHeight= child.offsetHeight
			originalX= event.x
			originalY= event.y
			# Listeners
			listenerOpts= {capture: no, passive: yes}
			holderDv= null
			resizeListener= (evnt)->
				switch resizeAreaCursor
					when GRID_RESIZE_CURSORS.R
						w= originalWidth + evnt.x - originalX
						h= originalHeight
					when GRID_RESIZE_CURSORS.B
						w= originalWidth
						h= originalHeight + evnt.y - originalY
					else # BR
						w= originalWidth + evnt.x - originalX
						h= originalHeight + evnt.y - originalY
				if holderDv
					st= holderDv.style
					st.width= w+'px'
					st.height= h+'px'
				else
					holderDv= _toHTMLElement Core.html.gridHolder
						w: w
						h: h
						x: child.offsetLeft
						y: child.offsetTop
					gridContainer.appendChild holderDv
				return
			mouseUpListener= (evnt)=>
				# Remove events
				document.removeEventListener 'mousemove', resizeListener, listenerOpts
				document.removeEventListener 'mouseup', mouseUpListener, listenerOpts
				# If changed
				if holderDv
					# Cacl changes
					colSpan= Math.round holderDv.offsetWidth/(options.col + options.colGap)
					rowSpan= Math.round holderDv.offsetHeight/(options.row + options.rowGap)
					# Remove holder
					gridContainer.removeChild holderDv
					# Fix changes
					if colSpan > options.colCount
						colSpan= options.colCount
					if colSpan > childOptions.maxCols then colSpan= childOptions.maxCols
					else if colSpan < childOptions.minCols then colSpan= childOptions.minCols
					# Fix rows
					if rowSpan > childOptions.maxRows then rowSpan= childOptions.maxRows
					else if rowSpan < childOptions.minRows then rowSpan= childOptions.minRows
					# Apply changes
					st= child.style
					st.gridColumn= "auto / span #{colSpan}"
					st.gridRow= "auto / span #{rowSpan}"
					# Save data
					childOptions.cols= colSpan
					childOptions.rows= rowSpan
					# Trigger changers
					data= {type: 'resize', item: child, cols: colSpan, rows: rowSpan}
					@emit 'resize', data
					if childComp= Component.getComponent child
						childComp.emit 'resize', data
				return
			document.addEventListener 'mousemove', resizeListener, listenerOpts
			document.addEventListener 'mouseup', mouseUpListener, listenerOpts
		# else if drag it
		else if childOptions.draggable
			# Original values
			childIndex= _elementIndexOf child
			originalX= event.x
			originalY= event.y
			originalTop= child.offsetTop
			originalLeft= child.offsetLeft
			# Listeners
			holderDv= null
			moveListener= (evnt)->
				x= originalLeft + evnt.x - originalX
				y= originalTop + evnt.y - originalY
				if holderDv
					st= holderDv.style
					st.top= y+'px'
					st.left= x+'px'
				else
					holderDv= _toHTMLElement Core.html.gridHolder
						w: child.offsetWidth
						h: child.offsetHeight
						x: x
						y: y
					gridContainer.appendChild holderDv
				return
			mouseUpListener= (evnt)=>
				# Detach event listeners
				document.removeEventListener 'mousemove', moveListener, listenerOpts
				document.removeEventListener 'mouseup', mouseUpListener, listenerOpts
				# Remove holder
				gridContainer.removeChild holderDv
				# Get closest child
				closestChild= targetElement= document.elementFromPoint(evnt.x, evnt.y)
				while (targetElement= targetElement.parentNode) and targetElement isnt gridContainer
					closestChild= targetElement
				# If found a child
				if closestChild and (closestChild isnt child) and (closestChild.parentNode is gridContainer)
					closestChildRect= closestChild.getBoundingClientRect()
					isInsertBefore= (evnt.x - closestChildRect.x) < (closestChildRect.width / 2)
					closestChild.insertAdjacentElement (if isInsertBefore then 'beforebegin' else 'afterend'), child
					# Trigger event
					data= {type: 'move', item: child, target: closestChild, isBefore: isInsertBefore}
					@emit 'move', data
					if childComp= Component.getComponent child
						childComp.emit 'move', data
				return
			document.addEventListener 'mousemove', moveListener, listenerOpts
			document.addEventListener 'mouseup', mouseUpListener, listenerOpts
		return
