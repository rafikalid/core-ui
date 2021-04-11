###*
 * Grid JS
###
GRID_DEFAULT=
	col:	50
	row:	50
	colGap: 10
	rowGap: 10
	minWidth: 600 # min width to use grid view
	# Grid cols count, this is a private attribute and will be changed when
	# window resized
	colCount: 1
GRID_RESIZE_CURSORS=
	R:	'e-resize'	# RIGHT
	BR:	'se-resize'	# BOTTOM-RIGHT
	B:	's-resize'	# BOTTOM
GRID_SYMB= Symbol 'GridJs'

# Widgets
_gridJsWidgetsMap= new Map()

# CLASS
Component.defineInit 'grid-js', class GridJs extends Component
	constructor: (element)->
		super element
		element= @element # case when argument element is string
		# Init all elements
		@_enabled= null # if the grid is enabled
		@_widgets= new Map() # store created widgets
		for child in element.children
			new GridJsItem(child, _getPrefixedAttributes child)
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
	appendChild: (child)->
		container= @element
		return if child[GRID_SYMB] and child.parentNode is container
		frag= document.createDocumentFragment()
		frag.appendChild child # Accept html elements or document fragment
		# Init content
		Core.init frag
		# Add private values
		for child in frag.children
			new GridJsItem(child, _getPrefixedAttributes child)
		container.appendChild frag
		this # chain
	###* Remove child ###
	removeChild: (child)->
		# prepare
		if child instanceof GridJsItem
			childOb= child
			child= child.element
		else
			childOb= child[GRID_SYMB]
			throw new Error "Illegal element!" unless childOb
		# remove
		@element.removeChild child
		@_widgets.delete childOb
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
			for child in element.children when childObj= child[GRID_SYMB]
				childObj.adjustView isEnabled
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
			childOptions= child[GRID_SYMB].attrs
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
		childOptions= child[GRID_SYMB].attrs
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

	###* Append Widgets ###
	append: (arr)->
		throw new Error "Illegal arguments" unless arguments.length is 1 and _isArray(arr)
		frag= document.createDocumentFragment()
		widgetMap= @_widgets
		for item in arr
			try
				throw new Error "Missing item.id" unless item.id
				throw new Error "Missing item.name" unless item.name
				throw new Error "Unknown widget: #{item.name}" unless clazz= _gridJsWidgetsMap.get item.name
				childOb= new clazz item
				frag.appendChild childOb.element
				widgetMap.set item.id, childOb
			catch error
				Core.fatalError 'Widget', error
		# Init content
		Core.init frag
		@element.appendChild frag
		this # chain

	###* WIDGETS ###
	@Widget: GridJsWidget
	@define: (name, constructor)->
		throw new Error "Illegal arguments" unless arguments.length is 2 and typeof name is 'string' and typeof constructor is 'function'
		throw new Error "Already defined widget: #{name}" if _gridJsWidgetsMap.has name
		throw new Error "Expected to extend ::Widget" unless constructor.prototype instanceof GridJsWidget
		_gridJsWidgetsMap.set name, constructor
		this # chain

	# Get created widget
	getWidget: (id)-> @_widgets.get id

	# Remove all
	clear: ->
		widgets= @_widgets
		widgets.forEach (v, k)->
			v.clear()
			return
		widgets.clear()
		return
